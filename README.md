# Central Autonomic Registry (`agent-registry`)

The central registry repository for the Autonomic AI agent stack — distributing curated skill packages, workflows, and developer utilities.

## Standardized Layout

```text
agent-registry/
├── registry.json                    # Canonical registry index
├── README.md                        # Documentation & CLI reference
├── packages/                        # Standardized curated packages
│   ├── agstack/                     # agstack (Abhiuday Gupta Stack) — Universal engineering process, playbooks, strict verification, immutability, and zero comment slop
│   ├── coding-policy/               # Legacy alias for agstack
│   ├── autonomic-core/              # Registry discovery & rmcp MCP gateway patterns
│   ├── product-layer/               # Constitution → feature spec lane
│   └── supervisor/                  # Execution supervisor & token-efficient ops
├── workflows/                       # Spine DAG workflows
│   ├── release-notes.yaml
│   ├── stacked-pr.yaml
│   ├── bugfix.yaml
│   └── mcp-health-check.yaml
└── utilities/                       # CLI utility catalog
    └── utilities.json
```

## Client Synchronization (`agent-brain`)

`agent-brain` clones and pulls this repository dynamically into `~/.autonomic/memory/registry-cache/repo/`:

```bash
agent-brain registry sync
```

Install packages directly from the synced registry:

```bash
agent-brain package add @agstack
agent-brain package add @autonomic-core
```
