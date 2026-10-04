#!/usr/bin/env python3
"""
APEX VISION IVI — Stream Transmission Progress Monitor
Usage in pipeline:
    tar -czf - ... | python3 scripts/pipe-progress.py [EXPECTED_BYTES] | ssh rpi5 ...
"""

import sys
import time

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

def make_bar(percent, width=16):
    filled = int(round((percent / 100.0) * width))
    empty = width - filled
    return "█" * filled + "░" * empty

def main():
    expected_bytes = 0
    if len(sys.argv) > 1:
        try:
            expected_bytes = int(sys.argv[1])
        except ValueError:
            expected_bytes = 0

    total_bytes = 0
    start_time = time.time()
    last_update = start_time
    last_bytes = 0
    speed_str = "0.00 MB/s"

    try:
        while True:
            chunk = sys.stdin.buffer.read(CHUNK_SIZE)
            if not chunk:
                break
            sys.stdout.buffer.write(chunk)
            total_bytes += len(chunk)

            now = time.time()
            if now - last_update >= 0.2:
                delta_t = now - last_update
                delta_b = total_bytes - last_bytes
                speed = delta_b / delta_t if delta_t > 0 else 0
                speed_str = f"{format_bytes(speed)}/s"

                elapsed = int(now - start_time)
                mins = elapsed // 60
                secs = elapsed % 60
                elapsed_str = f"{mins:02d}:{secs:02d}"

                progress_part = ""
                if expected_bytes > 0:
                    pct = min(99.9, (total_bytes / expected_bytes) * 100.0)
                    bar = make_bar(pct, width=14)
                    progress_part = f"| \033[1;36m[{bar}] {pct:5.1f}%\033[0m "

                sys.stderr.write(
                    f"\r \033[1;36m📡 Transmitting to Pi 5:\033[0m \033[1;32m{format_bytes(total_bytes):>9}\033[0m "
                    f"{progress_part}"
                    f"| \033[1;33mSpeed:\033[0m {speed_str:>10} "
                    f"| \033[1;35mElapsed:\033[0m {elapsed_str}   "
                )
                sys.stderr.flush()
                last_update = now
                last_bytes = total_bytes

        total_time = max(0.01, time.time() - start_time)
        avg_speed = total_bytes / total_time
        sys.stderr.write(
            f"\r \033[1;32m✅ Transmitted to Pi 5:\033[0m \033[1;37m{format_bytes(total_bytes)}\033[0m "
            f"in \033[1;35m{total_time:.1f}s\033[0m "
            f"(Avg: \033[1;33m{format_bytes(avg_speed)}/s\033[0m)                       \n"
        )
        sys.stderr.flush()
    except BrokenPipeError:
        sys.stderr.write("\n\033[1;31m❌ Connection lost during transfer.\033[0m\n")
        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(130)

if __name__ == "__main__":
    main()
