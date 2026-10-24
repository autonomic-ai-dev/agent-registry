---
name: progress-report
description: "Report progress on a multi-step task so the user can act on it. Use for any task that will take more than a few steps, at each milestone, when blocked, and when handing back work. Gives state, evidence, and the next decision, in a fixed shape."
---

# Progress report

A progress report answers three questions for the reader: where things stand, what they need to know or decide, and what happens next. Reports that narrate effort do not help the reader act. This skill fixes the shape so every report can be scanned in ten seconds.

## Shape

Use these headings, in this order, and omit a heading only when it is empty:

1. **Status:** one line. `done`, `in progress: <step>`, or `blocked: <blocker>`.
2. **Done:** the changes made, as paths and one-line effects. Each claim cites its evidence (see `skills/claim-evidence`).
3. **Verified:** the checks run, with their command and exit code. Write "not run" for a check that did not run, and why.
4. **Needs you:** each decision the user must make, as one question with the default (see `skills/intent-clarification`). Leave the section out when there is none.
5. **Next:** the next step, and the condition that moves the task forward.

## When to send

- At each milestone: a stage finished, a check passed or failed, a branch or PR was created.
- When blocked, immediately. Do not wait until the task ends to report a blocker.
- At the end of the task, as the final report.

Between milestones, send nothing. A long silence is not a problem; a report with nothing new is noise.

## Rules

- Lead with the status. A reader who stops after the first line still knows where things stand.
- Do not report an intention as progress. "Will run the tests" is not done.
- Use numbers from the output. "Most tests pass" is not a count; "440 passed, 0 failed" is.
- Keep a report under 15 lines. Put the detail in a file and link it.
- If the plan changed, say what changed and why, in one line. Do not hide the change.
