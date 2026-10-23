# Playbook: Multi-Phase Plan (`multi-phase-plan`)

> **Trigger & Intent:** Architecting, decomposing, and executing large-scale backend migrations, major refactors, or multi-week programs that span multiple stacked PRs or discrete milestone phases.
> **Deliverable:** A dependency DAG with clear phase boundaries, independent verifiable units, and stacked PR milestones.

---

## 1. Session Anchor & TodoList Contract

Before authoring code, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/multi-phase-plan.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Decompose initiative into sequentially verifiable phases (Phases 1..N)
- [ ] Step 2: Define strict entry and exit criteria with allowlisted verification commands for each phase
- [ ] Step 3: Sequence phases to deliver consumer value and safety early (scaffolding -> migration -> cleanup)
- [ ] Step 4: Map each phase to an atomic stacked PR branch (`feat/phase-1`, `feat/phase-2`)
- [ ] Step 5: Execute active phase through its dedicated playbook (`feature`, `refactoring`, etc.)

---

## 2. Core Invariants

1. **Independent Verifiability:** Every phase must compile, pass tests, and be independently shippable. Never leave trunk in a broken intermediate state.
2. **Phase Boundary Contracts:** Do not leak implementation of Phase 2 into Phase 1's pull request.
3. **Rollback Safety per Phase:** Each phase must be safely revertible without breaking prior phases.

---

## 3. Checklist Steps

1. **Decomposition:** Break the initiative into 3-5 bounded phases.
2. **Contract Definition:** For each phase, write down:
   - Deliverables (files changed/added)
   - Gate command (allowlisted in `.verify/verify.toml`)
   - Dependent downstream phases
3. **Author Roadmap:** Save roadmap document to `.verify/artifacts/phase-roadmap.md`.
4. **Git Branching Strategy:** Scaffold branch stack from `master`.
5. **Execute Active Phase:** Begin Phase 1 using its matched playbook.

---

## 4. Evidence Record & Reply Standard

```markdown
### Multi-Phase Program Roadmap
- Initiative: [e.g. Migration from REST to gRPC for Cluster IPC]
- Roadmap Artifact: `.verify/artifacts/phase-roadmap.md`
- Phase Status:
  - Phase 1: Protobuf schema definition & code-gen harness (Complete - PR #130)
  - Phase 2: Dual-transport server implementation (Active - PR #131)
  - Phase 3: Client caller migration (Queued)
  - Phase 4: Deprecation and deletion of legacy HTTP handlers (Queued)
- Active Execution: Commencing Phase 2 via `feature` playbook.
```
