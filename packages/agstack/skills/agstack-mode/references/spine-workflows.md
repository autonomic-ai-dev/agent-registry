# Spine Workflows & agstack Orchestration

`agstack` pairs with `agent-spine` DAG workflows to orchestrate multi-step, multi-agent operations with checkpoint gates, verification checks, and human approval gates.

---

## 1. Available Registry Workflows

The central registry provides curated DAG workflows under `workflows/` that automate `agstack` playbooks:

| Workflow | Alias | Playbook | Purpose |
|---|---|---|---|
| `workflows/bugfix.yaml` | `@bugfix` | `bug-fix` | Reproduce (failing test) -> Isolate (root cause) -> Fix (immutable) -> Verify (.verify/) -> Review. |
| `workflows/feature.yaml` | `@feature` | `feature` | LoadSpec -> ModelDomain -> FeatureContract -> Implement -> VerifySuites -> QualityGate -> ReviewGate. |
| `workflows/stacked-pr.yaml` | `@stacked-pr` | `pull-request` | AuditStack -> AtomicChunking -> VerificationGate -> RichDescription (HLD/LLD) -> ApprovalGate. |
| `workflows/release-notes.yaml` | `@release-notes` | `technical-writing` | CollectDiff -> DraftNotes (Diátaxis) -> ReviewGate -> Publish. |
| `workflows/mcp-health-check.yaml` | `@mcp-health-check` | `investigation` | AuditSchemas -> ProbeGateway -> VerifyRouting -> Report. |

---

## 2. Invocation Methods

### Method A: CLI Execution
```bash
# Initialize workflow template into repository
agent-spine init --with @bugfix

# Execute workflow directly
agent-spine run workflows/bugfix.yaml

# Run with custom payload parameters
agent-spine run workflows/feature.yaml --payload '{"repo_root":".","feature":"billing-invoices"}'
```

### Method B: MCP Tool Invocation (`agent-body`)
Agents can invoke and monitor workflows autonomously via MCP tools:
```json
// Submit workflow
call_mcp_tool(
  ServerName: "agent-body",
  ToolName: "spine_submit_workflow",
  Arguments: { "workflow": "bugfix", "payload": { "feature": "billing" } }
)

// Check progress
call_mcp_tool(
  ServerName: "agent-body",
  ToolName: "spine_check_status",
  Arguments: { "workflow_id": "<workflow-id>" }
)
```

---

## 3. Node Invariants in Spine Workflows

- **`kind: agent`:** Autonomous execution step (e.g. writing code, reproducing bug).
- **`kind: verify` / `checkpoint`:** Hard automated gate (e.g. executing `.verify/run.sh <feature>`). A failing gate stops the workflow immediately.
- **`kind: approval_gate`:** Pauses execution for human review and sign-off before consequential actions (e.g., merging, deploying, pushing release notes).
