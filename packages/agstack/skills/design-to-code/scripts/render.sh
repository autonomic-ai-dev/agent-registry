#!/bin/sh
set -eu

html="$1"
width="$2"
height="$3"
out="$4"

case "$html" in
  /*) ;;
  *) echo "render.sh: html path must be absolute: $html" >&2; exit 2 ;;
esac

npx -y playwright@1.55.0 screenshot --full-page --wait-for-timeout 1000 \
  --viewport-size "$width,$height" "file://$html" "$out"
