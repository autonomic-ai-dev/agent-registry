#!/usr/bin/env bash
set -euo pipefail

MODE="working"
if [[ "${1:-}" == "--staged" ]]; then
  MODE="staged"
elif [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: check-verify-separation.sh [--staged]"
  echo "Verifies strict separation between read-only reference fixtures in verify/ and runtime outputs in .verify/."
  exit 0
fi

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

ERRORS=0

# 1. Assert input reference fixture directory (verify/) immutability
if [[ -d "verify" ]]; then
  DIRTY_FIXTURES=$(git status --porcelain verify/ 2>/dev/null || true)
  if [[ -n "$DIRTY_FIXTURES" ]]; then
    echo "ERROR [verify-separation]: Static reference fixture directory 'verify/' has been dirtied or modified:" >&2
    echo "$DIRTY_FIXTURES" >&2
    echo "Input reference fixtures in 'verify/' are STRICTLY READ-ONLY. All runtime artifacts must output to '.verify/'." >&2
    ERRORS=$((ERRORS + 1))
  fi
fi

# 2. Assert no test output artifacts escaped into the root or src directories
DISALLOWED_PATTERNS=(
  "*.log"
  "junit*.xml"
  "test-results.xml"
  "lcov.info"
  "coverage.out"
)

# Search root and src/ for stray test output files (ignoring .verify, target, node_modules, .git)
for pat in "${DISALLOWED_PATTERNS[@]}"; do
  STRAY_FILES=$(find . -maxdepth 2 -name "$pat" \
    -not -path "*/.verify/*" \
    -not -path "*/target/*" \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*" \
    -not -path "*/.svelte-kit/*" \
    -not -path "*/dist/*" 2>/dev/null || true)
  
  if [[ -n "$STRAY_FILES" ]]; then
    echo "ERROR [verify-separation]: Test artifact '$pat' detected outside '.verify/':" >&2
    echo "$STRAY_FILES" >&2
    echo "All test logs, reports, and generated harnesses must output strictly under '.verify/' (e.g. .verify/artifacts/)." >&2
    ERRORS=$((ERRORS + 1))
  fi
done

# 3. Assert disallowed coverage directories outside .verify/
for cov_dir in "coverage" ".nyc_output" "test-results"; do
  if [[ -d "$cov_dir" && "$cov_dir" != ".verify"* ]]; then
    # If it is tracked or has untracked files
    if git status --porcelain "$cov_dir" 2>/dev/null | grep -q .; then
      echo "ERROR [verify-separation]: Test report directory '$cov_dir' detected outside '.verify/':" >&2
      echo "Configure test runners and coverage reporters to output under '.verify/artifacts/$cov_dir'." >&2
      ERRORS=$((ERRORS + 1))
    fi
  fi
done

if [[ $ERRORS -gt 0 ]]; then
  echo "" >&2
  echo "Verification separation check FAILED with $ERRORS error(s)." >&2
  echo "Fix the output targets to .verify/ and revert any changes to verify/ before committing." >&2
  exit 1
fi

exit 0
