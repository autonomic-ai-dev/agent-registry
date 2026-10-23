# Playbook: Infrastructure Orchestration (`infrastructure-orchestration`)

> **Trigger & Intent:** Authoring or managing background service daemons (`launchd`, `systemd`), Unix domain socket IPC, inter-process signal handling (`SIGTERM`, `SIGINT`), supervisor restarts, and OS-level runtime topology.
> **Deliverable:** Robust service daemonization with graceful shutdown handling, crash recovery, and socket cleanups.

---

## 1. Session Anchor & TodoList Contract

Before authoring daemon configs, emit the Session Anchor and copy these 5 steps verbatim into your active plan:

```markdown
> **Session Anchor:**
> - **Target Output Root**: `.verify/` (fixtures in `verify/` remain strictly read-only)
> - **SDLC Orchestrator**: `agstack` (`playbooks/infrastructure-orchestration.md` / `skills/verification/SKILL.md`)
```

- [ ] Step 1: Model daemon lifecycle (socket binding, PID tracking, signal traps)
- [ ] Step 2: Author service manifest (`launchd.plist` or `systemd.service`) with non-root privileges
- [ ] Step 3: Implement graceful draining and socket unlinking on shutdown
- [ ] Step 4: Verify start, stop, restart, and SIGTERM behavior via harness in `.verify/`
- [ ] Step 5: Run allowlisted verification suite (`.verify/run.sh`) and deliver evidence record

---

## 2. Core Invariants

1. **Clean Socket Unlinking:** When a daemon binds a Unix domain socket (`/tmp/service.sock`), it must cleanly unlink any stale dead socket file before binding, and unlink on shutdown.
2. **Graceful Signal Draining:** Intercept `SIGTERM` and `SIGINT` to complete active in-flight requests before terminating (with a hard shutdown timeout).
3. **PID File Management:** Record active daemon PID cleanly. Never kill processes by generic pattern; kill only recorded PIDs.
4. **Least Privilege:** Daemons should not run as `root` unless explicitly required for kernel capabilities.

---

## 3. Checklist Steps

1. **Topology Definition:** Determine IPC transport (Unix domain socket, loopback TCP, named pipe), logging target, and working directory.
2. **Author Configuration:** Author valid XML plist for macOS `launchd` or INI service unit for `systemd`.
3. **Signal & Shutdown Handling:** Write or inspect signal handlers in application code to ensure active connections drain gracefully.
4. **Lifecycle Verification:** Start daemon in isolated test harness, verify socket connectivity, dispatch `SIGTERM`, and verify exit code 0 and clean socket file removal. Output log to `.verify/artifacts/daemon-test.log`.
5. **Full Suite Verification:** Run allowlisted `.verify/run.sh`.

---

## 4. Evidence Record & Reply Standard

```markdown
### Infrastructure Orchestration Evidence Record
- Service Name: [e.g. agent-body / service-daemon]
- Socket IPC Path: [e.g. ~/.autonomic/serve.sock]
- Lifecycle Verified: [Start -> Socket Listen -> Signal Drain -> Clean Exit]
- Test Artifact: `.verify/artifacts/daemon-test.log` (Exit Code 0)
- Verification Suite: `.verify/run.sh` (Exit Code 0)
```
