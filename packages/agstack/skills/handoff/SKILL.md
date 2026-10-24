---
name: handoff
description: "Write a handoff note so work can resume in a fresh session or be picked up by another person or agent. Use when a session is ending, when the context is full, when pausing a task, or when passing work to someone else."
---

# Handoff

A handoff lets the next reader resume without rereading the whole session. It records the state, the decisions, and the next step, and nothing else. The note is the new session's starting context, so it must be short and exact.

## Where

Write the note to `.verify/handoff/<task-slug>.md`. Overwrite it when the task advances. Keep one note per task.

## Shape

```markdown
# Handoff: <task>
- Updated: <date>
- Goal: <one sentence, the user's outcome>
- State: <done | in progress: step | blocked: reason>

## Done
- <path or artifact>: <what changed, one line>

## Verified
- <command>: exit <n>, <result> (<artifact path>)

## Decisions
- D-<n>: <decision>, in the decision log (or "none")

## Open
- <question or task>, with the default if the user does not answer

## Next
1. <the first action for the next reader, as a command or a file to open>
```

## Steps

1. **Write the goal first,** in the user's words.
2. **List only what changed,** with paths. Do not list what was read.
3. **Copy the verification results** verbatim, with exit codes and artifact paths. Do not re-run to fill the section.
4. **Link decisions** to the decision log rather than copying them.
5. **Make Next executable.** "Continue the fix" is not a next step. "Run `cargo test -p agent-body gateway` and read the first failure in `.verify/artifacts/`" is.

## Rules

- The note must not depend on this transcript. A reader who has only the note and the repository can resume.
- Do not include secrets, tokens, or private paths outside the repository.
- If the state is unknown, write "unknown" and the reason. Do not guess the state.
- Keep the note under one page. If it is longer, the task is too large for one handoff: split the task.
