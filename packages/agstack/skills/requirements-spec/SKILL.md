---
name: requirements-spec
description: "Turn a request into testable requirements with acceptance criteria, non-functional limits, and explicit exclusions before any code is written. Use at the start of a feature, a change to behaviour, or any task where the request describes a goal rather than a check."
---

# Requirements spec

A request states a goal. Code needs a check. This skill writes the bridge: each requirement becomes an observable behaviour with a test that proves it, so "done" has a meaning before the work starts.

## Output

Write the spec at `.verify/specs/<slug>.md`:

```markdown
# <slug>
## Goal
<the user's outcome, in one sentence>
## Requirements
R1. <behaviour> (Given <context>, When <action>, Then <observable result>)
R2. ...
## Non-functional limits
- Latency: <limit, or none stated>
- Compatibility: <what must keep working>
- Data: <what changes, what must not change>
## Out of scope
- <explicit exclusions>
## Open questions
- <question, with the default>
```

## Steps

1. **State the goal** in the user's words. If the words are vague, find the concrete outcome by reading the code and the existing tests (`skills/intent-clarification`).
2. **Write one requirement per observable behaviour.** A requirement that cannot be checked by a test, a command, or an observation is rewritten until it can.
3. **Give each requirement its check.** Name the test that will prove it, or the command. A requirement with no check is marked "unverified: no check yet".
4. **List the non-functional limits** that apply, using the numbers from the repository or the user. Do not invent a latency budget.
5. **Name what is out of scope,** so the work does not grow into it (`skills/scope-guard`).
6. **Stop and confirm** only when a requirement is a product decision the repository cannot settle.

## Rules

- Every requirement starts from a state the reader can observe: an input, a response, a file, an exit code.
- Error behaviour is a requirement. For each input the feature accepts, state what happens on invalid input.
- Do not write requirements about internal structure ("uses a HashMap"). Write them about behaviour.
- Keep the spec short enough to read in a minute. If it is longer, split the feature.
