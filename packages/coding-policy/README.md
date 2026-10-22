# Strict Coding-Agent Policy & Verification Bundle

A unified engineering bundle for Cursor, Claude Code, Antigravity CLI (`agy`), OpenCode, and Augment Code.

Combines three pillars into a single bundle to help autonomous agents write clean, idiomatic, fully tested code:
1. **Strict Coding Policy:** Immutability, native tools first (no Python as shell/reader workaround), no unnecessary comments, minimal diffs, least privilege.
2. **Feature Mapping (`@feature-map`):** Behavior contracts under `.verify/features/` capturing sub-features, user entry points, and known gotchas—linked directly to test commands.
3. **Test Verification Harness (`@verification`):** `.verify/verify.toml` allowlist, `.verify/run.sh` composite runner, unit tests, and declarative Hurl API functional suites under `.verify/functional/`.

---

## What is in this bundle

```text
coding-policy/
├── AGENTS.md                  # Canonical shared policy across all agents
├── .cursor/
│   ├── rules/
│   │   ├── coding-policy.mdc  # Core engineering policy rule
│   │   ├── feature-map.mdc    # Feature map policy (.verify/features/)
│   │   └── verification.mdc   # Test verification policy (verify.toml + Hurl)
│   └── skills/
│       ├── feature-map/       # Feature map generator skill
│       └── verification/      # Test verification harness skill
├── skills/
│   ├── feature-map/SKILL.md   # Agent-agnostic feature-map skill
│   └── verification/SKILL.md  # Agent-agnostic verification skill
├── antigravity/AGENTS.md      # Antigravity CLI instructions
├── claude/CLAUDE.md           # Claude Code instructions
├── opencode/AGENTS.md         # OpenCode instructions
├── augment/AGENTS.md          # Augment Code instructions
├── scripts/
│   ├── check-added-comments.sh
│   └── install-git-hook.sh
└── .github/workflows/
    └── no-added-comments.yml
```

---

## Install

```bash
agent-brain install @coding-policy
```

Or via project initialization:
```bash
agent-brain verify init
```

---

## Workflow in Repositories

1. **Before Modifying Code:**
   - Review relevant contracts in `.verify/features/<feature>.md`.
   - Read `## How to get to it (user POV)` and `## Gotchas`.
2. **Implement Code:**
   - Adhere to native tools, strict immutability, and no stray comments.
3. **Execute Linked Verification:**
   - Run the exact targeted unit and Hurl test commands specified under `## Verification Suites`:
     ```bash
     agent-brain verify -- <unit-test-command>
     agent-brain verify -- hurl --test .verify/functional/<feature>.hurl
     ```
4. **Preserve Proof:**
   - Ensure all output logs and reports are captured under `.verify/artifacts/`.
