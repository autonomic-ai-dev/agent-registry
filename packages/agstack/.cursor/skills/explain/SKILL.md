---
name: explain
description: "Explain code, a change, a design, a decision, or a failure to a specific reader in layers, from the summary down to the mechanism and the evidence. Use when the user asks how something works, why a choice was made, what a diff does, or to teach a concept. Also use before handing work to a reader who did not write it."
---

# Explain

An explanation works when the reader can act on it. This skill sets the layers and the order, so an explanation starts with what the reader needs and goes down only as far as they need.

## Establish the reader

Before writing, decide who reads it and what they will do with it. A reviewer checks correctness. An owner decides whether to ship. A newcomer needs the concepts first. If the reader is unknown, write for a competent engineer who has not seen this code, and say so.

## Layers

Write the explanation in this order. Stop at the layer that answers the question.

1. **Summary (one to three sentences):** what it does and why it exists.
2. **Mechanism (a short numbered list):** the steps in order, using the names in the code. Each step names the file and symbol (`path:line` or `path::symbol`).
3. **Decisions:** the choices that shaped it, and the alternative each one beat. Link to the decision log (`skills/decision-memory`) when there is an entry.
4. **Evidence:** how it was checked, with the command and its result. This layer proves the explanation.
5. **Edges:** what it does not cover, known limits, and what would change the answer.

## Forms

- For a flow or state change, a small diagram (Mermaid) beats a paragraph.
- For a change, describe the before and after in one sentence each, then the diff's effect, not its lines.
- For a failure, give the symptom, the cause, the evidence that shows the cause, and the fix. Do not give the fix first unless the reader asked for it.
- For a concept, define the term where it is first used, and use one example from this codebase.

## Rules

- Use the names the code uses. A new name for an existing thing makes the reader search for two things.
- Every claim about the code cites a location. An explanation without citations can be wrong without anyone noticing.
- Do not explain what the code obviously does line by line. Explain what is not obvious: the reason, the invariant, the trap.
- Do not add a comment to the code to hold an explanation. Explanations go in the reply or the docs, not in the source (`no-comments`).
- Keep each layer short. Length is not depth.
