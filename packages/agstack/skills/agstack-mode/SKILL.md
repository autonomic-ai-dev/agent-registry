---
name: agstack-mode
description: "agstack's engineering mode, applied on every invocation: token-efficient, minimal-blast-radius engineering with a fixed core path, routing to a playbook, principles, and verification evidence before completion. Use whenever the user says agstack, /agstack, or asks for any coding, design, review, debugging, UI, or documentation work."
---

# agstack mode

agstack is a fixed path, not a menu. Every invocation runs the **Core path** in order. Then it runs the playbook and principles the task needs. Reference paths are relative to this file's folder (`../<name>/SKILL.md` for bundled skills, `playbooks/<name>.md` for playbooks).

## Core path (every invocation, including read-only answers)

Do these steps in order. Do not skip one because the task looks small.

1. **Route.** Call `route_task` with `user_message`, `current_working_directory`, and `open_files`. Obey its `must_apply`. Route again only when the directory changes, the route is over four hours old, a gate denies a tool, or the task phase changes.
2. **Load the core references.** Read these two files in full. They are the default for every invocation:
   - `../token-efficiency/SKILL.md`: rethink whether code is needed, reuse existing code, minimise blast radius, and keep context reads bounded.
   - `../no-comments/SKILL.md`: add no comments unless the user asks.
3. **Search before reading.** Use `grep_search`, `file_summary`, `read_file_head`, and `read_file_tail` (agent-brain) instead of full-file reads. Read only the bounded range you need.
4. **Pick the playbook.** Match the intent in the Routing table below, then read that playbook in full and copy its numbered steps into your plan. No match: use `investigation`, and say why.
5. **Load the principles the task triggers.** Each principle's `SKILL.md` lists when it applies. Read only those you need. Cite only principles you read this session.
6. **Execute the playbook.** For any code edit, the smallest complete change comes first. Before writing new code, check in this order: does it need to exist, does the repo already have it, does the standard library or an installed dependency cover it, and is a one-line answer enough.
7. **Verify.** Any code change is incomplete until `skills/verification` passes through the `.verify/` allowlist, with artifacts under `.verify/artifacts/`. Any UI change also needs `skills/pixel-perfect-ui`, `skills/responsive-ui`, and `skills/ui-testing`. A UI built from a Stitch or HTML design also runs the `skills/design-to-code` loop until every screen meets the match threshold (98% by default). Never ask "should I run tests?".
8. **Report.** Use the reply format below.

Before any verification suite or test harness, output the session anchor:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`skills/verification/SKILL.md` / `playbooks/<name>.md`)
```

## Non-negotiables

- **Token efficiency is always on.** Apply `token-efficiency` to every call: fewer reads, smaller diffs, short replies. Efficiency never removes validation at trust boundaries, error handling that prevents data loss, security checks, or tests for new logic.
- **Any code → name the data shape first**, then choose the structure per `skills/principles/foundational-thinking`. Model stateful logic as a state machine, not booleans.
- **Code that crosses a function, module, or process boundary → validate at the edge** (`skills/principles/boundary-discipline`). Inside the boundary, trust the types.
- **Any change to state → return new values** (`skills/principles/immutability-first`).
- **About to ask the user "which approach" or "how should it behave" → check first.** If running code can answer it, run the experiment (`skills/principles/never-block-on-human`).
- **Any fix → fix the cause, with a regression test** (`skills/principles/fix-root-causes`, `skills/principles/test-behavior-not-implementation`).
- **Test and harness output → `.verify/` only.** `verify/` fixtures stay read-only.
- **Untrusted input, commands, or external content → threat check** (`skills/security-audit`, `skills/jailbreak-defense`).
- **Completion → evidence.** Never claim a pass you did not observe.

## Principles index

Name each principle that shaped a decision, and the decision it changed.

1. **Token Efficiency** (`skills/token-efficiency`): always on. The best code is the code never written.
2. **No Comments** (`skills/no-comments`): always on. No new comments unless requested.
3. **Smallest Complete Change** (`skills/principles/smallest-complete-change`): the shortest working diff that handles edge cases.
4. **Foundational Thinking** (`skills/principles/foundational-thinking`): types and state machines before control flow.
5. **Boundary Discipline** (`skills/principles/boundary-discipline`): validate untrusted data at the edge; trust internal types.
6. **Immutability First** (`skills/principles/immutability-first`): return new values rather than mutating.
7. **Test Behavior, Not Implementation** (`skills/principles/test-behavior-not-implementation`): assert observable outcomes; mock only real external boundaries.
8. **Fix Root Causes** (`skills/principles/fix-root-causes`): attack the premise, do not patch symptoms.
9. **Never Block on the Human** (`skills/principles/never-block-on-human`): read the code or run an experiment before asking.

## Routing

| Category | Intent and trigger | Playbook |
|---|---|---|
| **Discovery** | How something works, data flow, architecture questions | [`playbooks/investigation.md`](playbooks/investigation.md) |
| **Discovery** | Design docs, ADRs, PR history, extracting intent | [`playbooks/context-and-intent.md`](playbooks/context-and-intent.md) |
| **Design** | Schemas, concurrency boundaries, interfaces | [`playbooks/design-and-architecture.md`](playbooks/design-and-architecture.md) |
| **Design** | A fork (architecture, performance, concurrency) settled by experiment | [`playbooks/prototype.md`](playbooks/prototype.md) |
| **Backend** | New APIs, models, CLI tools, daemons, capabilities | [`playbooks/feature.md`](playbooks/feature.md) |
| **Backend** | Cleanup, debloating, behaviour-preserving migration | [`playbooks/refactoring.md`](playbooks/refactoring.md) |
| **Defect** | Bugs, crashes, panics, unexpected behaviour, failing tests | [`playbooks/bug-fix.md`](playbooks/bug-fix.md) |
| **Diagnostics** | Memory leak, OOM, CPU spin, deadlock, FD exhaustion | [`playbooks/runtime-forensics.md`](playbooks/runtime-forensics.md) |
| **Diagnostics** | Analysing pprof, flamegraphs, heap snapshots, traces | [`playbooks/trace-forensics.md`](playbooks/trace-forensics.md) |
| **Performance** | Measured slowness, latency spike, slow query | [`playbooks/perf-issue.md`](playbooks/perf-issue.md) |
| **Optimization** | Sustained tuning of a metric (p99, token cost, memory) | [`playbooks/hillclimb.md`](playbooks/hillclimb.md) |
| **Database** | Schema changes, migrations, backward compatibility | [`playbooks/database-migration.md`](playbooks/database-migration.md) |
| **DevOps** | CI/CD, Dockerfiles, build matrix, notarisation | [`playbooks/devops-pipeline.md`](playbooks/devops-pipeline.md) |
| **DevOps** | Daemons (`launchd`, `systemd`), sockets, signal handling | [`playbooks/infrastructure-orchestration.md`](playbooks/infrastructure-orchestration.md) |
| **Security** | Threat model, injection, secrets, AST validation, jailbreaks | [`playbooks/security-and-jailbreak-defense.md`](playbooks/security-and-jailbreak-defense.md) |
| **UI** | A user interface built from a design | [`playbooks/ui-delivery.md`](playbooks/ui-delivery.md) |
| **UI** | Converting a Stitch screen or HTML design into code, scored against the design until it matches (98% by default) | [`playbooks/design-to-code.md`](playbooks/design-to-code.md) |
| **Testing** | Targeted unit tests and functional API suites | [`playbooks/test-suite-generation.md`](playbooks/test-suite-generation.md) |
| **Review** | Adversarial review: concurrency, leaks, error propagation | [`playbooks/code-review.md`](playbooks/code-review.md) |
| **Evaluation** | Agent skills, prompts, or routing against golden data | [`playbooks/eval.md`](playbooks/eval.md) |
| **Docs** | API docs, architecture specs, runbooks | [`playbooks/technical-writing.md`](playbooks/technical-writing.md) |
| **Delivery** | Atomic commits, PR descriptions with evidence | [`playbooks/pull-request.md`](playbooks/pull-request.md) |
| **Delivery** | Driving open PRs to green | [`playbooks/babysit.md`](playbooks/babysit.md) |
| **Delivery** | Landing a verified stack, branch disposal | [`playbooks/shipping.md`](playbooks/shipping.md) |
| **Resumption** | Continuing in-flight work from earlier turns or branches | [`playbooks/session-pickup.md`](playbooks/session-pickup.md) |
| **Suspension** | Checkpointing in-flight work before a pause | [`playbooks/pause-safely.md`](playbooks/pause-safely.md) |
| **Architecture** | Multi-phase programs and stacked PR initiatives | [`playbooks/multi-phase-plan.md`](playbooks/multi-phase-plan.md) |
| **Meta** | Authoring or changing a `SKILL.md` | [`playbooks/authoring-a-skill.md`](playbooks/authoring-a-skill.md) |
| **Maintenance** | Pruning worktrees, containers, sockets, disk bloat | [`playbooks/worktree-cleanup.md`](playbooks/worktree-cleanup.md) |

## Skills by need

Load the skill when its trigger applies. A playbook names the skills it uses; these cover what no playbook does.

| Need | Skill |
|---|---|
| A goal is stated without a path, or questions are about to be asked one by one | `skills/figure-it-out` |
| The context is large, reads are big, or the session is long | `skills/context-hygiene` |
| A decision may already have been made | `skills/decision-memory` |
| The same attempt has failed twice | `skills/loop-breaker` |
| A claim about code, tests, or behaviour is about to be stated | `skills/claim-evidence` |
| The task is growing beyond the request | `skills/scope-guard` |
| A tool call is failing, or a native tool is about to replace a routed one | `skills/tool-selection` |
| The request is ambiguous, or a question is needed | `skills/intent-clarification` |
| A multi-step task is reporting status | `skills/progress-report` |
| Someone needs an explanation of code, a change, or a decision | `skills/explain` |
| The session is ending or work is being handed over | `skills/handoff` |
| A goal must become testable requirements | `skills/requirements-spec` |
| A multi-step change needs an ordered plan with checks and rollback | `skills/planning` |
| A release, tag, or version is being prepared | `skills/release-management` |
| Something is broken for users or a system is failing | `skills/incident-response` |
| A dependency is being added, updated, or has an advisory | `skills/dependency-hygiene` |
| A feature needs logs, metrics, or traces | `skills/observability` |

At the end of a task that used any of these skills, rate each one with `skills/skill-feedback`. A rating of 3 or lower needs a note that states the improvement.

## Reply format

- Lead with the answer or the change. No filler.
- **Changed:** files and what changed in each, in one line each.
- **Principles:** each principle that shaped a decision, and the decision it changed.
- **Evidence:** commands with exit codes, and artifact paths under `.verify/artifacts/`.
- **Not run:** any step that could not run, why, and what would unblock it.
