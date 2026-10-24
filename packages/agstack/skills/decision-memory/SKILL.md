---
name: decision-memory
description: "Record each decision once in a decision log and check the log before deciding again. Use when a choice is about to be made that may already have been made in this task, this repository, or a past session, or when the same question is being asked a second time."
---

# Decision memory

Agents repeat decisions. They re-choose a library, re-open a naming question, or undo a choice made an hour earlier, because the earlier choice is not in their context. Each repeat costs time, and some undo work that was already verified. This skill makes decisions durable and cheap to look up.

## The log

Keep one file per repository at `.verify/decisions.md`. Each entry is one decision:

```markdown
## D-<number>: <short title>
- Date: <YYYY-MM-DD>
- Decision: <what was chosen, in one sentence>
- Why: <the constraint or evidence that decided it>
- Rejected: <the alternatives and the reason each lost>
- Status: active | superseded by D-<n>
```

## Steps

1. **Before deciding,** search the log for the topic (`grep_search` on the title keywords). If an active entry covers it, follow the entry. Do not re-decide.
2. **To change a decision,** add a new entry that supersedes the old one, and set the old entry's status. Never delete an entry.
3. **After deciding** a choice that will matter later (a library, a data shape, an interface, a naming scheme, a rollout order), add an entry before the next step.
4. **Record only decisions that recur or constrain.** Do not log every edit.

## Rules

- A decision needs its reason. "Chosen because the user asked" is a reason. "It seemed cleaner" is not evidence and must not be recorded as a why.
- If the reason is that the user chose it, quote the user's words.
- When a logged decision looks wrong, raise it with the user as a single question that names the entry. Do not silently override it.
- Keep entries short. The log is read at the start of tasks, so a long entry costs context on every read.

## Example

```markdown
## D-7: Use the shared guard for command validation
- Date: 2026-10-20
- Decision: Mouth and muscle validate commands through the body-core guard.
- Why: One policy and one corpus across organs (the parity corpus test).
- Rejected: Per-organ validators (drift between organs was the bug in D-3).
- Status: active
```
