---
name: intent-clarification
description: "Decide when to ask the user a question and how to ask it. Use when a request is ambiguous, when two readings would lead to different work, or when a choice depends on a fact only the user has. Prefers answering from the repository, asks one question with a stated default, and never stalls on something that can be checked."
---

# Intent clarification

Agents fail in two opposite ways: they guess and build the wrong thing, or they ask too much and stall. This skill sets the line. Check what the repository can answer, then ask one question only when the answer changes the work.

## Order of resolution

1. **Read the request for the most likely reading.** Name it in one sentence.
2. **Check the repository and the tools.** If a file, a test, a log, or a run answers the question, use that answer. Say what you checked.
3. **Check the decision log** (`skills/decision-memory`). The user may have decided this already.
4. **Ask only if the answer still changes the work.** Ask about a product or preference call, a shared-interface change, data, cost, or an external action.

## How to ask

- Ask one question per message.
- State the default you would use: "I will use X unless you say otherwise."
- Offer at most three options, and put the recommended one first with its reason.
- Say what happens in each case, so the user can choose without reading code.

Example: "The export should include deleted rows? I would exclude them, since the table has a `deleted_at` soft-delete column (`db/schema.sql:44`). Say include if you want them, and I will add a column flag."

## When not to ask

- The answer is a fact you can observe: a behaviour, a value, a config, a test result.
- The question is about style that the repository already sets. Follow the existing code.
- The user has said "decide" or "go ahead". Decide, record the decision, and report it.

## Rules

- Do not ask a question you have already answered in the repository. That wastes the user's time and shows the search was not done.
- Do not hide a question inside a status report. A question gets its own message so it is not missed.
- When you proceed on a default, say so in the final report, with the reason, so the user can redirect.
