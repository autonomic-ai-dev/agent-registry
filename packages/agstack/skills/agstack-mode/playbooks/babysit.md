# Playbook: Babysit (`babysit`)

> **Trigger & Intent:** Driving an open pull request, stacked branches, or CI build to green merge-readiness: triaging check failures, resolving rebase/merge conflicts, and addressing reviewer comments.
> **Deliverable:** A green, rebased, conflict-free pull request ready for final landing.

---

## 1. Session Anchor & TodoList Contract

Before modifying branches, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/babysit.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Inspect PR state (CI checks, mergeability, bot review comments)
- [ ] Step 2: Reproduce any failing CI check locally using `.verify/run.sh`
- [ ] Step 3: Rebase onto target base branch and resolve conflicts with immutability discipline
- [ ] Step 4: Triage review threads (address substantive defects, dismiss noise with citations)
- [ ] Step 5: Run allowlisted verification suite (`.verify/run.sh`), push, and poll checks to green

---

## 2. Core Invariants

1. **Local Repro First:** Never push trial commits directly to GitHub hoping CI turns green. Reproduce the failing CI job locally and verify with `.verify/run.sh`.
2. **Skeptical Posture on Bot Comments:** Review automated linter or security comments on technical merits. Dismiss false positives with concise citations rather than churning code unnecessarily.
3. **Rebase, Never Merge-Bubble:** Keep git history linear. Rebase feature branch onto `upstream/master` without messy merge-commit bubbles.
4. **Zero Test Weakening:** Never bypass failing tests by adding `#[ignore]` or skipping assertions to force green status.

---

## 3. Checklist Steps

1. **State Audit:** Query PR status using `gh pr view <number>` or `gh pr checks <number>`. Download logs of failed checks to `.verify/artifacts/ci-failure.log`.
2. **Local Reproduction:** Execute the matching verification command locally. Confirm reproducing failure.
3. **Fix & Rebase:**
   - Apply minimal root-cause fix.
   - Rebase onto `origin/master`: `git rebase origin/master`.
   - Resolve conflicts preserving intended logic.
4. **Local Verification:** Run allowlisted `.verify/run.sh`. Ensure all gates pass locally.
5. **Push & Monitor:** Push rebased commits (`git push --force-with-lease`), monitor CI checks until green.

---

## 4. Evidence Record & Reply Standard

```markdown
### Babysit PR Evidence Record
- PR Target: [#128: https://github.com/org/repo/pull/128]
- Check Status: [All CI jobs passing / Green]
- Conflict Resolution: [Rebased cleanly onto latest master]
- Triage Summary: [Addressed 2 substantive comments, dismissed 1 false-positive lint warning]
- Local Verification: `.verify/run.sh` (Exit Code 0)
```
