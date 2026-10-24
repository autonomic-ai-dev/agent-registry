---
name: ui-testing
description: "Test a UI in layers: functional end-to-end flows, visual regression against baselines, responsive checks, and accessibility. Every layer runs through the repository's .verify/ allowlist and writes evidence under .verify/artifacts/. Use whenever a UI change needs proof that it works."
---

# UI Testing

A UI change is proven by four layers. Each layer is a command in `.verify/verify.toml`, so the evidence counts. A command outside the allowlist does not.

## Layers

1. **Functional flows.** End-to-end tests of what a user does: navigate, submit, see the result. Assert on visible text, roles, and state, not on CSS classes.
2. **Visual regression.** Capture each covered screen and diff it against its committed baseline (`pixel-perfect-ui`). A changed baseline needs a reason in the PR.
3. **Responsive.** Capture each breakpoint and check the measured rules (`responsive-ui`).
4. **Accessibility.** Each interactive element has an accessible name and role. Text meets contrast requirements. Focus is visible and reachable by keyboard.

## Steps

1. **Find the commands.** Read the repository's existing test setup first. Use its runner for the functional layer. Do not add a second test framework.
2. **Write the flow test before the fix.** A bug fix in the UI starts with a flow test that fails on the bug. That test is the regression test.
3. **Register each layer in the allowlist.** Add the command to `.verify/verify.toml`. Keep the command a plain string with no dynamic command names, since the preflight rejects them.
4. **Run through the gate.** `agent-brain verify -- <command>` for each layer. Keep the output under `.verify/artifacts/ui/`.
5. **Report per layer.** State the pass or fail count for each layer, the artifact paths, and the threshold used for visual comparisons.

## Rules

- Do not weaken an assertion, widen a threshold, or delete a flow to make a run pass. Fix the UI, or record the failure with evidence.
- Tests must not depend on live external services. Stub them at the boundary.
- Do not wait on fixed sleeps. Wait for a visible state.
- Flaky tests are defects. Quarantine one only with an issue reference and a deadline, and never in the required gate.
