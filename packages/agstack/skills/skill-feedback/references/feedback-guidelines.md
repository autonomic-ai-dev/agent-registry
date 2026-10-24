# Skill feedback guidelines

These rules apply to every rating written with `sh scripts/skill-feedback.sh rate`. The script enforces the note fields. The rest is up to you, and the report is only as useful as the notes.

## When to rate

- Rate at the end of a task, once per skill, and only for a skill that shaped a decision or a step.
- Rate a skill you read but did not use: no.
- Rate a failure immediately if it blocked the task. Write the note while the detail is fresh.
- Do not rate the same skill twice for one task. If it changed mid-task, rate the version you used and say so.

## The scale

| Rating | Meaning | Note required |
|---|---|---|
| 5 | Right, specific, and it changed a decision for the better | No |
| 4 | Helped; one small gap | No, but a short note helps |
| 3 | Usable, but a step was unclear or missing | Yes: `Change:` |
| 2 | Misled you or wasted effort | Yes: `Change:` and `Evidence:` |
| 1 | Caused a defect or blocked the task | Yes: `Change:` and `Evidence:` |

Rate the skill as written. If you deviated from it, say so, and rate the skill for the step you followed.

## What a note contains

Use these labels, in this order, separated by a full stop and a space:

- `Context:` the task in a few words.
- `Observed:` what happened, as facts.
- `Change:` one concrete edit: the file, the section or step, and what to add, remove, or reword.
- `Evidence:` the command and its output, the file path and line, or the observed behaviour. Required for ratings 1 and 2.

Example, accepted (rating 3):

```text
sh scripts/skill-feedback.sh rate figure-it-out 3 "Context: add a viewport flag. Observed: the allowlist check ran from the crate and returned 127. Change: in SKILL.md Phase 3, say every check runs from the repository root."
```

Example, rejected by the script:

```text
sh scripts/skill-feedback.sh rate figure-it-out 3 "unclear"
```

The script rejects this with: `needs a note with 'Change:'`. It also rejects any note under 40 characters, because a note that short cannot say what to change.

## Notes that are not accepted

The script accepts a note that contains the required label. It does not check quality, so these are rules for you:

- A `Change:` that does not name a file or section. "Make it clearer" is not a change.
- A `Change:` that is a general wish. "Add more examples" is not a change; "add a worked example of a rejected note under Notes that are not accepted" is.
- An `Evidence:` that is an opinion. "It felt wrong" is not evidence.
- Praise in a low rating. Ratings 1 to 3 are for the problem only.

## Privacy and secrets

- Do not write tokens, keys, credentials, customer data, or private paths outside the repository into a note.
- Do not name a person. Write "the reviewer" or "the user".
- The log is read by other people, so write each note as if it were public inside the team.

## What happens to a rating

1. `sh scripts/skill-feedback.sh report` writes `REPORT.md` and prints it.
2. The report lists the averages, then every suggestion from a rating of 3 or lower, then every entry.
3. A suggestion is acted on in its own change to the skill. That change is verified (`skills/verification`) and reviewed like any other.
4. Do not edit the log to remove a rating. If a rating was wrong, add a new one that says why it was wrong.
5. When a suggestion is applied, the next rating for that skill should say whether the change helped.

## Calibration

- Use the whole scale. A skill that is always 5 has not been tested.
- Compare with the last rating for the same skill, not with other skills.
- A skill that was right on a task that did not need it is rated 4 or 5 with a note that the task was simple; it is not rated higher for being present.
