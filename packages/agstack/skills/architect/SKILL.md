---
name: architect
description: "Design system architecture, domain models, and interfaces before implementing code. Grounds decisions in existing repository patterns, ADRs, and caller ergonomics. Evaluates interface depth and screens for over-engineering."
disable-model-invocation: true
---

# Architect: Pre-Implementation Design & Modeling

Before writing implementation logic that crosses module or function boundaries, ground the architecture in the existing codebase and establish clean, deep interfaces.

## The Architecture Lifecycle

### Phase 1: Ground in the Existing System
- **Study Existing Design Patterns:** Inspect the repository's existing modules, service layers, and patterns. If the codebase uses repository-service-controller, actor models, clean architecture, or functional pipelines, adhere to that established pattern. Never invent a foreign architecture just because it is familiar.
- **Trace Design Docs & ADRs:** Read `docs/`, `rfcs/`, `adr/`, and previous PR descriptions to understand architectural decisions and constraints.
- **Model the Domain First:** Define core types, data shapes, and state transitions before control flow. Make illegal states unrepresentable (`principle-foundational-thinking`).

### Phase 2: Interface Depth & Caller Ergonomics
- **Deep Interfaces, Shallow Complexity:** Design interfaces that hide maximum internal complexity behind a small, simple public API. Avoid scattering capability across dozens of micro-classes or pass-through proxy functions.
- **Boundary Discipline:** Enforce schema validation at edges (`principle-boundary-discipline`); keep internal domain types clean and pure.
- **Immutability First:** Models must be immutable (`principle-immutability-first`).

### Phase 3: Screen Against Red Flags
- Screen the design before writing code:
  - ❌ Speculative abstraction: interfaces with only one foreseeable implementation.
  - ❌ Leaky abstractions: internal implementation details leaking into public signatures.
  - ❌ Deep nesting: more than 3-4 levels of hierarchy.
  - ❌ Excessive signal threading: passing unnecessary context objects through layers that do not use them.

### Phase 4: Implementation Against the Contract
- Implement against the approved architectural sketch.
- Deviations during implementation are signals to re-evaluate the architecture, not friction to absorb silently.
