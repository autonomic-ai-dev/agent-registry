---
name: release-management
description: "Cut a release safely: version bump, changelog, signed tag, release notes, and a rollback plan. Use when the user asks to release, tag, publish, or prepare a version, or when a release PR is about to be merged."
---

# Release management

A release is an outward action: it reaches users, package managers, and downstream repositories. It is hard to undo, so the steps are fixed and each one is checked. This skill does not publish without explicit authorization.

## Authorization

Tag, publish, or push a release only when the user has asked for that specific release in this session. A request to "prepare" a release does not authorize the tag. Confirm the version and the target branch before any outward step.

## Steps

1. **Confirm the release scope.** Which repositories, which version, from which branch. List them in the report.
2. **Check the release gate.** The required checks for each repository pass on the release commit, and the verification run is recorded (`skills/verification`). A failing or missing gate blocks the release.
3. **Bump the version** in the repository's manifests with one change set. Use the versioning scheme the repository already uses. A pre-release gets its own tag (for example `v1.0.0-rc1`), not a rewritten version.
4. **Write the changelog entry** from the merged changes since the last tag. Group by change type. Link each entry to its PR or commit. Do not write an entry for a change that was not merged.
5. **Merge the release PR** only after its checks pass and the user has authorized the merge.
6. **Tag** the merged commit with the signed tag the repository uses. Confirm the tag points at the intended commit before pushing it.
7. **Write the release notes** from the changelog, for users: what changed, what to do, what broke. Name any breaking change and the migration.
8. **Record the rollback:** the previous tag, and the command that reverts to it.

## Rules

- A release commit is never changed after tagging. A fix is a new version.
- Do not force-push a tag or a release branch.
- Downstream repositories that pin the version are updated in their own PRs after the tag exists, in dependency order. Do not update them before the tag.
- If any step fails after the tag exists, stop. Report the state and the rollback. Do not retry the tag.
