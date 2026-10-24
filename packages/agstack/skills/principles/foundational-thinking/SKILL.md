---
name: principle-foundational-thinking
description: "Apply before writing control flow for a new feature, a state machine, or a function that branches on the same data in several places."
---

# Principle: Foundational Thinking

## Invariant
Before writing loops, conditionals, or algorithms, model the domain. The shape and constraints of your data determine the simplicity and correctness of your code.

## Application
1. **Make Illegal States Unrepresentable:**
   - Use discriminated unions, algebraic data types, or enums instead of boolean flags (`isPending`, `isFailed`, `isComplete`) that could contradict one another.
2. **Core Types First:**
   - Define domain interfaces, entity structs, and events before wiring persistence or UI layers.
3. **Decouple Data from IO:**
   - Separate pure state transitions from side-effect-laden IO operations (network, disk, clock).
