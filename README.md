# agent-registry

Central Autonomic Registry — skill packages, workflows, utilities, and future organ kinds.

`agent-brain` syncs this repo into `~/.agent_brain/registry-cache/` and falls back to the embedded snapshot when offline.

## Layout

```
manifest.json
packages.json
utilities.json
workflows.json
workflows/*.yaml
autonomic-core/
supervisor/
```

## Sync

```bash
agent-brain registry sync
```

Configure in `~/.agent_brain/config.yaml`:

```yaml
registry:
  enabled: true
  remote_repo: autonomic-ai-dev/agent-registry
  remote_ref: main
  registry_subpath: ""
```

## Spine

```bash
agent-brain registry sync --local
agent-spine init --with @release-notes
```
