---
name: claim-evidence
description: "Make every claim about code, tests, behaviour, or the environment traceable to evidence, and mark anything unverified. Use before stating that something works, passes, exists, is fixed, or is safe, and before naming a function, file, flag, or command in a reply or a document."
---

# Claim and evidence

Most wrong agent output is a confident claim with no check behind it: a function that does not exist, a test that was never run, a behaviour assumed from the name of a variable. This skill makes the gap visible. A claim carries its evidence, or it is labelled as unverified.

## Classify each claim

- **Verified:** you read it, searched for it, or ran it in this turn. Cite the evidence: `path:line`, the command, and its exit code.
- **Inferred:** you reasoned from verified facts. Say which facts, and what would falsify the inference.
- **Unverified:** you have not checked. Write "unverified" and say what check would verify it.

## Rules

- Do not name a function, type, flag, file, or command unless you confirmed it exists in this turn. Search for it first.
- "Tests pass" requires a recorded run with exit 0. "It should pass" is unverified.
- "Fixed" requires the failing case to be run before and after the change. A change that looks right is inferred.
- Quote numbers from the output, not from memory. A count from an earlier run is stale after any edit.
- Do not round a measured result into a better one. A 97.6% match is not "about 98".
- When a check cannot run, say so in the first line of the report, with the reason.

## Self-check before reporting

Read the report once and mark each sentence with one of the three classes. Any sentence that is a claim with no citation is either removed or marked unverified. A report with no unverified claims and no citations is too thin to trust. Add the evidence.

## Example

Bad: "The migration is backward compatible and all tests pass."

Good: "The migration adds a nullable column (`db/migrate/0042.sql:3`). `cargo test --workspace` exited 0, 48 passed (`.verify/artifacts/body-test.log`). Rolling back the old binary against the new schema is unverified: no run was made."
