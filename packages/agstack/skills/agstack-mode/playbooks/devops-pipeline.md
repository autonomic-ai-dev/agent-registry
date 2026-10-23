# Playbook: DevOps Pipeline (`devops-pipeline`)

> **Trigger & Intent:** Authoring, fixing, or optimizing CI/CD automation pipelines (GitHub Actions, GitLab CI), multi-architecture containerization (Docker, Podman), build scripts, or release publishing pipelines.
> **Deliverable:** A hermetic, reproducible, and secure pipeline configuration with verified local syntax validation and mock run.

---

## 1. Session Anchor & TodoList Contract

Before authoring pipeline files, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/devops-pipeline.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Interrogate build matrix, dependencies, secrets, and target runners
- [ ] Step 2: Implement hermetic workflow steps with pinned action hashes and layer caching
- [ ] Step 3: Lint workflow syntax locally (`actionlint` or schema validator -> `.verify/artifacts/actionlint.log`)
- [ ] Step 4: Verify container builds locally (`docker buildx` / multi-arch dry run)
- [ ] Step 5: Run allowlisted verification suite (`.verify/run.sh`) and stage atomic commit

---

## 2. Core Invariants

1. **Security & Pinned Actions:** Never use floating tags (`@v1`, `@master`) for third-party actions. Pin by full immutable commit SHA with a version comment (`uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1`).
2. **Secrets Hygiene:** Never print environment variables or secrets into stdout/stderr logs. Mask tokens and credentials properly.
3. **Hermetic Layer Caching:** Structure Dockerfiles with dependencies installed in early cached layers before copying changing source code.
4. **Local Lint Before Push:** Run `actionlint` or Dockerfile linters locally before pushing changes to remote CI.

---

## 3. Checklist Steps

1. **Pipeline Spec Interrogation:** Identify needed job stages (lint, test, build, notarize, publish), trigger paths, concurrency rules, and runner OS matrix.
2. **Author Workflow / Containerfile:** Write declarative YAML or Dockerfile adhering to least privilege and caching best practices.
3. **Local Syntax & Schema Audit:** Run `actionlint` against `.github/workflows/` and write lint output to `.verify/artifacts/actionlint.log`.
4. **Dry-Run Build:** Test container build locally or run workflow simulation (e.g. `act` if available).
5. **Verify Project Integration:** Run allowlisted `.verify/run.sh` to ensure no repository paths or hooks were broken.

---

## 4. Evidence Record & Reply Standard

```markdown
### DevOps Pipeline Evidence Record
- Workflow Files Modified: [.github/workflows/ci.yml, Dockerfile]
- Syntax Validation: `actionlint` (Exit Code 0, `.verify/artifacts/actionlint.log`)
- Multi-Arch Support: [darwin-arm64, linux-x86_64 verified]
- Caching Strategy: [Hermetic layer caching with cache-from/cache-to]
- Security Audit: [All 3rd-party actions pinned to immutable commit SHAs]
```
