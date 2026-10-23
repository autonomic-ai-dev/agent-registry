# Playbook: Trace Forensics (`trace-forensics`)

> **Trigger & Intent:** Diagnosing a captured profiling or execution artifact handed in post-mortem (e.g. `pprof` profile, `cpuprofile`, flamegraph, heap dump, eBPF trace, or OpenTelemetry JSON trace dump).
> **Deliverable:** An evidence-backed diagnosis isolating the dominant flame or bottleneck without speculative changes.

---

## 1. Session Anchor & TodoList Contract

Before inspecting or editing, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/trace-forensics.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Parse and validate input profiling artifact format
- [ ] Step 2: Extract top-K cumulative and flat execution frames
- [ ] Step 3: Map dominating frames to codebase AST symbols and source locations
- [ ] Step 4: Rule out measurement artifacts (profiler skid, GC pauses, sampling bias)
- [ ] Step 5: Deliver concrete architectural diagnosis and transition plan

---

## 2. Core Invariants

1. **No Speculative Code Changes:** Do not start editing source files during trace forensics. Diagnose the profile first.
2. **Explain the Flame:** Identify whether the time is spent in user logic, system calls, synchronization mutexes, or serialization/runtime overhead.
3. **Artifact Integrity:** Store parsed summaries and extracted hot paths under `.verify/artifacts/`. Do not overwrite golden inputs.

---

## 3. Checklist Steps

1. **Profile Parsing:** Ingest the trace using native toolchain utilities (`go tool pprof`, `perf report`, `flamegraph.pl`, or `speedscope`).
2. **Top Frame Extraction:** Identify the top 5 functions by self/flat time and cumulative time.
3. **Source Mapping:** Link frame symbols to repository file lines using `grep_search` and `file_summary`.
4. **Sanity Check:** Verify whether the hotspot is genuine CPU work or blocked I/O misattributed as CPU time.
5. **Formulate Diagnosis:** Deliver concise diagnosis explaining what the program spent time doing.

---

## 4. Evidence Record & Reply Standard

```markdown
### Trace Forensics Diagnosis
- Input Artifact: [path to trace artifact]
- Parsed Summary: `.verify/artifacts/trace-summary.txt`
- Dominant Frames:
  1. `crypto/tls.(*Conn).readRecord` (42% cumulative)
  2. `json.Unmarshal` (28% cumulative)
- Root Cause: [Repeated JSON deserialization inside inner loop for each TLS packet]
- Recommendation: Transition to `perf-issue` or `refactoring` playbook.
```
