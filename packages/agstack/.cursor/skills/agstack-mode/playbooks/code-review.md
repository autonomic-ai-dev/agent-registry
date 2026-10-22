# Playbook: Code Review & Interrogation

Use this playbook before declaring any task complete, opening a pull request, or committing changes.

---

## Process Steps

### Step 1: Full Working Tree & Diff Audit
- Inspect `git diff` against `master`:
  - Check that only intended files were modified.
  - Verify no accidental edits, temporary debug logs, or commented-out corpses exist.
  - Run `scripts/check-added-comments.sh` to guarantee no AI narration comments were introduced.

### Step 2: Adversarial Security & Concurrency Audit
- Ground in the `interrogate` skill:
  - Are inputs validated and parameterized against SQL/command injection?
  - Do external calls have explicit timeouts?
  - Are retries bounded with backoff and jitter?
  - Do error paths release locks, file handles, and database connections?

### Step 3: Blast Radius & Regression Verification
- Run `blast-radius` checks on modified symbols:
  - Did any caller signature break?
  - Does every fixed defect have an accompanying regression test that failed on the unfixed baseline?
  - Did any existing test break, get skipped, or get loosened? (Zero tolerance for test weakening).

### Step 4: Quality Gate Execution
- Execute the full repository verification runner:
  ```bash
  sh .verify/run.sh all
  ```
- Generate the final evidence record with exit codes and measured coverage.
