---
name: verification
description: "Set up and run a repository's verification harness in .verify/: an allowlist of trusted commands, a phased runner (doctor, unit, static, and functional when the repository has them), and proof artifacts. Use whenever code changes need evidence that they pass, or when the harness must be created."
---

# Verification

A change is not finished until the repository's own harness shows that it passes. The harness lives under `.verify/`. Only the commands it allowlists count as evidence.

Verification is the **mandatory default post-dev gate**. You must never ask permission (*"Would you like me to run tests?"*) or end a turn without running verification after modifying code.

Pair this skill with the feature-map skill: the feature map says which tests prove each behaviour, and this skill runs them.

## Session Anchoring

Before executing any verification suite or authoring test harnesses, output:
```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`skills/verification/SKILL.md` / `.verify/run.sh`)
```

## Load the reference you need

| Task | Load |
|---|---|
| Set up or change the allowlist, the runner, or the doctor | `references/allowlist-and-runner.md` |
| Add a functional suite for a repository surface (HTTP, CLI, library, UI) | `references/functional-tests.md` |

## Invariants

These rules apply whenever you run or change verification:

1. **Strict Verification Root Separation:** ALL project-generated verification runs, temporary test harnesses, generated suite snapshots, reports, coverage data, and logs MUST output strictly under `.verify/` (e.g. `.verify/artifacts/`, `.verify/output/`, `.verify/results/`). Static input reference fixtures under `verify/` are strictly read-only.
2. **Default Post-Dev Execution:** Verification runs automatically after code edits. Never ask the user whether tests should be run.
3. **Read the repository first.** Find the test commands, service endpoints, and environment settings from the repository's own files. A repository with no HTTP API, CLI, or other externally reachable surface has no functional suite to write. Its functional phase is omitted, and its feature maps say so under Gotchas.
4. **Run through the allowlist.** Run verification through `.verify/run.sh`, or another entry point listed in `.verify/verify.toml`. A command outside the allowlist is not evidence.
5. **Check the environment before testing.** When the repository has a doctor check (`.verify/doctor.sh`) and it fails, stop and fix the environment. Do not run tests against a broken setup.
6. **Stop only what you started.** End background processes by the process IDs the run recorded. Do not kill processes by name or by pattern.
7. **UI changes need UI evidence.** A change that alters a user interface must pass its visual comparison, responsive checks, and layered UI tests before it is complete. See `playbooks/ui-delivery.md`.
8. **Keep the artifacts.** Logs, reports, and responses under `.verify/artifacts/` survive teardown. Cleanup never deletes them.
9. **Fix failures, never weaken them.** Do not comment out a failing test, loosen an assertion, or remove a command from the allowlist to make a run pass. Fix the cause, or record it as a known failure with its evidence.
10. **Report what ran.** State the commands run, their results, and anything that did not run, and why (Evidence Record).
