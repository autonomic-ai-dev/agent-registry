#!/bin/sh
set -eu

here="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$here/.cursor"
rsync -a --delete "$here/skills/" "$here/.cursor/skills/"
echo "synced $here/.cursor/skills from $here/skills"
