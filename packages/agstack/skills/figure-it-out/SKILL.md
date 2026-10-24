---
name: figure-it-out
description: "Take an open-ended goal from problem to finished result without a stream of questions. Frames the problem, designs the workflow and its playbook, sets up the verification, runs it, loops until the measured desired state is reached, and leaves an audit report for human review. Use when the user states a goal and the path is not given, when the agent keeps asking what to do next, or when the user wants the task completed rather than discussed."
---

# Figure it out

The user gives a goal. This skill turns it into a finished result by working out the path itself, checking each step with evidence, and recording every decision so a human can review the whole run afterwards. The human is asked only for things the agent cannot find, decide safely, or do itself.

## The rule for questions

Ask at most one question, and only when one of these holds:

1. The next step is an outward or irreversible action with no prior authorization (a merge, a release, a deletion, a message to someone outside the team, a spend).
2. The answer is a fact only the human has (a credential, a product preference that changes the result, a business rule written nowhere in the repository).
3. Two or more readings would produce results that cannot be compared, and no check can tell them apart.

For anything else, pick the most reasonable default, record it as a decision (`skills/decision-memory`), and list it in the audit report under "Decisions made without you". Each decision names its reason and what would change it.

## Output

Create these files under `.verify/`. Keep them current as the run changes:

| File | Purpose |
|---|---|
| `.verify/figure-it-out/<slug>/problem.md` | The framed problem: goal, desired state, constraints, what is out of scope |
| `.verify/figure-it-out/<slug>/playbook.md` | The workflow for this task, in the playbook format (`references/playbook-template.md`) |
| `.verify/figure-it-out/<slug>/checks.toml` | The verification commands, also added to `.verify/verify.toml` |
| `.verify/figure-it-out/<slug>/log.md` | One line per iteration: time, step, check, result, next |
| `.verify/figure-it-out/<slug>/audit.md` | The review report (`references/audit-template.md`) |

`<slug>` is a short kebab-case name for the task. The directory is the run's record. Nothing in it is deleted when the task completes.

## Phase 1: Frame the problem

1. Restate the goal in one sentence, in the user's terms.
2. Define the desired state as observable results: the command that must exit 0, the metric that must reach a value, the screen that must match. A desired state without a measurement is not yet framed. Measure it, or say which measurement is missing.
3. Find the current state with a measurement, not a description. Run the measurement now.
4. List the constraints from the repository, the mode, and the user: what must not change, what is authorized, what budget applies.
5. Write the out-of-scope list (`skills/scope-guard`).

Use `skills/requirements-spec` for the acceptance criteria, and `skills/intent-clarification` for the defaults.

## Phase 2: Design the workflow

1. Find out whether a playbook already fits. Search `playbooks/` in the mode and in `.verify/playbooks/`. Use it when it fits, and cite it.
2. Otherwise, write a workflow of ordered steps. Each step has an input, an action, a check that proves the step, and a rollback. Keep the steps in dependency order (`skills/planning`).
3. Write the playbook as `playbook.md` using the template. It is the workflow that the next iteration follows, so write it as numbered steps with checks, not prose.
4. Name the loop's exit: the desired-state measurement, and the maximum number of iterations.

## Phase 3: Set up the verification

1. Write each check as a literal command. A check that depends on a judgement is not a check: turn the judgement into a measured threshold, and record the threshold before the first run.
2. Add the commands to `.verify/verify.toml`, and check that each one runs through `agent-brain verify -- <cmd>`.
3. Run each check once against the current state. A check that passes before any work is either not measuring the goal or the goal is already met. Find out which before continuing.
4. Use `skills/feature-map` when the repository keeps one: link each check to the behaviour it proves.

## Phase 4: Run and loop

Run the playbook one step at a time. After each step, run its check.

- **Check passes:** log it, move to the next step.
- **Check fails:** read the failure, fix its cause, and run the check again. Two failures of the same kind trigger `skills/loop-breaker`: change the hypothesis, do not repeat the fix.
- **Desired state reached:** stop the loop and go to Phase 5.
- **Maximum iterations reached (default 10):** stop, write the blocker into the audit report, and report to the user.
- **No progress in three iterations:** stop, and write what was tried and what the measurement shows.
- **A step needs an action from the list in "The rule for questions":** stop that step, record it, and ask the one question. Continue with the independent steps while the answer is pending.

Each iteration writes a line to `log.md`: the iteration number, the step, the check's command and exit code, and the measured value.

## Phase 5: Audit and complete

1. Re-run every check once more on the final state. Record the results.
2. Write `audit.md` using the template. It must be readable without this transcript.
3. Confirm the desired state against its measurement. Quote the number.
4. State the task complete only when the measurement says so. If it does not, the status is "blocked" and the audit names the blocker.
5. Run `skills/skill-feedback` for each skill the run used.

## Rules

- A question is a last resort. When in doubt, decide, record the decision, and report it.
- Outward actions are never taken without authorization. Preparing them is allowed: draft the PR, the release notes, or the message, and stop before sending.
- Do not weaken a check to reach the desired state. Changing a threshold, an assertion, or an allowlist entry to pass is a blocker, not a fix.
- The audit report is the human's review surface. Write it for a reader who was not present: decisions first, then evidence, then open risks.
- Keep the run's files in `.verify/`. Do not write them into the source tree.
