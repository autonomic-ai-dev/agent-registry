---
name: dependency-hygiene
description: "Keep dependencies current, audited, and pinned without churn. Use when adding a dependency, when a security advisory or a Dependabot alert appears, or when a build breaks after an update."
---

# Dependency hygiene

Every dependency is code the team did not write and must maintain. Adding one is a decision, and updating one is a change with risk. This skill sets the rules for both, and for responding to advisories.

## Adding a dependency

1. **Check the standard library and the existing dependencies first** (`skills/token-efficiency`). A dependency for a few lines of logic is rejected.
2. **Check the candidate:** maintenance (recent releases, open issues), licence, size, and known advisories. Record the result.
3. **Pin it** to the exact version the lock file uses. Commit the lock file change in the same change.
4. **Record the decision** in the decision log (`skills/decision-memory`) with the reason it was chosen over the alternative.

## Advisories and alerts

1. **Triage by reachability.** Is the vulnerable function called by this code, reachable from input? An advisory on an unused path is lower priority, but still tracked.
2. **Fix by the smallest update** that resolves the advisory, within the same major version when possible.
3. **Run the full gate** after the update. A dependency update that passes only the build is not verified.
4. **If no fix exists,** record the advisory, the mitigation, and the date to review it. Do not silence the alert without a recorded decision.

## Updating

- Update in small groups, one ecosystem at a time. A bulk update makes a failure impossible to attribute.
- Read the changelog for each major version. Note any change that touches a call site in this repository.
- Do not combine an update with a feature change. The update gets its own PR.

## Rules

- Never edit a lock file by hand.
- Do not add an override or a resolution that hides a transitive version without recording why.
- A dependency that is no longer used is removed in its own change, with the check that proves nothing imports it.
