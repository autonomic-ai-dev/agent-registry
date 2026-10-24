---
name: loop-breaker
description: "Stop repeating a failing attempt. Use when the same test, command, or fix has failed twice, when the agent keeps editing the same lines without progress, or when a retry loop has no new information. Forces a change of hypothesis or an escalation with evidence."
---

# Loop breaker

Agents get stuck in loops: the same failing test, the same edit reverted, the same command run again with no change. Each loop costs time and context, and it rarely converges. This skill detects the loop and forces a different move.

## Detect

A loop is present when any of these holds:

- The same command has failed twice with the same error, and nothing relevant changed between the runs.
- The same file has been edited three times in the same region without the failing check moving.
- The agent is about to try an approach it has already tried in this task.

## Break

1. **Stop editing.** Do not make a fourth attempt on the same hypothesis.
2. **Write the state in three lines:** the failing check, its exact error, and the hypothesis that has been tested and failed.
3. **Form a different hypothesis.** It must differ in kind, not in detail. Changing a value is the same kind. Changing the layer you are looking at (the caller instead of the callee, the input instead of the code) is a different kind.
4. **Gather one piece of new evidence** that tests the new hypothesis: a log line, a smaller reproduction, a run with a single variable changed.
5. **If the second hypothesis also fails,** stop and escalate (below). Do not start a third in the same session without a new piece of information from the user or the environment.

## Escalate

Report the blocker with evidence:

- the check and its last exact output,
- each hypothesis tested and its result,
- what would settle the question (the specific log, input, or environment the user can provide).

Ask one question. State the assumption you would make if the user does not answer, and proceed on it only if it is safe.

## Rules

- A retry is not a loop when the environment changed: a dependency was installed, a service started, a file was regenerated. Name the change before you retry.
- Do not weaken the check to end the loop. Changing an assertion or a threshold to pass is not a fix (`skills/principles/fix-root-causes`).
- Keep the count. Two failures of the same kind is the trigger, not three.
