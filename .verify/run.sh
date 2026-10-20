#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$DIR/.." && pwd)"

echo "==> [agent-registry] Starting verification suite..."
cd "$REPO_ROOT"

for file in *.json; do
  echo "==> Validating JSON: $file"
  jq -e . "$file" >/dev/null
done

echo "==> [agent-registry] Verification passed cleanly (exit 0)."
