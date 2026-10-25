# Playbook: Executive & Specialist Review (`gstack-review`)

> **Trigger & Intent:** Brainstorming product ideas, YC office hours, seeking CEO/founder 10-star product reviews, design audits (0-10 rating), developer experience critiques (TTHW), or running the sequential Autoplan pipeline.
> **Deliverable:** Multi-dimensional specialist review deliverable and actionable assignment adhering to Garry Tan's *gstack* AI engineering workflow.

---

## 1. Session Anchor & TodoList Contract

Before authoring reviews, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/gstack-review.md` / `skills/gstack/SKILL.md`)
```

- [ ] Step 1: Specialist Lens Calibration (identify role: YC Office Hours, CEO 10-Star, Design, DevEx, Eng, or Autoplan)
- [ ] Step 2: Premise Challenge & One-Question Probing (ask questions one at a time; interrogate the hair-on-fire customer)
- [ ] Step 3: Propose 2-3 Distinct Alternatives (uncover unconsidered product/architecture directions)
- [ ] Step 4: Author Multi-Dimensional Critique & Design Doc (score dimensions 0-10, specify concrete fixes)
- [ ] Step 5: Deliverable & Mandatory Real-World Assignment (assign a tangible action item for the builder/founder)

---

## 2. Core Invariants

1. **Ask Questions One at a Time:** Never batch multiple questions together. Wait for user signal before advancing.
2. **Never Implement During Ideation:** Conceptual reviews produce specs, design docs, and assignments—never code or premature scaffolding.
3. **Eng Review Always Last in Autoplan:** When running the full pipeline (`autoplan`), sequence is strictly CEO -> Design -> DevEx -> Eng review.
4. **Mandatory Real-World Assignment:** Every session must conclude with a concrete, testable action item outside the editor.
5. **Score Rigor (0-10):** For design reviews, never provide vague praise. Score each dimension 0–10 and describe what a 10 looks like with explicit CSS/layout adjustments.

---

## 3. Checklist Steps

1. **Lens Selection:** Select the active specialist perspective:
   - *office-hours:* YC partner challenging early premises and market demand.
   - *plan-ceo-review:* Finding the 10-star product experience and distribution wedge.
   - *plan-design-review:* Evaluating UI clarity, typography, visual hierarchy, mobile polish.
   - *plan-devex-review:* Measuring Time-To-Hello-World, developer empathy, friction points.
   - *plan-eng-review:* Locking down schemas, failure domains, edge cases, immutability.
   - *autoplan:* Executing all four reviews in sequence.
2. **Execute Probing Phase:** Ask 1 probing question to expose unexamined assumptions.
3. **Premise Challenge:** Test whether the user is trying to solve the right problem.
4. **Explore Forced Alternatives:** Detail 2–3 radically different ways to solve the problem (e.g. manual workflow, browser extension, CLI tool, or native platform capability).
5. **Synthesize Findings:** Deliver the structured evaluation.
6. **Assign the Next Action:** Give the user their real-world assignment for the week.

---

## 4. Evidence Record & Reply Standard

```markdown
### Executive Review Evidence Record (`gstack`)
- Active Specialist Lens: [YC Partner / CEO / Design Lead / DevEx Lead / Eng Manager / Autoplan]
- Premise Evaluated: [Summary of core assumption challenged]
- 10-Star Insight: [What elevates this from marginal to category-defining]
- Quality Scores (if Design/DX): [Dimension ratings 0-10]
- The Assignment: [Single concrete real-world action to execute next]
```
