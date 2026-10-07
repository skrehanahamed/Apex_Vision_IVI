#!/usr/bin/env python3
"""
==============================================================================
Project: Apex VISION IVI - Digital Cockpit & Infotainment System
File: scripts/apex_news_tts.py
Purpose: Hybrid Neural Speech Synthesis & Audio Dictation Engine for Pi 5
Author: Sk Rehan Ahamed
License: MIT
==============================================================================
"""

import sys
import os
import argparse
import hashlib
import urllib.parse
import urllib.request

CACHE_DIR = "/opt/apex_vision_ivi/cache/tts"
FALLBACK_CACHE = "/tmp/apex_tts_cache"

def get_cache_dir():
    for d in [CACHE_DIR, FALLBACK_CACHE]:
        try:
            os.makedirs(d, exist_ok=True)
            test_file = os.path.join(d, ".perm_test")
            with open(test_file, "w") as f:
                f.write("1")
            os.remove(test_file)
            return d
        except Exception:
            continue
    return "/tmp"

def split_text(text, max_len=140):
    words = text.split()
    chunks = []
    curr = []
    curr_len = 0
    for w in words:
        if curr_len + len(w) + 1 > max_len:
            if curr:
                chunks.append(" ".join(curr))
            curr = [w]
            curr_len = len(w)
        else:
            curr.append(w)
            curr_len += len(w) + 1
    if curr:
        chunks.append(" ".join(curr))
    return chunks

def synthesize_text(text, output_path):
    chunks = split_text(text)
    if not chunks:
        return False
    
    tmp_path = output_path + ".tmp"
    try:
        with open(tmp_path, "wb") as out:
            for c in chunks:
                encoded = urllib.parse.quote(c)
                url = f"https://translate.google.com/translate_tts?ie=UTF-8&tl=en&client=tw-ob&q={encoded}"
                req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"})
                with urllib.request.urlopen(req, timeout=4.5) as resp:
                    out.write(resp.read())
        if os.path.exists(tmp_path) and os.path.getsize(tmp_path) > 500:
            os.replace(tmp_path, output_path)
            return True
    except Exception as e:
        if os.path.exists(tmp_path):
            try:
                os.remove(tmp_path)
            except Exception:
                pass
        return False
    return False

def main():
    parser = argparse.ArgumentParser(description="Apex Vision News TTS Engine")
    parser.add_argument("--text", type=str, required=True, help="Text to speak")
    parser.add_argument("--play", action="store_true", help="Play audio immediately")
    parser.add_argument("--rate", type=float, default=1.0, help="Speech rate")
    args = parser.parse_args()

    clean_text = args.text.strip()
    if not clean_text:
        sys.exit(0)

    cache_dir = get_cache_dir()
    text_hash = hashlib.md5(clean_text.encode("utf-8")).hexdigest()
    output_mp3 = os.path.join(cache_dir, f"{text_hash}.mp3")

    # If not cached, synthesize online
    if not (os.path.exists(output_mp3) and os.path.getsize(output_mp3) > 1000):
        success = synthesize_text(clean_text, output_mp3)
        if not success:
            # Exit cleanly if network is unreachable
            sys.exit(1)

    if args.play and os.path.exists(output_mp3):
        # Directly replace python process with gst-launch-1.0 playbin
        # Same PID allows QProcess::kill() in C++ to instantly terminate playback!
        try:
            os.execvp("gst-launch-1.0", ["gst-launch-1.0", "-q", "playbin", f"uri=file://{output_mp3}", "audio-sink=alsasink"])
        except Exception:
            sys.exit(0)

if __name__ == "__main__":
    main()
