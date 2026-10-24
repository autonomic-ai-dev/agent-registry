---
name: skill-feedback
description: "Rate the agstack skills you used on a task and record concrete improvements in a shared feedback log, then produce the report on request. Use at the end of a task that relied on one or more agstack skills, when a skill was wrong, missing a step, or caused a problem, and when the user asks for the skill report."
---

# Skill feedback

The skills improve only when their use is measured. This skill has the agent rate each skill it relied on, write down what would make it better, and keep the record in one place the user can read with one command.

## When to rate

- At the end of a task, for each skill that shaped a decision or a step.
- Right away, when a skill was wrong or caused a defect. Record the problem while the detail is fresh.
- Do not rate a skill you only read and did not use.

## How to rate

Use the script in the agstack package. Each call records one rating:

```text
sh scripts/skill-feedback.sh rate <skill> <1-5> "<note>"
```

- `5`: the skill was right and specific, and it helped.
- `4`: it helped, with a small gap.
- `3`: it was usable, but a step was unclear or missing. The note must state the improvement.
- `2`: it misled or wasted effort. The note must state what it got wrong and the change that fixes it.
- `1`: it caused a defect or a blocked task. The note must state the failure and its evidence.

The script enforces the note fields. A rating of 3 or lower needs `Change:` and at least 40 characters. A rating of 1 or 2 also needs `Evidence:`. Use the labels in this order: `Context:`, `Observed:`, `Change:`, `Evidence:`.

The full rules, the scale, examples of accepted and rejected notes, and what happens to a rating are in `references/feedback-guidelines.md`. Read them with `sh scripts/skill-feedback.sh guidelines` before the first rating of a session.

The script rejects an unknown skill name, so use the folder name under `skills/`. It replaces a pipe character in a note with a slash, so the log stays one entry per line.

## Report

```text
sh scripts/skill-feedback.sh report
```

This prints the full report and writes it to `REPORT.md` in the feedback folder. The report holds the averages per skill, every suggestion from a rating of 3 or lower, and every entry. Give the user the path and the top suggestions. Do not paste the whole report unless asked.

## Rules

- Rate honestly. A high rating from a skill you did not follow is wrong. Rate the skill as written, and say in the note if you deviated.
- Suggest a change only when you can state what it would do. "Make it better" is not a suggestion.
- Do not edit a skill to act on a suggestion during the task that found it. Record it, and change the skill in its own change with its own verification.
- The feedback folder is outside the repository by default, so the record is not committed by accident. Do not put secrets or private data in a note.
