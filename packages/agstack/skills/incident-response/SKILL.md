---
name: incident-response
description: "Triage and resolve a production or user-facing failure: stabilise first, find the cause with evidence, fix or roll back, then write a blameless review. Use when something is broken for users or for a running system, or when an alert fires."
---

# Incident response

During an incident the order matters: stop the harm, then understand it, then fix it. Agents tend to start with the fix and skip the impact. This skill fixes the order.

## Order

1. **Impact.** What is broken, for whom, since when. Write it in one sentence with the evidence (the error, the count, the time).
2. **Stabilise.** The smallest action that stops the harm: a rollback, a feature flag off, a rate limit, a restart. Prefer the reversible action. Do not change code to stabilise unless no other action exists.
3. **Find the cause.** Read the logs and metrics around the start time. Form a hypothesis and test it with the smallest check (`skills/loop-breaker`).
4. **Fix.** A fix goes through the normal gate: a regression test that fails on the bug, then the fix, then the checks (`skills/verification`).
5. **Verify in the system.** Confirm the impact is gone with the same measurement used in step 1.
6. **Review.** Write the review after the system is stable (below).

## Review

```markdown
# Incident: <title>
- Impact: <who, what, how long>
- Timeline: <time> <event>, with evidence
- Cause: <the root cause, with the evidence that shows it>
- Contributing: <what made it worse or hid it>
- Detection: <how it was found, and how it could be found sooner>
- Actions: <each with an owner and a check>
```

## Rules

- A review is blameless. Name the mechanism, not the person.
- A cause without evidence is a guess. Mark it as a hypothesis and list the check that would confirm it.
- Every action has a check that proves it works. "Add monitoring" is an action only when the monitor's trigger is written.
- Do not run destructive operations on production data to diagnose. Diagnose on a copy or read-only.
- Notify the user at each step where the impact or the plan changes.
