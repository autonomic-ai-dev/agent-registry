# Playbook: Pause Safely (`pause-safely`)

> **Trigger & Intent:** Cleanly suspending, checkpointing, or stashing in-flight engineering work prior to context window compaction, session termination, offline handoff, or a host restart.
> **Deliverable:** An unambiguous checkpoint record, cleanly stashed or committed wip-state, and zero lost progress.

---

## 1. Session Anchor & TodoList Contract

Before suspending work, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/pause-safely.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Capture current execution state (completed steps, active blocker, next immediate action)
- [ ] Step 2: Clean up ephemeral test processes, background sockets, and temporary mock servers
- [ ] Step 3: Run allowlisted verification to record passing/failing status in checkpoint
- [ ] Step 4: Stash or commit WIP progress (`git stash` or `wip:` commit on feature branch)
- [ ] Step 5: Output handoff note for immediate resumption via `session-pickup`

---

## 2. Core Invariants

1. **Zero Orphaned Processes:** Terminate any running test daemons, mock servers, or debug listeners before pausing.
2. **Deterministic Checkpoint File:** Write current status, open questions, and next command to `.verify/artifacts/checkpoint.md`.
3. **No Unsaved Workspace State:** Working directory must be cleanly committed to a feature branch or saved in git stash.

---

## 3. Checklist Steps

1. **State Snapshot:** Summarize what was completed, which files are dirty, and the exact next step.
2. **Process Cleanup:** Stop background processes by their recorded PIDs.
3. **Verification Stamp:** Run `.verify/run.sh` to record the exact passing/failing test state.
4. **Git Checkpoint:** Run `git add -A && git commit -m "wip: checkpoint before session pause"` or `git stash push -m "wip-pause"`.
5. **Emit Handoff:** Output the clear resumption note.

---

## 4. Evidence Record & Reply Standard

```markdown
### Safe Pause Checkpoint
- Checkpoint Artifact: `.verify/artifacts/checkpoint.md`
- Git State: [Committed WIP on branch `feat/background-workers` (commit: e4f5a6b)]
- Verification Status at Pause: [3/4 suites passing, unit tests green, functional tests pending DB migration]
- Background Daemons: [All test processes stopped cleanly]
- Resumption Command: `agent-brain route_task "resume feat/background-workers"`
```
