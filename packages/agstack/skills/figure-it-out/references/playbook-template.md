# Playbook template

Use this format for `.verify/figure-it-out/<slug>/playbook.md`. Every step has an action and a check. A step without a check is not finished.

```markdown
# Playbook: <task>

Goal: <one sentence, the user's outcome>
Desired state: <the measurement and its target, for example "match >= 98 on every screen">
Current state: <the measurement now, with the command and the value>
Maximum iterations: 10

Skills used: <skill names>

1. [ ] Step 1: <action in one sentence>. Check: `<literal command>` exits 0 | <observable result>. Rollback: <how to undo>.
2. [ ] Step 2: ...

Loop: after step <n>, return to step <m> while the desired-state check fails and the iteration count is below the maximum.
Exit: the desired-state check exits 0 on the final state. Record its output in audit.md.
```

Rules for the steps:

- One action per step. A step that says "set up and fix" is two steps.
- The check is literal. "Looks right" and "works" are not checks. Use a command, a count, a measured value, or a named artifact.
- A step that needs a human decision names it: `Needs: <decision>, default <value>`. Record the default in the decision log.
- Keep steps in dependency order. If step 3 needs the output of step 2, say so.
