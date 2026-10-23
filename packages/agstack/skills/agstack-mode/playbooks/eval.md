# Playbook: Evaluation (`eval`)

> **Trigger & Intent:** Evaluating, benchmarking, or regression-testing an agent skill, system prompt instruction, or routing heuristic against a standardized evaluation dataset before promotion.
> **Deliverable:** A quantitative evaluation matrix comparing baseline vs candidate performance across test cases.

---

## 1. Session Anchor & TodoList Contract

Before modifying skills or prompts, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/eval.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Identify golden eval dataset and scoring rubric
- [ ] Step 2: Run baseline eval run and compute accuracy / adherence score (output -> `.verify/artifacts/eval-baseline.json`)
- [ ] Step 3: Apply proposed skill, prompt, or routing modification
- [ ] Step 4: Run candidate eval run (output -> `.verify/artifacts/eval-candidate.json`)
- [ ] Step 5: Deliver comparative evaluation scorecard and promotion decision

---

## 2. Core Invariants

1. **Golden Dataset Immutability:** Test cases and ground truth answers in the evaluation dataset are strictly read-only.
2. **Quantitative Scoring:** Adherence must be evaluated on objective criteria (binary pass/fail assertions, regex matches, schema validity).
3. **No Regressions on Golden Cases:** A candidate that improves one edge case but breaks previously passing golden cases is rejected.

---

## 3. Checklist Steps

1. **Dataset Review:** Load evaluation cases from `.verify/eval/` or test harness.
2. **Run Baseline:** Execute eval runner against current version. Save output to `.verify/artifacts/eval-baseline.json`.
3. **Implement Modification:** Make surgical changes to prompt, rule, or skill.
4. **Run Candidate:** Execute eval runner against modified version. Save output to `.verify/artifacts/eval-candidate.json`.
5. **Diff & Score:** Compute pass-rate delta. If candidate improves overall score without regressions, approve for promotion.

---

## 4. Evidence Record & Reply Standard

```markdown
### Evaluation Scorecard
- Eval Suite: [e.g. route_task classification benchmark]
- Baseline Pass Rate: [42/45 (93.3%)] (.verify/artifacts/eval-baseline.json)
- Candidate Pass Rate: [45/45 (100.0%)] (.verify/artifacts/eval-candidate.json)
- Regressions Detected: 0
- Promotion Decision: APPROVED
```
