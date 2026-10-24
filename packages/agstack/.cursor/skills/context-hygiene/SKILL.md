---
name: context-hygiene
description: "Keep the agent's context small and relevant. Use when a session is long, when reads are large, when tool output is noisy, when the agent starts forgetting earlier decisions, or before a task that will read many files."
---

# Context hygiene

Context is the agent's working memory, and every token of it competes with the task. Bloated context makes the agent slower, more expensive, and less accurate, and it is the usual cause of repeated work and forgotten constraints. This skill sets the budget and the habits that keep it.

## Budget rules

- Read a file only in the range you need. Search for the symbol first (`grep_search`), then read the matching lines and a few lines of context.
- Never read build output, `node_modules`, `target`, `dist`, lock files, or generated files. Search them with a pattern if you must.
- Cap a command's output. Pipe long logs through `tail` or a pattern, and keep the matching lines, not the whole log.
- Do not repeat a read you already made in this session. Keep the fact you need in a short note instead.

## Summarise and drop

When a phase ends, replace its raw output with a summary of three to six lines: what was decided, what changed (paths), what was verified (command and exit code), and what is still open. Drop the raw output from your working notes. Keep the summary.

## Signs the context is bloated

- You are about to re-read a file you read earlier in the same task.
- You cannot state the task's acceptance criteria in two lines.
- A decision is being made again that was made earlier.
- Tool output you do not need is still being carried forward.

When two or more signs show, stop and write the summary in the task's notes. Then continue from the summary.

## Starting fresh

Start a new session when the task has moved to a different area, or when the summary is longer than the remaining work. Write the handoff (`skills/handoff`) first, so the new session starts from the summary rather than from this transcript.

## Rules

- A summary must name the paths, commands, and decisions it covers. A summary such as "fixed the bug" loses the information it was meant to keep.
- Do not summarise away a constraint. Constraints from the user, from the mode, and from the repository stay in the context until the task ends.
- Measure before optimising: a read that returns under 100 lines is not a problem.
