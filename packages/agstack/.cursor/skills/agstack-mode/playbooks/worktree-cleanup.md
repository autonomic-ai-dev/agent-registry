# Playbook: Worktree & Environment Cleanup (`worktree-cleanup`)

> **Trigger & Intent:** Safely reclaiming local disk space, pruning merged or abandoned git worktrees, stopping orphaned test containers/daemons, and removing stale IPC sockets.
> **Deliverable:** Clean local workspace and restored disk space without deleting in-progress work.

---

## 1. Session Anchor & TodoList Contract

Before pruning, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/worktree-cleanup.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Audit git worktrees, background processes, and dead socket files
- [ ] Step 2: Identify safe-to-prune worktrees (merged into upstream master)
- [ ] Step 3: Stop orphaned containers and background daemons
- [ ] Step 4: Prune dead sockets and clean ephemeral caches in `.verify/artifacts/`
- [ ] Step 5: Deliver cleanup report with reclaimed space and active worktree list

---

## 2. Core Invariants

1. **Never Delete Dirty Worktrees:** Never force-delete a worktree with uncommitted changes (`git status --porcelain`).
2. **Never Delete Unmerged Worktrees:** Check `git branch --merged master` before pruning.
3. **Keep Proof Artifacts:** Do not wipe `.verify/artifacts/` needed for active audit records.

---

## 3. Checklist Steps

1. **Audit:** Run `git worktree list`. List running test containers via `docker ps` and check sockets in `/tmp/`.
2. **Safety Classification:** Separate active branches from merged branches.
3. **Prune Worktrees:** Execute `git worktree remove <path>` and `git worktree prune`.
4. **Daemon & Socket Cleanup:** Remove stale socket files whose PIDs are dead.
5. **Report:** Output reclaimed disk space summary.

---

## 4. Evidence Record & Reply Standard

```markdown
### Worktree Cleanup Report
- Worktrees Pruned: [list of removed paths]
- Active Worktrees Preserved: [main worktree + active feature branches]
- Orphaned Daemons Stopped: 0
- Stale Sockets Removed: [e.g. /tmp/test-daemon.sock]
- Disk Space Reclaimed: [e.g. 2.4 GB]
```
