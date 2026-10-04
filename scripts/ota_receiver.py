#!/usr/bin/env python3
"""
==============================================================================
APEX VISION IVI — Target-Side OTA Stream Receiver & On-Screen Progress Bridge
Receives binary stream from stdin, unpacks to destination, and updates
/tmp/ota_progress.json for real-time display on the IVI cockpit screen.
==============================================================================
"""

import sys
import os
import time
import json
import subprocess

PROGRESS_FILE = "/tmp/ota_progress.json"
CHUNK_SIZE = 65536  # 64 KB

def format_bytes(num_bytes):
    if num_bytes < 1024:
        return f"{num_bytes:.0f} B"
    elif num_bytes < 1024 * 1024:
        return f"{num_bytes / 1024:.2f} KB"
    elif num_bytes < 1024 * 1024 * 1024:
        return f"{num_bytes / (1024 * 1024):.2f} MB"
    else:
        return f"{num_bytes / (1024 * 1024 * 1024):.2f} GB"

def main():
    total_bytes = 0
    if len(sys.argv) > 1:
        try:
            total_bytes = int(sys.argv[1])
        except ValueError:
            total_bytes = 0

    dest_dir = sys.argv[2] if len(sys.argv) > 2 else "/opt/apex_vision_ivi"
    os.makedirs(dest_dir, exist_ok=True)

    # Initial state
    initial_state = {
        "status": "uploading",
        "percent": 0,
        "speed": "Connecting...",
        "received": "0 B",
        "total": format_bytes(total_bytes) if total_bytes > 0 else "Calculating...",
        "eta": "--",
        "component": "Streaming Apex Vision Core & Assets..."
    }
    with open(PROGRESS_FILE + ".tmp", "w") as f:
        json.dump(initial_state, f)
    os.replace(PROGRESS_FILE + ".tmp", PROGRESS_FILE)

    tar_proc = subprocess.Popen(
        ["tar", "-xzf", "-", "-C", dest_dir],
        stdin=subprocess.PIPE
    )

    received_bytes = 0
    start_time = time.time()
    last_update = start_time
    last_bytes = 0

    try:
        while True:
            chunk = sys.stdin.buffer.read(CHUNK_SIZE)
            if not chunk:
                break
            tar_proc.stdin.write(chunk)
            received_bytes += len(chunk)

            now = time.time()
            if now - last_update >= 0.1:  # 10 updates per second
                delta_t = now - last_update
                delta_b = received_bytes - last_bytes
                speed = delta_b / delta_t if delta_t > 0 else 0
                last_update = now
                last_bytes = received_bytes

                percent = 0
                eta_str = "--"
                if total_bytes > 0:
                    percent = min(99.0, (received_bytes / total_bytes) * 100.0)
                    rem_bytes = max(0, total_bytes - received_bytes)
                    if speed > 0:
                        rem_sec = int(rem_bytes / speed)
                        eta_str = f"~{rem_sec}s" if rem_sec < 60 else f"~{rem_sec // 60}m {rem_sec % 60}s"

                state = {
                    "status": "uploading",
                    "percent": percent,
                    "speed": f"{format_bytes(speed)}/s",
                    "received": format_bytes(received_bytes),
                    "total": format_bytes(total_bytes) if total_bytes > 0 else "Calculating...",
                    "eta": eta_str,
                    "component": "Flashing Core Binary & Assets..."
                }
                with open(PROGRESS_FILE + ".tmp", "w") as f:
                    json.dump(state, f)
                os.replace(PROGRESS_FILE + ".tmp", PROGRESS_FILE)

        tar_proc.stdin.close()
        tar_proc.wait()

        # Finished successfully
        final_state = {
            "status": "completed",
            "percent": 100.0,
            "speed": "Done",
            "received": format_bytes(received_bytes),
            "total": format_bytes(received_bytes),
            "eta": "0s",
            "component": "System Verified & Ready!"
        }
        with open(PROGRESS_FILE + ".tmp", "w") as f:
            json.dump(final_state, f)
        os.replace(PROGRESS_FILE + ".tmp", PROGRESS_FILE)

    except Exception as e:
        sys.stderr.write(f"Error in ota_receiver: {e}\n")
        tar_proc.kill()
        sys.exit(1)

if __name__ == "__main__":
    main()
