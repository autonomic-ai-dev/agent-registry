---
name: planning
description: "Break a multi-step change into ordered, independently verifiable steps with risks and rollback. Use before starting any task that touches more than one module, changes an interface or data, or will take more than one session."
---

# Planning

A plan is a sequence of steps where each step ends in a state that can be checked. Without that, a large change fails late and cannot be unwound. This skill writes the plan before the first edit.

## Output

Write the plan at `.verify/plans/<slug>.md`:

```markdown
# <slug>
## Target
<the end state, in terms of the requirements (see skills/requirements-spec)>
## Steps
1. <change> | check: <command or observation> | rollback: <how to undo>
2. ...
## Risks
- <risk>: likelihood, impact, mitigation
## Order rationale
<why this order: what each step unblocks>
```

## Steps

1. **Map the affected code** with `grep_search` and the feature map. List each module, interface, and data shape the change touches.
2. **Order by dependency.** Put the change that everything else depends on first. Put changes that can be verified in isolation before ones that need the whole system.
3. **Make each step leave the system working.** A step that breaks the build until the next step is merged is two steps merged into one. Split it or reorder it.
4. **Attach a check to each step.** The check must run in under a few minutes, or it is split.
5. **Attach a rollback to each step.** For a data or interface change, the rollback is a compatibility plan (old and new readers both work during the change).
6. **Flag the risky step** and put a check before it, so failure is found early.

## Rules

- Keep a plan to the number of steps that can be reviewed in one sitting. Larger work becomes a multi-phase plan (`playbooks/multi-phase-plan.md`).
- A plan that cannot name a check for a step is not finished. Mark the step "unverified" and say what is needed to verify it.
- Update the plan when reality changes. Record the change in the decision log (`skills/decision-memory`), not only in the plan.
- A plan is not a promise. Estimates of time are not required; order and checks are.
