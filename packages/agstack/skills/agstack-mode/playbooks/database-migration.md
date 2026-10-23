# Playbook: Database Migration (`database-migration`)

> **Trigger & Intent:** Creating, modifying, or applying backend database schemas, SQL tables, indexes, or data transformations in relational (PostgreSQL, SQLite, MySQL) or document stores.
> **Deliverable:** A zero-downtime, backward-compatible migration with verified up and down rollback paths and transaction safety.

---

## 1. Session Anchor & TodoList Contract

Before authoring migration scripts, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/database-migration.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Model schema delta using expand/contract pattern (verify backward compatibility)
- [ ] Step 2: Author atomic forward migration SQL/script and exact rollback script
- [ ] Step 3: Test migration execution against ephemeral test database in `.verify/`
- [ ] Step 4: Test rollback execution (down) and verify zero state residue
- [ ] Step 5: Run allowlisted verification suite (`.verify/run.sh`) and deliver evidence record

---

## 2. Core Invariants

1. **Zero-Downtime Expand/Contract:** Never perform breaking changes (renaming columns, dropping active tables) in a single step. Follow expand (add new, dual-write) $\rightarrow$ contract (deprecate, drop).
2. **Mandatory Rollback Script:** Every forward migration must ship with a fully functional down/rollback migration.
3. **Locking Safety:** Avoid operations that take long exclusive table locks on large tables (`ALTER TABLE ... ADD COLUMN ... DEFAULT ...` without modern fast-default support). Create indexes concurrently where supported (`CREATE INDEX CONCURRENTLY`).
4. **Idempotence & Transaction Wrapping:** Migrations must execute inside transactions (`BEGIN` / `COMMIT`) where DDL permits.

---

## 3. Checklist Steps

1. **Schema Review:** Inspect existing schema, indexes, and foreign keys. Determine if column additions require NULLable initial state or default values.
2. **Author Forward & Rollback:** Write the forward migration file and corresponding rollback script in the project's migration directory.
3. **Dry-Run Forward Migration:** Execute migration against a test database instance. Output migration logs to `.verify/artifacts/migration-up.log`.
4. **Dry-Run Rollback:** Execute the down migration. Output logs to `.verify/artifacts/migration-down.log`. Assert schema returns to pre-migration baseline.
5. **Full Suite Verification:** Run `.verify/run.sh` to ensure application queries succeed against the newly migrated schema.

---

## 4. Evidence Record & Reply Standard

```markdown
### Database Migration Evidence Record
- Forward Migration: [filename] -> Status: SUCCESS (.verify/artifacts/migration-up.log)
- Rollback Migration: [filename] -> Status: SUCCESS (.verify/artifacts/migration-down.log)
- Backward Compatibility: [Verified: old queries function against expanded schema]
- Verification Suite: `.verify/run.sh` (Exit Code 0)
- Lock Safety Audit: [No blocking table locks detected]
```
