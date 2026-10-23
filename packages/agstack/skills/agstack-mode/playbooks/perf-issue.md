# Playbook: Performance Issue (`perf-issue`)

> **Trigger & Intent:** A measured backend latency, throughput bottleneck, high resource consumption, or slow database query/RPC endpoint.
> **Deliverable:** A proven latency/throughput improvement with verified before-and-after baseline metrics.

---

## 1. Session Anchor & TodoList Contract

Before touching code, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/perf-issue.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Establish reproducible baseline benchmark (output -> `.verify/artifacts/baseline.bench`)
- [ ] Step 2: Profile critical path (pprof, flamegraph, or trace -> `.verify/artifacts/trace.json`)
- [ ] Step 3: Implement minimal algorithmic/concurrency fix (no speculative caching)
- [ ] Step 4: Run allowlisted verification and measure post-fix delta (output -> `.verify/artifacts/post.bench`)
- [ ] Step 5: Document maintainer evidence record and stage atomic commit

---

## 2. Core Invariants

1. **Explain the Number:** Before claiming a speedup, identify what limits the current path (CPU bounds, lock contention, sequential DB queries, serialization overhead).
2. **Reproducible Baseline First:** Never optimize without a recorded baseline in `.verify/artifacts/baseline.bench`. An unmeasured optimization is a guess.
3. **Attack Root Bottlenecks:** Prefer reducing algorithmic complexity, collapsing sequential network roundtrips, or eliminating allocations over premature in-memory caching.
4. **Immutability & Zero Comments:** Preserve data immutability and add zero comment slop in the diff.

---

## 3. Checklist Steps

1. **Establish Baseline:** Run or write an allowlisted benchmark command from `.verify/verify.toml`. Record p50, p95, and p99 metrics to `.verify/artifacts/baseline.bench`.
2. **Profile Critical Path:** Attach profiling tools (`pprof`, `cargo flamegraph`, or tracing). Identify the exact function, query, or lock dominating execution time.
3. **Implement Root Fix:** Apply the minimal change (e.g. batching queries, index addition, buffer reuse, parallel fan-out without shared mutable state).
4. **Post-Fix Verification:** Run `.verify/run.sh` to ensure zero behavioral regressions, then rerun the benchmark to `.verify/artifacts/post.bench`. Prove the delta.
5. **Stage & Commit:** Rebase into an atomic commit with benchmark proof.

---

## 4. Evidence Record & Reply Standard

End with the exact Evidence Record:
```markdown
### Performance Evidence Record
- Baseline Metric: [p95: X ms, throughput: Y req/s] (.verify/artifacts/baseline.bench)
- Post-Fix Metric: [p95: A ms, throughput: B req/s] (.verify/artifacts/post.bench)
- Measured Improvement: [Z% latency reduction]
- Verification Suite: `.verify/run.sh` (Exit Code 0)
- Root Cause & Mechanism: [Specific bottleneck resolved]
```
