# Central Autonomic Registry (`agent-registry`)

The central registry repository for the Autonomic AI agent stack — distributing curated skill packages, workflows, and developer utilities.

## Standardized Layout

```text
agent-registry/
├── registry.json                    # Canonical registry index
├── README.md                        # Documentation & CLI reference
├── packages/                        # Standardized curated packages
│   └── agstack/                     # agstack (Abhiuday Gupta Stack) — Universal full-SDLC engineering operating system
├── workflows/                       # Spine DAG workflows
│   ├── bugfix.yaml                  # @bugfix — Failing repro -> root cause -> minimal fix -> verify -> review
│   ├── feature.yaml                 # @feature — Intent -> model domain -> 4-H2 contract -> implement -> Hurl suites -> gate
│   ├── stacked-pr.yaml              # @stacked-pr — Atomic chunking -> verification -> rich PR description -> approval
│   ├── release-notes.yaml           # @release-notes — Diff collection -> Diátaxis notes -> review -> publish
│   └── mcp-health-check.yaml        # @mcp-health-check — Schema audit -> gateway probe -> routing verify
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
```
