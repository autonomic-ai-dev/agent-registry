---
name: verification
description: "Bootstrap and manage an agent-agnostic test verification harness in .verify/. Scaffolds verify.toml allowlist, .verify/run.sh, unit test runners, and Hurl API functional tests linked to feature maps."
disable-model-invocation: true
---

# Agent-Agnostic Test Verification Harness (`.verify`)

Code is not finished until an autonomous agent can prove it passes both unit checks and end-to-end functional contracts without human intervention. This skill initializes, maintains, and executes the repository verification harness strictly under `.verify/`.

This skill works hand-in-hand with `@feature-map`:
- **`@feature-map`** specifies the behavior contracts and explicitly links each feature to targeted test commands in `.verify/features/<feature>.md`.
- **`@verification`** implements the executable test runners, allowlists (`.verify/verify.toml`), and declarative Hurl functional suites in `.verify/functional/*.hurl`.

---

## 1. Interrogate the Codebase, Never the User (MANDATORY)

**Autonomous Scaffolding Invariant:** Discover existing test setups, runners, dependencies, and API endpoints directly by inspecting the codebase. **Do NOT ask the user** what test framework the repo uses or what endpoints need testing.

1. **Detect Unit Test Frameworks:**
   - Scan for configuration files: `Cargo.toml` (`cargo test`), `pytest.ini` / `pyproject.toml` (`pytest`), `package.json` (`npm test` / `vitest` / `jest`), `go.mod` (`go test ./...`), `Makefile` (`make test`).
2. **Detect Endpoints for Functional Tests:**
   - Navigate router source files (`routes.rs`, `server.go`, `app.py`, `router.ts`) to discover path patterns, request schemas, status codes, and HTTP verbs.
   - Scaffold `.verify/functional/<feature>.hurl` directly from route declarations and controller definitions.
3. **Detect Environment & Port Settings:**
   - Trace `.env.example`, `config.yaml`, `docker-compose.yml`, or server flags to determine default ports and environment configurations.

---

## 2. Directory Structure (`.verify/`)

All verification scaffolding and suites live under `.verify/`:

```text
.verify/
├── verify.toml           # Strict command allowlist and [verify.default] step
├── run.sh                # Executable composite test runner (unit + functional)
├── doctor.sh             # Read-only health check (port, socket, DB, PID)
├── functional/           # Declarative Hurl (.hurl) API test suites
│   ├── health.hurl       # Liveness and readiness assertions
│   └── <feature>.hurl    # Scenario-based HTTP/API test contracts
├── features/             # (Managed by feature-map) Behavior contracts & gotchas
│   ├── README.md         # Baseline preconditions, conventions, feature index
│   └── <feature>.md      # 4-section contracts with linked verification suites
└── artifacts/            # Output directory for proof logs, exit codes, responses
```

---

## 3. Command Allowlist (`.verify/verify.toml`)

`agent-brain verify -- <cmd>` strictly enforces that only allowlisted commands are recorded as trusted verification outcomes.

The `.verify/verify.toml` file must define:

```toml
[verify]
commands = [
  # Unit & lint runners detected for repo
  "cargo test",
  "cargo clippy",
  "pytest",
  "npm test",
  "go test ./...",
  "make test",

  # Functional API test runners (Hurl)
  "hurl --test .verify/functional/*.hurl",
  "hurl --test --glob '.verify/functional/**/*.hurl'",
  "hurl --test .verify/functional/",

  # Composite suite script
  ".verify/run.sh",
  ".verify/"
]

[verify.default]
command = [".verify/run.sh"]
timeout_secs = 300
hook = true
```

*Rule:* If an agent needs to run a new test command, it MUST add that command to `[verify.commands]` in `.verify/verify.toml`. Unlisted commands earn zero verification credit.

---

## 4. Composite Runner (`.verify/run.sh`)

`.verify/run.sh` must be executable (`chmod +x`). It orchestrates three mandatory phases:

```bash
#!/usr/bin/env bash
set -euo pipefail

FEATURE_FILTER="${1:-}"
RUN_ID="${RUN_ID:-$(date +%s)}"
ARTIFACTS_DIR=".verify/artifacts/${RUN_ID}"
mkdir -p "${ARTIFACTS_DIR}"

echo "==> [Phase 1/3] Environment doctor..."
if [ -f .verify/doctor.sh ]; then
  bash .verify/doctor.sh
fi

echo "==> [Phase 2/3] Unit test suite..."
if [ -f Cargo.toml ]; then
  cargo test 2>&1 | tee "${ARTIFACTS_DIR}/unit-tests.log"
elif [ -f pyproject.toml ] || [ -f requirements.txt ] || [ -f pytest.ini ]; then
  pytest 2>&1 | tee "${ARTIFACTS_DIR}/unit-tests.log"
elif [ -f package.json ]; then
  npm test 2>&1 | tee "${ARTIFACTS_DIR}/unit-tests.log"
elif [ -f go.mod ]; then
  go test ./... 2>&1 | tee "${ARTIFACTS_DIR}/unit-tests.log"
elif [ -f Makefile ]; then
  make test 2>&1 | tee "${ARTIFACTS_DIR}/unit-tests.log"
fi

echo "==> [Phase 3/3] Functional Hurl test suite..."
if ! command -v hurl &> /dev/null; then
  echo "ERROR: 'hurl' CLI not found on PATH. Install via 'brew install hurl' or package manager."
  exit 1
fi

HOST="${SERVICE_HOST:-127.0.0.1}"
PORT="${SERVICE_PORT:-8080}"

if [ -n "${FEATURE_FILTER}" ] && [ -f ".verify/functional/${FEATURE_FILTER}.hurl" ]; then
  echo "Executing targeted functional suite: .verify/functional/${FEATURE_FILTER}.hurl"
  hurl --test \
    --variable host="${HOST}" \
    --variable port="${PORT}" \
    ".verify/functional/${FEATURE_FILTER}.hurl" 2>&1 | tee "${ARTIFACTS_DIR}/functional-${FEATURE_FILTER}.log"
elif compgen -G ".verify/functional/*.hurl" > /dev/null; then
  hurl --test \
    --variable host="${HOST}" \
    --variable port="${PORT}" \
    --report-html "${ARTIFACTS_DIR}/hurl-report" \
    .verify/functional/*.hurl 2>&1 | tee "${ARTIFACTS_DIR}/functional-tests.log"
fi

echo "==> Verification completed successfully. Artifacts preserved at: ${ARTIFACTS_DIR}"
```

---

## 5. Strict Hurl Functional Test Standards

Every `.verify/functional/<feature>.hurl` file must adhere to these standards:

1. **Assert HTTP Status:** Every request must assert the expected HTTP status code (`HTTP 200`, `HTTP 201`, `HTTP 204`, etc.).
2. **Assert Headers and Body:** Validate content type and assert JSON keys/values via `jsonpath`:
   ```hurl
   GET http://{{host}}:{{port}}/api/v1/jobs/{{job_id}}
   HTTP 200
   [Asserts]
   header "Content-Type" contains "application/json"
   jsonpath "$.id" == "{{job_id}}"
   jsonpath "$.status" == "queued"
   ```
3. **Capture State for Chaining:** Capture created resource IDs using `[Captures]` and reuse in subsequent requests:
   ```hurl
   POST http://{{host}}:{{port}}/api/v1/jobs
   Content-Type: application/json
   { "name": "backup" }
   HTTP 201
   [Captures]
   job_id: jsonpath "$.id"
   ```
4. **Idempotency & Teardown:** Clean up created test resources at the end of the scenario (`DELETE ...`) to prevent state pollution.

---

## 6. Strict Verification Invariants (Negative Constraints)

Autonomous agents verifying code MUST enforce these rules:

1. **Interrogate Code, Not User:** Determine test commands, endpoints, and harness options by navigating repository files.
2. **NEVER Kill by Process Name:** Never use `pkill`, `killall`, or broad pattern killing. Kill ONLY specific processes started by the test run using recorded PIDs.
3. **NEVER Delete Artifacts During Cleanup:** Cleanup removes temporary databases, scratch state, and background daemons. It MUST NEVER delete `.verify/artifacts/`. Test proof must survive teardown.
4. **NEVER Bypass Failed Tests:** If a test fails, do not comment it out, weaken assertions, or edit `.verify/verify.toml` to exclude it. Fix the underlying code.
5. **Doctor Gate First:** If `.verify/doctor.sh` fails, refuse to drive the app. A failing doctor indicates missing seed data, port conflicts, or unapplied migrations. Fix the environment before testing.
6. **Execute via Allowlist:** Always run through `agent-brain verify -- <cmd>`. Direct shell execution without verify earns zero learning and verification credit.
