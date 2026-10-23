# Playbook: Authoring a Skill (`authoring-a-skill`)

> **Trigger & Intent:** Creating, modifying, or refactoring an agent skill specification adhering to the Open Agent Skills Standard (`SKILL.md`).
> **Deliverable:** A validated, high-signal, token-efficient skill specification with clear intent triggers and reference docs.

---

## 1. Session Anchor & TodoList Contract

Before authoring skills, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/authoring-a-skill.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Define skill name, description, and unambiguous activation triggers
- [ ] Step 2: Author YAML frontmatter (`name`, `description`, `disable-model-invocation: true`)
- [ ] Step 3: Write concise, actionable instructions and non-negotiable invariants
- [ ] Step 4: Extract voluminous reference tables or scripts into `references/` or `scripts/`
- [ ] Step 5: Test skill retrieval via `agent-brain skill_search` and verify with `.verify/run.sh`

---

## 2. Core Invariants

1. **Token Efficiency:** Keep `SKILL.md` under 200 lines. Move large reference tables, formats, and API schemas to separate files under `references/`.
2. **Third-Person Description:** The description must state *what* the skill does and *when* to use it in clear third-person language.
3. **No Fluff:** Remove tutorial chatter, greetings, or narrative explanations. Provide instructions as direct imperatives.

---

## 3. Checklist Steps

1. **Scope Definition:** Determine skill domain and keyword triggers.
2. **Author SKILL.md:** Include valid YAML frontmatter and clear operational instructions.
3. **Structure Subdirectories:** Place executable helpers in `scripts/` and extended reading in `references/`.
4. **Validation:** Validate that markdown syntax is valid and free of broken links.
5. **Index & Probe:** Verify discovery via `agent-brain skill_search <keyword>`.

---

## 4. Evidence Record & Reply Standard

```markdown
### Skill Authoring Evidence Record
- Skill Name: [name]
- Location: [packages/agstack/skills/<name>/SKILL.md]
- Token Count: [lines < 200 verified]
- References Created: [references/details.md]
- Discovery Probe: `skill_search` verified (Exit Code 0)
```
