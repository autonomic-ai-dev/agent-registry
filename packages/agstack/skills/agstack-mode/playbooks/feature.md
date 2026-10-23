# Playbook: Feature (`feature`)

> **Trigger & Intent:** Implementing new backend features, gRPC/REST APIs, database models, CLI tools, daemon behaviors, or changing existing capabilities.
> **Deliverable:** Working implementation adhering to domain models, 4-H2 feature contract, and 1:1 functional test verification in `.verify/artifacts/`.

---

## 1. Session Anchor & TodoList Contract

Before authoring code, emit the Session Anchor and copy these 6 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/feature.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Interrogate intent, repository patterns, and domain boundaries
- [ ] Step 2: Model core types, domain entities, and boundary schemas (immutable, Zod/serde)
- [ ] Step 3: Author 4-H2 feature contract (`.verify/features/<feature>.md`) with 4-part steps
- [ ] Step 4: Implement behavior via TDD (write unit tests first, minimal implementation)
- [ ] Step 5: Pair with functional verification suites (Hurl / API contracts)
- [ ] Step 6: Execute default post-dev verification via `agstack` `verification` skill (`.verify/run.sh`)

---

## 2. Core Invariants

1. **Model Domain First:** Define core types, boundary schemas, and state machines before business logic.
2. **Strict 4-H2 Contract:** Every feature must define its contract in `.verify/features/<feature>.md` with 1:1 step coverage.
3. **Verification Root Separation:** All generated test outputs, reports, and payloads must live under `.verify/`. Input reference fixtures under `verify/` remain strictly read-only.
4. **Default Post-Dev Verification:** Running `.verify/run.sh` is mandatory. Never ask permission to run tests.
5. **Zero AI Comment Slop:** Self-documenting code with clear names and zero AI narration comments.

---

## 3. Process Steps

### Step 1: Interrogate Intent, Constitution & Codebase
- If `CONSTITUTION.md` exists at repository root, read it to ground architecture, technical stack, and negative constraints.
- Navigate source files to find router declarations, controllers, CLI command parsers, and configuration loaders.
- Identify existing models, databases, and dependencies. Never ask the user for facts visible in the repository.

### Step 2: Model the Domain & Data Shape
- Define core types, domain models, and boundary schemas (e.g., Zod, serde, Pydantic) before writing business logic.
- Enforce `principle-boundary-discipline`: validate strictly at system boundaries, trust internal typed models.
- Ensure all models are immutable (frozen dataclasses, readonly properties).

### Step 3: Author or Update Feature Map Contract
- Check or create `.verify/features/<feature>.md`.
- Enforce the strict 4-H2 structure:
  1. `## Sub-features`: Kebab-case IDs with intent, behavior, and outcome.
  2. `## How to get to it (user POV)`: Literal CLI, HTTP, or message entrypoints.
  3. `## Verification Suites (Targeted Test Commands)`: Unit command, functional command, allowlisted command, and numbered four-part steps:
     - `Request:` method, path, payload file.
     - `Why:` the behavior proved.
     - `Expected:` status code and concrete assertions with values.
     - `Impact:` final system state changes.
  4. `## Gotchas`: Known operational traps, concurrency bounds, and unconfirmed expectations.

### Step 4: Implement Behavior (TDD)
- Write unit tests covering pure business logic first.
- Implement the minimal code required to satisfy the contract.
- Adhere to `principle-immutability-first` and KISS/DRY.

### Step 5: Pair with Functional API Tests
- Create or update `.verify/functional/<feature>.hurl` or functional test suite.
- Pair every request entry with exactly one step in the feature contract (`(entries …)`).
- Ensure payloads exist under `.verify/functional/payloads/`.

### Step 6: Phased Verification & Quality Gates
- Execute the phased runner through the allowlist:
  ```bash
  sh .verify/run.sh <feature>
  ```
- Run static checks including `checks/feature_coverage.sh` to ensure 1:1 step coverage.
- If any gate fails, stop and fix the cause. Never weaken tests.

---

## 4. Evidence Record & Reply Standard

```markdown
### Feature Implementation Evidence Record
- Feature Name: [feature-name]
- 4-H2 Contract: `.verify/features/<feature>.md` (1:1 Coverage Verified)
- Verification Suite: `.verify/run.sh` (Exit Code 0)
- Proof Artifacts: `.verify/artifacts/`
- Maintainer Impact: [What was built, domain model changes, operational guarantees]
```

### Step 7: Clean Hygiene & Evidence Record
- Strip narration comments and temporary scaffolding (`no-comments`).
- Ensure proof artifacts survive in `.verify/artifacts/`.
- Present the evidence record: commands run, exit codes, and measured coverage.
