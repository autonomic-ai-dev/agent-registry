# Playbook: Session Pickup (`session-pickup`)

> **Trigger & Intent:** Resuming, taking over, or recovering in-flight backend engineering work from a prior turn, an earlier session transcript, a cloud agent handoff, or a dirty branch.
> **Deliverable:** Seamless context restoration, validation of baseline working state, and continuation without duplicate work.

---

## 1. Session Anchor & TodoList Contract

Before modifying code, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/session-pickup.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Ingest prior transcript or handoff notes; extract completed work vs pending intent
- [ ] Step 2: Audit git status and branch state (staged diffs, untracked files, unpushed commits)
- [ ] Step 3: Run allowlisted verification suite (`.verify/run.sh`) to establish current health
- [ ] Step 4: Re-anchor task checklist with remaining deliverables
- [ ] Step 5: Transition directly into the matched active playbook (`feature`, `bug-fix`, etc.)

---

## 2. Core Invariants

1. **Verify Before Continuing:** Never assume in-flight code left by a prior agent compiles or passes tests. Always run `.verify/run.sh` to determine actual starting state.
2. **Preserve Valid Progress:** Do not wipe or rewrite valid changes already verified by the prior session. Keep good commits; discard only broken scratch state.
3. **No Duplicate Steps:** Reconstruct the checklist to start from the first incomplete step.

---

## 3. Checklist Steps

1. **Context Extraction:** Review last route digest (`~/.agent_brain/logs/last-route.md` or session summary). Note the primary goal and unresolved blockers.
2. **Git State Audit:** Run `git status` and `git diff --stat`. Verify if prior changes were staged, unstaged, or committed.
3. **Health Check:** Run `.verify/doctor.sh` and allowlisted `.verify/run.sh`. Record baseline status to `.verify/artifacts/pickup-health.log`.
4. **Synthesize Active TodoList:** Write out the remaining steps for the active objective.
5. **Resume Work:** Transition into the appropriate specific playbook.

---

## 4. Evidence Record & Reply Standard

```markdown
### Session Pickup Status
- Prior Objective: [Implement order idempotency token check]
- Discovered State: [Branch `feat/idempotency`, 2 commits ahead of master, 1 dirty file]
- Baseline Health: `.verify/run.sh` (Exit Code 0, `.verify/artifacts/pickup-health.log`)
- Pending Deliverables: [Step 4: Integration Hurl test, Step 5: PR documentation]
- Resuming Playbook: `feature`
```
