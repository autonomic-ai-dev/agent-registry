#!/bin/sh
set -eu

here="$(cd "$(dirname "$0")/.." && pwd)"

if ! diff -rq "$here/skills" "$here/.cursor/skills" > /dev/null 2>&1; then
  echo "check-mirror-sync: .cursor/skills differs from skills/. Run scripts/sync-mirrors.sh." >&2
  diff -rq "$here/skills" "$here/.cursor/skills" >&2 || true
  exit 1
fi
echo "check-mirror-sync: .cursor/skills matches skills/"
