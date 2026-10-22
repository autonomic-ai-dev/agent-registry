---
name: feature-map
description: "Discover, generate, and maintain an agent-agnostic backend and DevOps feature map in .verify/. Maps CLI, daemon, API, and infra behaviors into structured contracts linked directly to verification test suites."
disable-model-invocation: true
---

# Agent-Agnostic Backend & DevOps Feature Map

A feature map is a repository's canonical, maintained behavior inventory. It bridges **user-facing intent** with **executable verification**. You write the feature map for the next autonomous agent, not for a human: it will be read cold, mid-task, by an agent that has never seen the codebase.

The map guarantees that any coding agent (Claude Code, Cursor, Antigravity CLI, OpenCode, Augment, Aider):
1. Knows **what behaviors exist** and **how to reach them** (CLI, REST/gRPC API, daemon, message bus).
2. Knows **what exact test suites to execute** when changes are made.
3. Understands **traps, race conditions, and gotchas** before modifying code.

This skill works hand-in-hand with `@verification`:
- **`@feature-map`** specifies the contract, entry points, gotchas, and links to test suites in `.verify/features/*.md`.
- **`@verification`** implements the test runner, allowlist (`.verify/verify.toml`), and declarative Hurl API tests (`.verify/functional/*.hurl`).

---

## 1. Interrogate the Codebase, Never the User (MANDATORY)

**Autonomous Discovery Invariant:** You MUST discover all surfaces, startup commands, ports, routes, and gotchas by navigating the codebase. **Do NOT ask the user** how the application works, how to start it, what flags exist, or what endpoints do.

Navigate the repository code directly to answer every question:
1. **How the app builds & starts:**
   - Inspect package scripts (`package.json`), `Makefile`, `Cargo.toml`, `pyproject.toml`, `docker-compose.yml`, or container manifests.
   - Trace startup entry points (`main.go`, `src/main.rs`, `app.py`, `server.ts`) to locate port bindings, environment variable defaults, and readiness signals (`/healthz`, `/readyz`, `Listening on...`).
2. **What surfaces exist:**
   - Trace routing tables (`express`, `axum`, `gin`, `fastapi`, `actix-web`, `spring`).
   - Trace CLI argument parsers (`clap`, `cobra`, `argparse`, `commander`).
   - Trace gRPC `.proto` service definitions and message queue subscribers (Kafka/NATS topics).
3. **What tests already exist:**
   - Grep for existing test files (`tests/`, `*_test.go`, `test_*.py`, `*.spec.ts`).
   - Inspect existing test commands and harness scripts to link them directly into the feature contract.
4. **What database & seed data is needed:**
   - Inspect database migrations (`migrations/`, `prisma/`, `schema.sql`) and seed/fixture generators to determine baseline preconditions.

*The only acceptable reason to prompt the user is for a secret or credential strictly external to the codebase that cannot be mocked or generated locally.*

---

## 2. Directory Structure (`.verify/`)

All verification assets and feature specifications live strictly under `.verify/` in the repository root:

```text
.verify/
├── verify.toml           # Allowlisted test commands and [verify.default] runner
├── run.sh                # Executable composite test runner (unit + functional)
├── doctor.sh             # Read-only health check (port, socket, DB, PID)
├── functional/           # Declarative Hurl (.hurl) API test suites
│   ├── health.hurl       # Liveness and readiness assertions
│   └── <feature>.hurl    # Scenario-based HTTP/API test contracts
├── features/             # Human/Agent behavior contracts
│   ├── README.md         # Baseline preconditions, driving conventions, feature index
│   └── <feature>.md      # 4-section feature contracts linked to test suites
└── artifacts/            # Output directory for proof logs, exit codes, responses
```

---

## 3. Strict Feature Entry Contract

Every feature file in `.verify/features/<feature-name>.md` MUST follow this structure with zero exceptions:
1. **Title:** An `H1` naming the user-facing feature.
2. **Summary:** Exactly one paragraph describing the external behavior from the consumer or operator perspective.
3. **Four Required Sections:** Must contain **EXACTLY** four `H2` sections in this precise order:

### H2 1: `## Sub-features`
Bulleted list of atomic kebab-case identifiers pairing each sub-feature with a one-sentence behavior definition.
```markdown
## Sub-features

- `jobs-submit`: Validates and enqueues job payloads via HTTP POST or CLI.
- `jobs-dispatch`: Dispatches queued jobs to available workers by priority.
- `jobs-retry`: Retries failed jobs up to max_attempts with exponential backoff.
- `jobs-dead-letter`: Moves persistently failing jobs to the dead-letter queue.
```

### H2 2: `## How to get to it (user POV)`
Concrete entry points available to a user, operator, or external client:
```markdown
## How to get to it (user POV)

- CLI: `myctl jobs push --name <name> --priority <high|low>`
- HTTP: `POST /api/v1/jobs` with JSON payload `{"name": "...", "priority": "..."}`
- NATS: Subject `jobs.inbound` with protobuf payload
```

### H2 3: `## Verification Suites (Targeted Test Commands)`
**STRICT REQUIREMENT:** Every feature MUST be explicitly linked to its corresponding unit test and Hurl functional test commands discovered from codebase navigation:
```markdown
## Verification Suites (Targeted Test Commands)

- **Unit Tests:** Command covering this feature's business logic:
  ```bash
  cargo test --package jobs-worker --lib
  # or: pytest tests/unit/test_jobs.py
  ```
- **Functional API Tests (Hurl):** The exact Hurl scenario validating this feature:
  ```bash
  hurl --test --variable host=127.0.0.1 --variable port=8080 .verify/functional/jobs.hurl
  ```
- **Allowlisted Verification:** Command executed via agent-brain:
  ```bash
  agent-brain verify -- hurl --test .verify/functional/jobs.hurl
  ```
- **Driving Steps & Proof:**
  - Preconditions: Daemon running with `JOB_WORKERS=2` and tenant `test-org` seeded.
  - Step: Execute `POST /api/v1/jobs`. Verify HTTP 201 and extract `job_id`.
  - Step: Query `GET /api/v1/jobs/{{job_id}}`. Assert status is `queued`.
  - Proof: Output saved to `.verify/artifacts/jobs/response.json`.
```

### H2 4: `## Gotchas`
List of edge cases, race conditions, timing requirements, and operational traps:
```markdown
## Gotchas

- Worker pull debounce: allow up to 150ms before asserting state transitions from `queued` to `running`.
- Database transaction isolation: DB commit must occur before notifying worker threads via event bus.
- Leftover dead-letter jobs from previous failed runs invalidate queue count assertions; clean scratch data between runs.
```

---

## 4. Mandatory Authoring Rules (Strict Agent Invariants)

Autonomous agents authoring or modifying feature maps MUST enforce these rules:

1. **Interrogate Code, Not User:** Build the entire map by tracing source code, route tables, and test files. Never ask the user for inputs observable in the repository.
2. **NO Placeholders:** Never use `<your-token>`, `<id>`, `TODO`, or pseudo-code. Commands and parameters must be literal or standard variables (`$PORT`, `{{job_id}}`).
3. **NO Internal Implementation Details:** Private helper functions, internal struct fields, and internal code comments do not belong in the feature map. Map ONLY user-observable behavior and external interfaces.
4. **NEVER Weaken Assertions to Pass:** If an existing test or feature contract fails during verification, fix the application code or record the root cause under `## Gotchas`. Never weaken assertions or remove sub-features to manufacture a green test.
5. **Mandatory Index Sync:** Every `.verify/features/<feature>.md` MUST be indexed in `.verify/features/README.md`. No orphan feature files allowed.
6. **Mandatory Test Pair:** If a feature has an HTTP/gRPC API surface, a corresponding `.verify/functional/<feature>.hurl` file MUST exist.

---

## 5. Index Specification: `.verify/features/README.md`

The feature map index MUST contain:
1. **Baseline Preconditions:** Startup environment variables, data directory paths, and doctor checks.
2. **Driving Conventions:** Machine-readable output flags (`--json`, `--silent`), timeouts, and cleanup rules.
3. **Proof Standards:** Where logs, transcripts, and curl outputs must be preserved (`.verify/artifacts/`).
4. **Feature Index:** Table mapping every feature file to its sub-feature count and primary surface.
