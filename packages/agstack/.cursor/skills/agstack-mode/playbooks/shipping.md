# Playbook: Shipping (`shipping`)

> **Trigger & Intent:** Landing, squashing, or fast-forward merging a verified, green pull request or stacked PR chain into the production/master branch and cleaning up branch state.
> **Deliverable:** Safely merged code on the trunk branch with clean branch disposal and post-merge verification.

---

## 1. Session Anchor & TodoList Contract

Before landing commits, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/shipping.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Verify all required CI checks, approval gates, and signed commits
- [ ] Step 2: Ensure branch is fully rebased with zero drift against base branch
- [ ] Step 3: Run final allowlisted verification suite (`.verify/run.sh`)
- [ ] Step 4: Execute merge (squash-and-merge or linear rebase) and delete remote branch
- [ ] Step 5: Fast-forward local master, prune tracking branches, and verify trunk health

---

## 2. Core Invariants

1. **Green Is Not Automatically Safe:** Even with green CI, verify that the PR has not drifted behind the base branch. If base has advanced, rebase and re-verify before landing.
2. **Bottom-Up Stack Landing:** In stacked PRs (PR A $\rightarrow$ PR B $\rightarrow$ PR C), always land bottom-up from the root. Never merge a child before its parent is merged.
3. **Delete Merged Branches:** Never leave merged feature branches cluttering remote or local git trees. Delete immediately upon merge.
4. **Trunk Verification:** Pull updated `master` locally and run verification to confirm trunk health.

---

## 3. Checklist Steps

1. **Gate Audit:** Assert all CI checks are green (`gh pr checks <number>`). Confirm required reviews and approvals are satisfied.
2. **Rebase Check:** Check if `master` has new commits. If yes, rebase and force-push.
3. **Execution of Merge:** Land the PR via `gh pr merge <number> --squash --delete-branch` (or `--rebase`).
4. **Local Sync:** Switch to `master`, run `git pull --ff-only`, and prune local branch (`git branch -d <branch>`).
5. **Post-Merge Verification:** Run allowlisted `.verify/run.sh` on `master` to confirm clean integration.

---

## 4. Evidence Record & Reply Standard

```markdown
### Shipping Evidence Record
- Merged PR: [#128: https://github.com/org/repo/pull/128]
- Merge Strategy: [Squash & Merge (Commit: a1b2c3d)]
- Remote Branch Deleted: [origin/feat/feature-x deleted]
- Local Trunk Status: [master up to date at a1b2c3d]
- Trunk Verification: `.verify/run.sh` on master (Exit Code 0)
```
