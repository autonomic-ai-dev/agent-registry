# Curated registry

## What it does

agent-registry is the central index of curated packages, workflows, and utilities. agent-brain syncs it, and agents install packages and run workflows from it.

## How it works

1. **Index.** `registry.json` maps each alias to a package source. Each entry has a `path` into this repository or a `git_url` with a `git_ref`.
2. **Sync.** `agent-brain registry sync` clones or pulls this repository into `~/.autonomic/memory/registry-cache/repo/`.
3. **Install.** `agent-brain package add @agstack` resolves the alias through the index and installs the package. Packages marked `default` bootstrap a new install.
4. **Workflows.** Each file in `workflows/` is a DAG. An agent runs it with agent-spine, or with `scripts/run-workflow.sh` when Spine is not running.

## Where the code is

- `registry.json` and `workflows.json` are the indexes.
- `packages/agstack/` is the agstack package.
- `workflows/` holds the bugfix, feature, stacked-PR, release-notes, and MCP health workflows.
- `scripts/run-workflow.sh` is the zero-dependency runner.
- `utilities/utilities.json` is the utility catalog.

## How to use it

- `agent-brain registry sync` to refresh the cache.
- `agent-brain package add @agstack` to install the default process package.
- `./scripts/run-workflow.sh run workflows/bugfix.yaml` to run a workflow without Spine.

## How it is verified

- No verification suite is defined for this repository in this pass.

## Known limits

- Agents see a change only after they sync the cache.
- Only the `agstack` package is shipped under `packages/`. Other aliases in `registry.json` point to external git sources that this repository does not contain.

## Related

- Feature map: `.verify/features/curated-registry.md`
- Package consumer: agent-brain (`package add`, `registry sync`)
