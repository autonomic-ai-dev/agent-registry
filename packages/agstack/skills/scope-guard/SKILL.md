---
name: scope-guard
description: "Keep a task to what was asked. Use at the start of any task to write the scope, and whenever the work starts to touch files, behaviour, or refactors the user did not ask for. Routes extra ideas into a follow-up list instead of the diff."
---

# Scope guard

Agents expand tasks. A bug fix becomes a refactor, a feature gains an option nobody asked for, and a review finds ten things and fixes all of them. The result is a larger diff that is harder to review and more likely to break something. This skill fixes the scope before the work starts and keeps it there.

## Write the scope first

Before editing, write three lists in the task notes:

- **In scope:** the behaviour the user asked for, in the user's words where possible.
- **Out of scope:** what is adjacent and tempting, named explicitly.
- **Done when:** the acceptance check, as a command or an observable result.

Show the three lists to the user only when the in-scope list is inferred rather than stated. Otherwise keep them in the notes.

## During the work

- Before touching a file outside the in-scope list, check whether the change is required for the in-scope behaviour. If it is not, do not make it.
- When a tempting change appears, add it to the follow-up list with one line on why it matters. Do not put it in the diff.
- Renames, reformatting, and cleanups of untouched code are out of scope unless the user asked for them.

## Follow-ups

Keep a follow-up list in the report. Each item states the file or behaviour, the reason, and the size (small, medium, large). The user decides which become tasks. Do not start them.

## When the scope is wrong

If the in-scope work cannot be done without an out-of-scope change, stop and say so. Name the change, why it is required, and its blast radius. Ask one question: include it or split it out. Wait for the answer when it changes the risk of the work (a shared interface, a public API, data).

## Rules

- A bug fix does not include the refactor that would have prevented it. Propose the refactor as a follow-up.
- A feature does not include options the user did not ask for.
- A review does not include fixes unless the user asked for them. Report the findings, then fix on request.
- "While I was here" is the phrase that starts scope creep. Route the change to the follow-up list instead.
