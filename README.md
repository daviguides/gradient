
# Gradient
<img src="design/logo.png" alt="Diagram" align="right" style="width: 300px"/>

> A proposal for a layered context architecture

**Gradient** defines architectural patterns for building layered context injection systems for Claude Code plugins, emphasizing smooth transitions from normative specifications through applied context to dynamic orchestration.

```
███▓▓▒▒░░░░  SPECS     (The WHAT - Normative)
  ███▓▓▒▒░░  CONTEXT   (The HOW - Applied)
     ██▓▓▒▒  PROMPTS   (The ACTION - Orchestration)
```

<br/>

## What is Gradient?

Gradient is an architectural framework for organizing Claude Code plugins and context injection systems. It emerged from patterns discovered while building projects like `ymd-spec`, `semantic-docstrings`, and `code-zen`.

### Core Concept

Instead of rigid, isolated layers, Gradient promotes **smooth transitions** between architectural layers:

- **SPECS/STANDARDS/RULES**: Normative definitions (the WHAT)
- **CONTEXT**: Applied knowledge (the HOW)
- **PROMPTS**: Dynamic orchestration (the ACTION)

Like a gradient, each layer dissolves into the next, creating a fluid, organic architecture.

---

## Why Gradient?

### Problems Solved

1. **Duplication**: Context files repeating spec content
2. **Verbosity**: Redundant explanations across layers
3. **Unclear boundaries**: When to use specs vs context vs prompts
4. **Maintenance burden**: Changes require updates in multiple places

### Gradient Solution

- **Zero duplication**: Each layer has unique, non-overlapping content
- **Clear responsibilities**: Each layer knows its role
- **Reference, don't repeat**: Use `@` references for specs
- **Thin orchestrators**: Prompts load context, don't duplicate it

---

## Architecture Overview

```
gradient/
├── gradient/spec/        # SPECS: Normative (The WHAT)
│   ├── architecture-spec.md
│   ├── anti-duplication-principles.md
│   └── layer-spec.md
│
├── context/              # CONTEXT: Applied (The HOW)
│   ├── examples.md
│   ├── implementation-guide.md
│   └── decision-guide.md
│
├── prompts/              # PROMPTS: Orchestration (The ACTION)
│   └── load-context.md   # Thin loader with @ references
│
├── commands/             # COMMANDS: Entry points (API)
│   └── *.md              # One-to-one with prompts
│
├── agents/               # AGENTS: Specialized contexts
│   └── *.md              # Spin-off processes
│
└── docs/                 # DOCS: Human documentation
    └── *.md              # Architecture guides, tutorials
```

---

## Key Principles

### 1. Layer Responsibilities

**SPECS (Normative)**:
- Complete format definitions
- Syntax rules
- Validation criteria
- The definitive source of truth

**CONTEXT (Applied)**:
- Working examples
- Implementation patterns
- Decision trees
- Practical guidance

**PROMPTS (Orchestration)**:
- Load specs and context via `@` references
- Meta-instructions for LLMs
- Zero content duplication

### 2. Anti-Duplication

- **Specs don't repeat context**
- **Context doesn't repeat specs**
- **Prompts reference, don't duplicate**
- **Single source of truth** for every concept

### 3. Smooth Transitions

Layers blend into each other:
- Specs → Context: From rules to application
- Context → Prompts: From patterns to action
- No rigid boundaries, intentional overlap

---

## Components

### Commands (API Layer)

Like REST routes, commands are thin entry points:

```markdown
<!-- commands/load-gradient-context.md -->
@./gradient/prompts/load-context.md
```

One-to-one mapping with prompts. Commands define the interface, prompts orchestrate the logic.

### Agents (Spin-off Processes)

Specialized contexts with separate permissions:

```markdown
<!-- agents/architecture-reviewer.md -->
You are an architecture reviewer for Gradient projects.

@./gradient/gradient/spec/architecture-spec.md
@./gradient/context/decision-guide.md
```

Run independently, return summarized results without contaminating main context.

### Hooks (Event-Driven)

Triggered by Claude Code lifecycle events (not yet explored in this project).

### Scripts (Efficiency Layer)

When code is more efficient than tokens:

```bash
# scripts/validate-structure.sh
# Validate Gradient architecture compliance
```

---

## Getting Started

### For Humans

**Documentation Site**: Visit the [complete documentation site](https://daviguides.github.io/gradient) (when published) with interactive examples and guides.

**Local development**: Run the Jekyll site locally:
```bash
cd docs
bundle exec jekyll serve
# Access at http://localhost:4000
```

**Quick reads**:
- [Quick Start](docs/_pages/quick-start.md) - Create your first Gradient project in 10 minutes
- [Why Gradient?](docs/_pages/why-gradient.md) - Problems solved and philosophy
- [Architecture Guide](docs/_pages/architecture-guide.md) - Complete guide with diagrams

### For LLMs

Load the architecture spec:

```markdown
@./gradient/gradient/spec/architecture-spec.md
@./gradient/gradient/spec/anti-duplication-principles.md
```

---

## Project Status

**Status**: In Development

This project is actively being developed as a distillation of patterns from:
- `ymd-spec`: YMD/PMD format specification
- `semantic-docstrings`: Semantic documentation standards
- `code-zen`: Zen of Python implementation guide

---

## Philosophy

> "Architecture isn't about rigid layers—it's about smooth, intentional transitions."

Gradient recognizes that effective context injection requires:
- Clear separation of concerns
- Fluid information flow
- Zero duplication
- Organic evolution

Like a gradient in design, our architecture dissolves boundaries while maintaining distinct identities.

---

## Documentation

### Jekyll Documentation Site

Complete documentation with interactive examples, Mermaid diagrams, and step-by-step guides:

- [Quick Start](docs/_pages/quick-start.md) - Get started in 10 minutes
- [Why Gradient?](docs/_pages/why-gradient.md) - Problems, solutions, and philosophy
- [Specifications](docs/_pages/specifications.md) - Technical layer specifications
- [Architecture Guide](docs/_pages/architecture-guide.md) - Complete guide with diagrams
- [Examples](docs/_pages/examples.md) - Real-world implementations
- [Tools](docs/_pages/tools.md) - Validation scripts and agents
- [Best Practices](docs/_pages/best-practices.md) - Guidelines and anti-patterns
- [Cheatsheet](docs/_pages/cheatsheet.md) - Quick reference
- [Migration Guide](docs/_pages/migration-guide.md) - Refactor existing projects

### Core Specifications (for LLMs)

- [Architecture Specification](gradient/spec/architecture-spec.md) - Complete normative definition
- [Anti-Duplication Principles](gradient/spec/anti-duplication-principles.md) - Universal principles
- [Layer Specification](gradient/spec/layer-spec.md) - Technical layer specs

### Applied Knowledge

- [Implementation Guide](context/implementation-guide.md) - Step-by-step implementation
- [Examples](context/examples.md) - Working examples
- [Decision Guide](context/decision-guide.md) - Decision trees

### Design

- [Naming Analysis](design/naming-analysis.md) - Why "Gradient"?

---

## License

MIT License - See LICENSE file for details

---

## Contributing

Contributions welcome! This project aims to establish patterns for Claude Code plugin architecture. Share your insights and patterns.

---

**Gradient** - From specs to action, smoothly.
