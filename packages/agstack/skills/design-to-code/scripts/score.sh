#!/bin/sh
set -eu

manifest="$1"
threshold="${2:-98}"
out="${OUT_DIR:-.verify/artifacts/design-loop}"

mkdir -p "$out"
fail=0
while IFS="$(printf '\t')" read -r name url width height reference; do
  [ -n "$name" ] || continue
  candidate="$out/$name.png"
  npx -y playwright@1.55.0 screenshot --full-page --wait-for-timeout 1000 \
    --viewport-size "$width,$height" "$url" "$candidate" >/dev/null
  agent-eyes diff "$reference" "$candidate" --output "$out/$name.diff.png" > "$out/$name.json"
  ref_dims=$(sed -n 's/.*"reference": "\([0-9x]*\)".*/\1/p' "$out/$name.json")
  cand_dims=$(sed -n 's/.*"comparison": "\([0-9x]*\)".*/\1/p' "$out/$name.json")
  if [ "$ref_dims" != "$cand_dims" ]; then
    echo "$name size mismatch: reference=$ref_dims candidate=$cand_dims" >&2
    fail=1
    continue
  fi
  pct=$(sed -n 's/.*"diff_percent": "\([0-9.]*\)".*/\1/p' "$out/$name.json")
  match=$(awk -v p="$pct" 'BEGIN { printf "%.2f", 100 - p }')
  echo "$name match=$match% threshold=$threshold% diff=$out/$name.diff.png"
  if ! awk -v m="$match" -v t="$threshold" 'BEGIN { exit !(m + 0 >= t + 0) }'; then
    fail=1
  fi
done < "$manifest"
exit "$fail"
