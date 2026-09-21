#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
for md in content/*/speech*.md; do
  [ -e "$md" ] || { echo "ERR: no content/*/speech*.md"; exit 1; }
  echo "== $md =="
  ./make_tts.sh "$md"
  ./make_video.sh "$md"
done
echo "ALL DONE"