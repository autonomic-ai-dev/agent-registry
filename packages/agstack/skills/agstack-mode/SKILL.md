---
name: agstack-mode
description: "Universal engineering mode for the entire Software Development Lifecycle (SDLC). Matches tasks to structured playbooks across context & intent, design & architecture, undebloated coding, forensics & bug reproduction, test generation, verification (.verify/), code review, and technical writing."
---

# agstack mode: Full-SDLC Engineering Operating System

`agstack` (Abhiuday Gupta Stack) transforms agent execution into an unbreakable, end-to-end Software Development Lifecycle (SDLC) process specifically engineered for **Backend Engineering** (APIs, databases, concurrency, microservices) and **DevOps Operations** (CI/CD, containerization, daemons, IPC sockets).

---

## The Non-Negotiables

1. **The TodoList Contract:** When `route_task` returns `matched_skills` or recommends a playbook, you MUST call `read_file` on the matched playbook file and copy its numbered checklist steps verbatim into your active task plan before calling code-editing tools.
2. **Strict Verification Root Separation:** All project-generated test harnesses, run logs, coverage reports, and test snapshots MUST output strictly under `.verify/` (e.g. `.verify/artifacts/`, `.verify/output/`). Static input reference fixtures under `verify/` are strictly read-only.
3. **Default Post-Dev Verification via agstack:** Verification is the mandatory default completion condition. Any code modification is strictly INCOMPLETE until verified through the `agstack` `verification` skill (`.verify/run.sh` / allowlist). Never ask the user *"Should I run tests?"* or end a turn without verification evidence.
4. **Session Anchoring:** Before running verification suites or authoring test harnesses, output the Session Anchor:
   ```markdown
   > **Session Anchor:**
   > - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
   > - **SDLC Orchestrator**: `agstack` (`skills/verification/SKILL.md` / `playbooks/<name>.md`)
   ```
5. **Zero AI Comment Slop:** Write self-documenting code with clear names and explicit types. Pre-commit hooks reject newly added comments.

---

## Decision Tree Routing Matrix

Match user prompt intent to its dedicated playbook:

| Category | User Intent & Keyword Triggers | Playbook File |
|---|---|---|
| **Discovery** | Interrogating repo patterns, data flow, architecture inquiry, "how does X work" | [`playbooks/investigation.md`](playbooks/investigation.md) |
| **Discovery** | Reading design docs, ADRs, PR history, extracting problem intent | [`playbooks/context-and-intent.md`](playbooks/context-and-intent.md) |
| **Design** | System modeling, schema planning, concurrency boundaries, deep interfaces | [`playbooks/design-and-architecture.md`](playbooks/design-and-architecture.md) |
| **Design** | Settle architectural, performance, or concurrency forks empirically with spikes | [`playbooks/prototype.md`](playbooks/prototype.md) |
| **Backend** | New gRPC/REST APIs, models, CLI tools, daemons, new capabilities | [`playbooks/feature.md`](playbooks/feature.md) |
| **Backend** | Code cleanup, debloating, immutability, behavior invariance, API migration | [`playbooks/refactoring.md`](playbooks/refactoring.md) |
| **Defect** | Bugs, crashes, panics, errors, unexpected behavior, failing tests | [`playbooks/bug-fix.md`](playbooks/bug-fix.md) |
| **Diagnostics** | Live memory leak, OOM, CPU spin, deadlocks, socket/FD exhaustion | [`playbooks/runtime-forensics.md`](playbooks/runtime-forensics.md) |
| **Diagnostics** | Analyzing captured `pprof`, `cpuprofile`, flamegraph, heap snapshots, OpenTelemetry traces | [`playbooks/trace-forensics.md`](playbooks/trace-forensics.md) |
| **Performance** | Measured slowness, latency spike, throughput bottleneck, slow DB query | [`playbooks/perf-issue.md`](playbooks/perf-issue.md) |
| **Optimization** | Sustained iterative tuning of metrics (p99 latency, token efficiency, memory) | [`playbooks/hillclimb.md`](playbooks/hillclimb.md) |
| **Database** | SQL tables, column alterations, schema migrations, backward compatibility | [`playbooks/database-migration.md`](playbooks/database-migration.md) |
| **DevOps** | CI/CD GitHub Actions, Dockerfiles, build matrix, release notarization | [`playbooks/devops-pipeline.md`](playbooks/devops-pipeline.md) |
| **DevOps** | Background daemons (`launchd`, `systemd`), Unix domain socket IPC, signal traps | [`playbooks/infrastructure-orchestration.md`](playbooks/infrastructure-orchestration.md) |
| **Security** | Threat modeling, delimiter isolation, SQL/AST injection defense, secrets audits | [`playbooks/security-and-jailbreak-defense.md`](playbooks/security-and-jailbreak-defense.md) |
| **Testing** | Authoring targeted unit tests + functional Hurl API suites (1:1 step coverage) | [`playbooks/test-suite-generation.md`](playbooks/test-suite-generation.md) |
| **UI** | Stitch design to pixel-perfect, responsive, tested UI | [`playbooks/ui-delivery.md`](playbooks/ui-delivery.md) |
| **Review** | Adversarial review (concurrency, memory leaks, error propagation, blast radius) | [`playbooks/code-review.md`](playbooks/code-review.md) |
| **Evaluation** | Evaluating agent skills, prompts, or routing heuristics against golden datasets | [`playbooks/eval.md`](playbooks/eval.md) |
| **Docs** | Diátaxis API documentation, architecture specs, operational runbooks | [`playbooks/technical-writing.md`](playbooks/technical-writing.md) |
| **Delivery** | Atomic chunked commits, PR descriptions with Mermaid diagrams & evidence records | [`playbooks/pull-request.md`](playbooks/pull-request.md) |
| **Delivery** | Driving open PRs to green: CI triage, merge conflicts, bot review resolution | [`playbooks/babysit.md`](playbooks/babysit.md) |
| **Delivery** | Landing verified PR stacks, bottom-up merge verification, branch disposal | [`playbooks/shipping.md`](playbooks/shipping.md) |
| **Resumption** | Resuming in-flight work from prior turns, transcripts, or unmerged branches | [`playbooks/session-pickup.md`](playbooks/session-pickup.md) |
| **Suspension** | Clean checkpointing of in-flight work (git stash, evidence notes) before pause | [`playbooks/pause-safely.md`](playbooks/pause-safely.md) |
| **Architecture** | Large-scale multi-phase programs and stacked PR initiatives | [`playbooks/multi-phase-plan.md`](playbooks/multi-phase-plan.md) |
| **Meta** | Authoring or modifying Open Agent Skills Standard (`SKILL.md`) specs | [`playbooks/authoring-a-skill.md`](playbooks/authoring-a-skill.md) |
| **Maintenance** | Pruning merged worktrees, dead containers, stale sockets, and disk bloat | [`playbooks/worktree-cleanup.md`](playbooks/worktree-cleanup.md) |

---

## Core Principles Grounding Every Playbook

Every step in every playbook is strictly governed by the core principles:
1. **Foundational Thinking (`skills/principles/foundational-thinking/`):** Types, entities, and state machines come first. Make illegal states unrepresentable.
2. **Boundary Discipline (`skills/principles/boundary-discipline/`):** Validate at system edges (Zod/serde); trust internal typed models.
3. **Immutability First (`skills/principles/immutability-first/`):** Never mutate in place; always return updated copies.
4. **Smallest Complete Change & Token Efficiency (`skills/principles/smallest-complete-change/`):** Inspired by ponytail — rethink if code is needed; reuse existing repo code, standard library, or installed dependencies; small blast radius.
5. **Test Behavior Not Implementation (`skills/principles/test-behavior-not-implementation/`):** Verify observable outcomes; mock only true external boundaries.
6. **Fix Root Causes (`skills/principles/fix-root-causes/`):** Attack the premise; never patch around symptoms or write workaround sermons.
7. **Never Block on the Human (`skills/principles/never-block-on-human/`):** Interrogate the codebase and run empirical experiments. Never ask what the code or tests can answer.
