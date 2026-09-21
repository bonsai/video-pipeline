#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

usage() { echo "usage: $0 <content>/<repo>/speech-*.md [bg.png]"; exit 1; }
[ $# -ge 1 ] || usage
MD="$1"
REPO="$(basename "$(dirname "$MD")")"
NAME="${REPO}-$(basename "$MD" .md)"
BG="${2:-assets/bg.png}"
TTS="tts/$NAME.mp3"
OUT="videos/$NAME.mp4"
[ -f "$TTS" ] || { echo "ERR: $TTS missing. run make_tts.sh first"; exit 1; }
[ -f "$BG" ] || { echo "ERR: $BG missing"; exit 1; }

DUR="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$TTS")"
echo "audio: $DUR s"

ffmpeg -y \
  -loop 1 -i "$BG" -i "$TTS" \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,fade=t=in:st=0:d=0.5,fade=t=out:st=$(python3 -c "print(max(0,$DUR-0.5))"):d=0.5,format=yuv420p" \
  -c:v libx264 -preset medium -crf 20 -c:a aac -b:a 128k -shortest -movflags +faststart \
  "$OUT"
echo "video done: $OUT"