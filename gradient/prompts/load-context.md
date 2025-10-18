# Load Gradient Context

**Purpose**: Load complete Gradient architecture specifications and implementation knowledge.

---

## Architecture Specifications (Normative)

@./gradient/spec/architecture-spec.md
@./gradient/spec/anti-duplication-principles.md
@./gradient/spec/layer-spec.md

---

## Applied Knowledge (Practical)

@./gradient/context/examples.md
@./gradient/context/implementation-guide.md
@./gradient/context/decision-guide.md

---

## Your Task

You now have complete Gradient architecture context loaded:

**Specifications**:
- Complete architecture with 7 layers (SPECS, CONTEXT, PROMPTS, COMMANDS, AGENTS, SCRIPTS, HOOKS)
- Anti-duplication principles (SSOT philosophy)
- Technical specifications for each layer

**Context**:
- Working examples (simple plugin, multi-layer, migration, complete project)
- Step-by-step implementation guide (7 phases)
- Decision trees for architectural choices

With this context, you can:
- Guide users in implementing Gradient architecture
- Review projects for Gradient compliance
- Answer questions about layer responsibilities
- Help resolve duplication issues
- Advise on reference strategies
- Support migration from legacy structures

---

## Key Principles to Remember

**Single Source of Truth**:
- Each concept exists in exactly one authoritative location
- Reference via `@`, never duplicate

**Layer Responsibilities**:
- SPECS: Normative (THE WHAT) - definitions, rules, formats
- CONTEXT: Applied (THE HOW) - examples, guides, patterns
- PROMPTS: Orchestration (THE ACTION) - thin loaders with references

**Smooth Transitions**:
- Layers dissolve into each other like a gradient
- Not rigid boundaries, but intentional flow
- SPECS → CONTEXT → PROMPTS → EXECUTION

**Reference Density**:
- PROMPTS: >50% should be `@` references
- CONTEXT: >30% should reference SPECS
- COMMANDS: 100% reference (thin wrappers)

**Validation Targets**:
- Duplication ratio: ≤1.1 (target 1.0)
- PROMPTS inline content: <5 lines per section
- COMMANDS file size: ≤5 lines
- SPECS completeness: 100%

---

## Context Loaded

You now understand:
- Complete Gradient architecture and philosophy
- All 7 architectural layers and their responsibilities
- Anti-duplication principles and SSOT approach
- How to implement Gradient in new projects
- How to migrate existing projects to Gradient
- Decision-making guidance for all architectural choices
- Working examples from real projects (ymd-spec, semantic-docstrings, code-zen)
