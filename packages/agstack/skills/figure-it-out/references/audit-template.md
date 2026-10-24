# Audit report template

Use this format for `.verify/figure-it-out/<slug>/audit.md`. It is the document a reviewer reads first, so it leads with the outcome and the decisions, and the evidence follows.

```markdown
# Audit: <task>

Status: complete | blocked | stopped at iteration limit
Goal: <the user's outcome>
Desired state: <measurement and target>
Result: <final measured value, with the command that produced it>
Iterations: <count> of <maximum>
Run: <date, branch or commit, machine>

## Decisions made without you
- D-<n>: <decision>. Reason: <evidence or constraint>. Changes if: <condition>.

## Questions asked
- <question>, answered by <answer and date>, or "none".

## Changes
- <path>: <what changed, one line>

## Verification
| Check | Command | Exit | Result | Artifact |
|---|---|---|---|---|
| <name> | `<command>` | 0 | <measured value> | <path> |

## Iterations
| # | Step | Check | Result | Next |
|---|---|---|---|---|
| 1 | <step> | <check> | <value> | <next step> |

## Not verified
- <what was not checked, and why>

## Risks and open items
- <risk or item, with the action that would close it>

## To review first
1. <the decision or change most likely to be wrong, and why>
```

Rules for the report:

- A status of "complete" requires the desired-state check to exit 0 on the final state, and the report to quote it.
- Every decision made without the user is listed, even minor ones. The reviewer decides which to keep.
- "Not verified" is never empty by omission. If everything was verified, write "none", and say which checks would catch a regression.
- Keep the report under three pages. Put the full logs in the artifacts and link them.
