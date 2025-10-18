# Gradient - Claude Code Project Instructions

## Project Overview

**Gradient** is an architectural framework specification for building layered context injection systems for Claude Code plugins.

**Tagline**: "A proposal for a layered context architecture"

**Core Concept**: Smooth transitions between architectural layers (SPECS → CONTEXT → PROMPTS), not rigid boundaries.

---

## Project Purpose

This project defines:
1. **Architectural patterns** for Claude Code plugins
2. **Anti-duplication principles** for context organization
3. **Layer responsibilities** and boundaries
4. **Implementation guidelines** for plugin authors

---

## Repository Structure

### Core Architecture

**gradient/spec/** - Normative Specifications (SOURCE OF TRUTH)
- `architecture-spec.md` - Complete architecture specification for LLMs
- `anti-duplication-principles.md` - Universal principles preventing duplication
- `layer-spec.md` - Detailed specification of each architectural layer

**context/** - Applied Knowledge
- `examples.md` - Complete working examples of Gradient architecture
- `implementation-guide.md` - Step-by-step implementation guide
- `decision-guide.md` - Decision trees for architectural choices

**prompts/** - Orchestrators (Thin Loaders)
- `load-context.md` - Main context loader (references specs via `@`)

**commands/** - Entry Points (API Layer)
- `*.md` - Command files that reference prompts (one-to-one mapping)

**agents/** - Specialized Agents
- `*.md` - Spin-off processes with separate contexts

**docs/** - Human Documentation
- `architecture-guide.md` - Complete guide with Mermaid diagrams
- `getting-started.md` - Quick start guide
- `index.md` - Documentation homepage

**design/** - Design Artifacts
- `naming-analysis.md` - Rationale for "Gradient" name

---

## Key Architectural Principles

### 1. Layer Responsibilities

**SPECS (The WHAT - Normative)**:
- Definitive source of truth
- Complete format definitions
- Syntax rules and validation
- NO examples, NO how-to guides

**CONTEXT (The HOW - Applied)**:
- Working examples
- Implementation patterns
- Decision guidance
- NO spec duplication, NO syntax definitions

**PROMPTS (The ACTION - Orchestration)**:
- Load specs/context via `@` references
- Meta-instructions for LLMs
- ZERO content duplication
- Thin orchestrators only

### 2. Anti-Duplication

**Critical rule**: Each piece of information exists in exactly ONE place.

- Specs don't repeat context
- Context doesn't repeat specs
- Prompts reference, never duplicate
- If in doubt, reference it

### 3. Smooth Transitions

Layers blend organically:
```
████████░░░░░░░░  SPECS     (Rigid, normative)
    ████████░░░░  CONTEXT   (Flexible, applied)
        ████████  PROMPTS   (Dynamic, orchestrated)
```

Not discrete steps, but gradient transitions.

---

## Development Workflow

### When Adding New Content

**Ask first**: Which layer owns this information?

1. **Is it a normative rule/definition?** → `gradient/spec/`
2. **Is it practical application/example?** → `context/`
3. **Is it orchestration logic?** → `prompts/` (use `@` references)

### When Editing Existing Content

1. Check if content exists in multiple places (violation!)
2. If duplicated, identify the single source of truth
3. Replace duplicates with `@` references
4. Update any prompts/commands that need the content

### Commands

Commands are **thin API entry points**:

```markdown
<!-- commands/review-architecture.md -->
@./gradient/prompts/architecture-review.md
```

One command = one prompt. Commands define interface, prompts orchestrate logic.

### Agents

Agents are **specialized spin-off contexts**:

- Run independently from main context
- Have separate permissions
- Return summarized results
- Don't contaminate main context with irrelevant details

---

## Git Workflow

### Current Branch
`main`

### Commit Messages
Use descriptive, semantic messages:
- `feat: add anti-duplication principles spec`
- `docs: add Mermaid diagrams to architecture guide`
- `refactor: eliminate duplication in context files`
- `fix: correct path references in prompts`

### Branch Strategy
- `main` - stable releases
- Feature branches for new patterns/specs

---

## Related Projects

**Gradient** distills patterns from:

1. **ymd-spec** (`~/work/sources/my/genai/ymd-spec`)
   - YMD/PMD format specification
   - First implementation of layered architecture
   - Source of context organization patterns

2. **semantic-docstrings** (`~/work/sources/my/genai/semantic-docstrings`)
   - Semantic documentation standards plugin
   - Demonstrated SPECS → CONTEXT separation

3. **code-zen** (`~/work/sources/my/genai/code-zen`)
   - Zen of Python implementation guide
   - Showed RULES → APPLIED pattern

---

## File Organization Best Practices

### Naming Conventions

**Specs**: `noun-spec.md` or `noun-principles.md`
- `architecture-spec.md`
- `anti-duplication-principles.md`

**Context**: `noun-guide.md` or `examples.md`
- `implementation-guide.md`
- `decision-guide.md`

**Prompts**: `verb-context.md` or `action.md`
- `load-context.md`
- `validate-architecture.md`

### File Size Guidelines

- **Specs**: Can be large (500+ lines) - comprehensive source of truth
- **Context**: Medium (200-500 lines) - focused guidance
- **Prompts**: Small (<200 lines) - thin orchestrators

### Cross-References

Always use `@` syntax for referencing:
```markdown
@./gradient/gradient/spec/architecture-spec.md
@./gradient/context/examples.md
```

---

## Documentation Standards

### For Humans (docs/)

- Use Mermaid diagrams for architecture
- Include visual examples
- Explain the "why" behind decisions
- Provide step-by-step guides

### For LLMs (gradient/spec/)

- Be normative and complete
- Use precise language
- Include validation rules
- No fluff, pure specification

### For Both (context/)

- Working code examples
- Real-world patterns
- Decision trees
- Practical guidance

---

## Testing and Validation

### Architecture Compliance

When reviewing changes, check:
- [ ] No duplication between layers
- [ ] Each layer respects its boundaries
- [ ] Prompts use `@` references only
- [ ] Specs are normative, context is applied
- [ ] All cross-references resolve

### Content Quality

- [ ] Specs are complete and unambiguous
- [ ] Context provides real value (not spec repetition)
- [ ] Examples actually work
- [ ] Guides are actionable

---

## Current Status

**Status**: In Active Development

**Phase 1 Completed (Specs)**:
- Project structure established
- Naming decision documented (design/naming-analysis.md)
- README.md created
- CLAUDE.md created
- gradient/spec/anti-duplication-principles.md
- gradient/spec/architecture-spec.md
- gradient/spec/layer-spec.md

**Phase 2 Completed (Documentation)**:
- docs/architecture-guide.md (comprehensive guide with Mermaid diagrams)
- context/examples.md (working examples from simple to complex)
- context/implementation-guide.md (step-by-step 7-phase guide)
- context/decision-guide.md (decision trees for all architectural choices)

**Phase 3 Completed (Tooling)**:
- prompts/load-context.md (thin orchestrator loading all context)
- commands/load-gradient-context.md (API entry point)
- agents/architecture-reviewer.md (compliance validation agent)
- scripts/validate-references.sh (reference integrity validation)
- scripts/detect-duplication.sh (duplication detection)
- scripts/calculate-metrics.sh (quality metrics calculation)

---

## Important Notes

### This is a META Project

Gradient is **about** architecture, not a specific tool. It defines patterns that other projects follow.

### Living Documentation

This specification evolves as we discover new patterns from real-world plugin development.

### Community Input Welcome

Share insights from your Claude Code plugin development experiences.

---

## Quick Reference

**Load Gradient Context**:
```markdown
@./gradient/gradient/spec/architecture-spec.md
@./gradient/context/implementation-guide.md
```

**Validate Architecture**:
Use `architecture-reviewer` agent or validate manually against specs.

**Create New Plugin**:
Follow patterns in `context/implementation-guide.md`

---

## Philosophy

> "Architecture isn't about rigid layers—it's about smooth, intentional transitions."

Code like a gradient: from normative specs through applied context to dynamic action, smoothly.

---

**Gradient** - Smooth transitions from specs to action.
