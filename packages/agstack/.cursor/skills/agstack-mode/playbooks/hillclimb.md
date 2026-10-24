# Playbook: Hillclimb (`hillclimb`)

> **Trigger & Intent:** Sustained, scientific optimization of a quantitative backend metric (e.g. token efficiency, p99 latency, memory footprint, cache hit ratio, serialization throughput) across iterative hypotheses.
> **Deliverable:** Iterative improvements with a hypothesis log and one atomic git commit per accepted win.

---

## 1. Session Anchor & TodoList Contract

Before touching code, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/hillclimb.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Establish deterministic automated metric harness (output -> `.verify/artifacts/hillclimb-baseline.log`)
- [ ] Step 2: Formulate testable hypothesis table (mechanism, expected delta, risks)
- [ ] Step 3: Iterate hypotheses in isolation (revert discarded trials immediately)
- [ ] Step 4: Verify invariance via allowlisted `.verify/run.sh` on every candidate
- [ ] Step 5: Commit accepted wins atomically and output iteration decision log

---

## 2. Core Invariants

1. **One Commit per Accepted Win:** Never bundle speculative changes together. Each accepted improvement gets its own commit with benchmark evidence.
2. **Immediate Reversion of Losses:** When a candidate fails to beat the baseline or introduces regressions, discard changes cleanly via `git checkout`.
3. **Behavioral Invariance:** Functional tests in `.verify/run.sh` must pass on every iteration. Speed without correctness is rejected.
4. **Zero AI Comment Slop:** Code must remain clean, self-documenting, and free of commented-out experiments.

---

## 3. Checklist Steps

1. **Deterministic Harness:** Create or verify an allowlisted benchmark script in `.verify/verify.toml` that outputs a single target scalar (e.g. `latency_us`, `bytes_allocated`). Run 3 iterations and record median to `.verify/artifacts/hillclimb-baseline.log`.
2. **Hypothesis Formulation:** Rank 3-5 structural hypotheses based on profile data (e.g. memory arena allocation, zero-copy buffer slicing, SIMD vectorization).
3. **Test Hypotheses:** For each hypothesis:
   - Implement minimal code change.
   - Run functional verification: `.verify/run.sh`.
   - Measure metric delta: if delta > 5% without regressions, accept. Otherwise `git checkout -- .`.
4. **Log Results:** Append trial outcome to `.verify/artifacts/hillclimb-log.md`.
5. **Commit:** Commit accepted iterations.

---

## 4. Evidence Record & Reply Standard

```markdown
### Hillclimb Decision Log
| Trial | Hypothesis | Baseline | Result | Outcome | Commit |
|---|---|---|---|---|---|
| 1 | Zero-copy slice deserialization | 1420 us | 1080 us | ACCEPT (+24%) | abc1234 |
| 2 | In-memory hash pre-sizing | 1080 us | 1065 us | REJECT (<2% gain) | Reverted |
- Verification Suite: `.verify/run.sh` (Exit Code 0)
- Artifact: `.verify/artifacts/hillclimb-log.md`
```
