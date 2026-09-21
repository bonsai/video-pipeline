#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

SPEED="${SPEED:-1.5}"
GITTS="${GTTS:-gtts-cli}"
TLD="${TLD:-co.jp}"

usage() { echo "usage: $0 <content>/<repo>/speech-*.md"; exit 1; }
[ $# -eq 1 ] || usage
MD="$1"
REPO="$(basename "$(dirname "$MD")")"
NAME="${REPO}-$(basename "$MD" .md)"
OUT="tts/$NAME.mp3"
WORK="tts/.$NAME.work"
mkdir -p "$WORK"

# 本文抽出: frontmatter / 見出し / メタ行 / 引用 / 太字記号を除去し、文単位に分割
clean() {
  sed -E \
    -e '/^---$/,$d' \
    -e 's/^#+ .*//' \
    -e 's/^\*>.*//' \
    -e 's/^\*[^*].*//' \
    -e 's/^\*.*\*.*//' \
    -e 's/^\s*\[.*\]\s*(\(.*\))?\s*$//' \
    -e 's/\*\*//g' \
    "$1"
}
clean_len() {
  local t
  t="$(clean "$1" | sed -E '/^[[:space:]]*$/d' | tr -d '[:space:]')"
  printf '%s' "${#t}"
}

MSG="$(clean "$MD" | sed -E '/^[[:space:]]*$/d')"
LEN="$(printf '%s' "$MSG" | tr -d '[:space:]' | wc -m)"
[ "$LEN" -gt 0 ] || { echo "ERR: empty script"; exit 1; }
echo "chars: $LEN (expect ~720 for 90s fast talk)"

# 句点区切りで1文=1行
while IFS= read -r line; do
  [ -z "$line" ] && continue
  line="$(printf '%s' "$line" | sed -E 's/。/。\n/g')"
  [ -z "$line" ] && continue
  printf '%b\n' "$line"
done <<< "$MSG" | while IFS= read -r s; do
  [ -z "${s// /}" ] && continue
  printf '%s\n' "$s"
done > "$WORK/sentences.txt"

# 文ごとに gtts で mp3 生成 (並列 P=4)
mkdir -p "$WORK"
i=0
while IFS= read -r s; do
  [ -z "$s" ] && continue
  printf '%s\t%s\n' "$(printf '%05d' "$i")" "$s"
  i=$((i+1))
done < "$WORK/sentences.txt" > "$WORK/jobs.tsv"

[ "$i" -gt 0 ] || { echo "ERR: no sentences"; exit 1; }
export GITTS TLD WORK
shopt -s nullglob
rm -f "$WORK"/*.mp3 "$WORK"/*.done
gen() {
  n="$1"; s="$2"
  f="$WORK/$n.mp3"
  for a in 1 2 3; do
    if printf '%s' "$s" | "$GITTS" -l ja --tld "$TLD" -f - -o "$f" 2>/dev/null; then
      [ -s "$f" ] && break
    fi
    sleep 2
  done
  [ -s "$f" ] && : > "$f.done"
}
export -f gen
pids=()
while IFS=$'\t' read -r n s; do
  gen "$n" "$s" & pids+=($!)
  if [ "${#pids[@]}" -ge 3 ]; then wait "${pids[@]}"; pids=(); fi
done < "$WORK/jobs.tsv"
[ "${#pids[@]}" -gt 0 ] && wait "${pids[@]}"
echo "sentences: $i"

# 連結 (concat demuxer)
CONCAT="$WORK/concat.txt"
: > "$CONCAT"
for f in "$WORK/"*.mp3; do
  printf "file '%s'\n" "$(basename "$f")"
done > "$CONCAT"
ffmpeg -y -f concat -safe 0 -i "$CONCAT" -codec copy "$OUT" 2>/dev/null
# concat 不整合対策: 失敗時は再エンコード
if [ ! -s "$OUT" ]; then
  ffmpeg -y -f concat -safe 0 -i "$CONCAT" -c:a libmp3lame "$OUT"
fi
rm -rf "$WORK"
# 早口化 (atempo, ピッチ保持)。既定 1.5
if [ "$SPEED" != "1" ] && [ -s "$OUT" ]; then
  mv "$OUT" "$OUT.tmp"
  ffmpeg -y -i "$OUT.tmp" -filter:a "atempo=$SPEED" "$OUT" 2>/dev/null
  rm -f "$OUT.tmp"
fi
echo "TTS done: $OUT (x$SPEED)"