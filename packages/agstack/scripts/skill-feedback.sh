#!/bin/sh
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
skills_dir="$here/../skills"
dir="${AGSTACK_FEEDBACK_DIR:-$HOME/.autonomic/agstack/feedback}"
log="$dir/feedback.md"
report="$dir/REPORT.md"
cmd="${1:-}"

mkdir -p "$dir"

case "$cmd" in
  rate)
    skill="${2:?usage: skill-feedback.sh rate <skill> <1-5> <note>}"
    rating="${3:?usage: skill-feedback.sh rate <skill> <1-5> <note>}"
    note="$(printf '%s' "${4:-}" | tr '|' '/')"
    [ -f "$skills_dir/$skill/SKILL.md" ] || { echo "unknown skill: $skill" >&2; exit 2; }
    case "$rating" in
      [1-5]) ;;
      *) echo "rating must be 1, 2, 3, 4, or 5" >&2; exit 2 ;;
    esac
    if [ "$rating" -le 3 ] && [ -z "$note" ]; then
      echo "a rating of 3 or lower needs a note that states the improvement" >&2
      exit 2
    fi
    printf -- '- %s | %s | %s | %s\n' "$(date -u +%Y-%m-%dT%H:%MZ)" "$skill" "$rating" "$note" >> "$log"
    echo "recorded $skill=$rating in $log"
    ;;
  report)
    if [ ! -f "$log" ]; then
      echo "no feedback yet: $log"
      exit 0
    fi
    {
      echo "# agstack skill feedback report"
      echo
      echo "Generated $(date -u +%Y-%m-%dT%H:%MZ) from $log"
      echo
      echo "## Scores"
      echo
      echo "| Skill | Ratings | Average |"
      echo "|---|---|---|"
      awk -F' [|] ' '{ n[$2]++; s[$2] += $3 } END { for (k in n) printf "| %s | %d | %.2f |\n", k, n[k], s[k] / n[k] }' "$log" | sort
      echo
      echo "## Suggestions (ratings of 3 or lower)"
      echo
      awk -F' [|] ' '$3 <= 3 { print "- **" $2 "** (" $3 ", " substr($1, 3) "): " $4 }' "$log"
      echo
      echo "## All entries"
      echo
      cat "$log"
    } > "$report"
    cat "$report"
    ;;
  *)
    echo "usage: skill-feedback.sh rate <skill> <1-5> <note> | report" >&2
    exit 2
    ;;
esac
