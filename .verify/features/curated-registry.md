# curated-registry

Summary: agent-registry is the central index of curated skill packages, DAG workflows, and developer utilities for the Autonomic stack. agent-brain syncs it to a local cache and installs packages from it.

## Sub-features

- `registry-index`: Lists every package and its source in one file.
  - Intent: Give agent-brain one canonical place to find a package.
  - Behaviour: `registry.json` maps each alias (for example `agstack`) to a local `path` or a `git_url` and `git_ref`. Packages marked `default` bootstrap a fresh install.
  - Outcome: `agent-brain package add @agstack` resolves the alias through this index. Not verified in this pass.
- `agstack-package`: Ships the agstack engineering process as an installable package.
  - Intent: Give every agent the same verification and process standards.
  - Behaviour: `packages/agstack/` holds the playbooks, the verification skill, and the strict-verification layout.
  - Outcome: Installed agents read the same process files. Not verified in this pass.
- `dag-workflows`: Defines the bugfix, feature, stacked-PR, release-notes, and MCP health workflows as YAML DAGs.
  - Intent: Let agents run the same multi-step process with or without agent-spine.
  - Behaviour: The files in `workflows/` run under `agent-spine run workflows/<name>.yaml` or `scripts/run-workflow.sh run workflows/<name>.yaml` (no Spine).
  - Outcome: Each workflow reaches its gate. Not verified in this pass.
- `utility-catalog`: Lists the developer utilities.
  - Behaviour: `utilities/utilities.json`.

## Code

- `registry.json`
- `workflows.json`
- `packages/`
- `workflows/`
- `scripts/`
- `utilities/`

## How to get to it (user POV)

- Run `agent-brain registry sync` to refresh the local cache at `~/.autonomic/memory/registry-cache/repo/`.
- Run `agent-brain package add @agstack` to install a package.

## Verification Suites (Targeted Test Commands)

- Not defined in this repository's allowlist for this pass.

## Gotchas

- `agent-brain` reads a cached copy of this repository. A change here takes effect for agents only after they sync.
- A package entry needs either `path` or `git_url`. An entry with neither has no source to install.
- The workflows need agent-spine to run as a DAG. Without it, an agent runs the steps itself or uses `scripts/run-workflow.sh`.
