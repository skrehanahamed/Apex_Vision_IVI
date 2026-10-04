#!/usr/bin/env python3
"""
==============================================================================
APEX VISION IVI — Live Real-Time Network Transmission Monitor to Raspberry Pi 5
Target: 192.168.1.217 (rpi5)
Features:
  - Real-time Pi 5 data transmission dashboard
  - Live upload & download throughput gauge (KB/s / MB/s)
  - Total cumulative session data transferred
  - Zero-overhead persistent SSH streaming
==============================================================================
"""

import subprocess
import time
import sys
import os

TARGET_HOST = "rpi5"
TARGET_IP = "192.168.1.217"

def format_bytes(b):
    if b < 1024:
        return f"{b:6.1f} B"
    elif b < 1024 * 1024:
        return f"{b / 1024:6.2f} KB"
    elif b < 1024 * 1024 * 1024:
        return f"{b / (1024 * 1024):6.2f} MB"
    else:
        return f"{b / (1024 * 1024 * 1024):6.2f} GB"

def make_bar(speed_kbs, max_speed_kbs=2000.0, width=22):
    ratio = min(1.0, max(0.0, speed_kbs / max_speed_kbs))
    filled = int(round(ratio * width))
    empty = width - filled
    return "█" * filled + "░" * empty

def render_dashboard(rx_speed, tx_speed, session_rx, session_tx, elapsed_sec, active_iface):
    mins = elapsed_sec // 60
    secs = elapsed_sec % 60
    time_str = f"{mins:02d}:{secs:02d}"

    bar_rx = make_bar(rx_speed / 1024.0, max_speed_kbs=5000.0, width=24)
    bar_tx = make_bar(tx_speed / 1024.0, max_speed_kbs=1000.0, width=24)

    # ANSI Colors
    CYAN = "\033[1;36m"
    GREEN = "\033[1;32m"
    YELLOW = "\033[1;33m"
    BLUE = "\033[1;34m"
    MAGENTA = "\033[1;35m"
    BOLD = "\033[1m"
    RESET = "\033[0m"
    DIM = "\033[2m"

    sys.stdout.write("\033[H\033[J")  # Clear screen and move to top
    print(f"{CYAN}╔══════════════════════════════════════════════════════════════════╗{RESET}")
    print(f"{CYAN}║{RESET}  {BOLD}🚀 APEX VISION IVI — Real-Time Network Monitor to Pi 5{RESET}         {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  Target: {GREEN}{TARGET_IP:<14}{RESET} Interface: {YELLOW}{active_iface:<8}{RESET} Session: {MAGENTA}{time_str:<6}{RESET}    {CYAN}║{RESET}")
    print(f"{CYAN}╠══════════════════════════════════════════════════════════════════╣{RESET}")
    print(f"{CYAN}║{RESET}                                                                  {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  {BOLD}📤 DATA TRANSMITTED TO PI 5 (Host ➔ Pi 5 Incoming / RX):{RESET}       {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}     Rate:   {GREEN}{format_bytes(rx_speed):>10}/s{RESET}  [{CYAN}{bar_rx}{RESET}]           {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}     Total:  {GREEN}{format_bytes(session_rx):>10}{RESET}  (Transferred this session)           {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}                                                                  {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}  {BOLD}📥 DATA RECEIVED FROM PI 5 (Pi 5 ➔ Host Outgoing / TX):{RESET}       {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}     Rate:   {BLUE}{format_bytes(tx_speed):>10}/s{RESET}  [{MAGENTA}{bar_tx}{RESET}]           {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}     Total:  {BLUE}{format_bytes(session_tx):>10}{RESET}                                        {CYAN}║{RESET}")
    print(f"{CYAN}║{RESET}                                                                  {CYAN}║{RESET}")
    print(f"{CYAN}╚══════════════════════════════════════════════════════════════════╝{RESET}")
    print(f" {DIM}Press Ctrl+C to exit anytime.{RESET}")
    sys.stdout.flush()

def main():
    print("Connecting to Pi 5 stream monitor...")
    remote_cmd = (
        'while true; do '
        'cat /proc/net/dev; '
        'echo "===TICK==="; '
        'sleep 1; '
        'done'
    )
    ssh_cmd = [
        "ssh", "-o", "ConnectTimeout=10", "-o", "ServerAliveInterval=2", TARGET_HOST, remote_cmd
    ]

    try:
        proc = subprocess.Popen(ssh_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    except Exception as e:
        print(f"Error launching SSH: {e}")
        return

    buffer_lines = []
    base_rx = None
    base_tx = None
    last_rx = None
    last_tx = None
    last_time = time.time()
    start_time = last_time
    active_iface = "wlan0"

    try:
        for line in proc.stdout:
            line_str = line.strip()
            if line_str == "===TICK===":
                # Process collected lines
                current_rx = 0
                current_tx = 0
                found = False
                for b_line in buffer_lines:
                    if b_line.startswith("wlan0:") or b_line.startswith("eth0:"):
                        iface = b_line.split(":", 1)[0]
                        parts = b_line.split(":", 1)[1].split()
                        if len(parts) >= 9:
                            rx = int(parts[0])
                            tx = int(parts[8])
                            current_rx += rx
                            current_tx += tx
                            if rx > 0:
                                active_iface = iface
                            found = True

                buffer_lines = []
                now = time.time()

                if found:
                    if base_rx is None:
                        base_rx = current_rx
                        base_tx = current_tx
                        last_rx = current_rx
                        last_tx = current_tx
                        last_time = now
                        continue

                    dt = max(0.1, now - last_time)
                    rx_speed = max(0, (current_rx - last_rx) / dt)
                    tx_speed = max(0, (current_tx - last_tx) / dt)
                    session_rx = max(0, current_rx - base_rx)
                    session_tx = max(0, current_tx - base_tx)
                    elapsed = int(now - start_time)

                    render_dashboard(rx_speed, tx_speed, session_rx, session_tx, elapsed, active_iface)

                    last_rx = current_rx
                    last_tx = current_tx
                    last_time = now
            else:
                buffer_lines.append(line_str)
    except KeyboardInterrupt:
        print("\nMonitor stopped.")
    finally:
        try:
            proc.terminate()
        except Exception:
            pass

if __name__ == "__main__":
    main()
