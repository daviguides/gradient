---
layout: page
title: Cheatsheet
nav_order: 9
permalink: /cheatsheet/
---

# Gradient Cheatsheet

Quick reference for Gradient architecture patterns, syntax, and quality targets.

---

## Layer Quick Reference

| Layer | Purpose | Contains | References | File Patterns | Size Limit |
|-------|---------|----------|------------|---------------|------------|
| **SPECS** | Normative (WHAT) | Definitions, rules, standards | None | `*-spec.md`, `*-principles.md` | N/A |
| **CONTEXT** | Applied (HOW) | Examples, guides, patterns | SPECS | `examples.md`, `*-guide.md` | <500 lines/file |
| **PROMPTS** | Orchestration (ACTION) | @refs + meta-instructions | SPECS, CONTEXT | `load-*.md`, `*-workflow.md` | <200 lines/file |
| **COMMANDS** | API entry | Description + 1 @ref | PROMPTS | `command-name.md` | ≤5 lines |
| **AGENTS** | Specialized | Role + @refs + task | SPECS, CONTEXT | `agent-name.md` | Variable |
| **SCRIPTS** | Automation | Bash/Python code | None | `*.sh`, `*.py` | N/A |
| **HOOKS** | Events | Trigger + @ref | PROMPTS | `event-name.md` | <50 lines |

---

## Quality Metrics Targets

### Project-Wide

| Metric | Target | Warning | Critical |
|--------|--------|---------|----------|
| **Duplication Ratio** | ≤1.1 | 1.2 | >1.3 |
| **Maintenance Points** | 1 per concept | N/A | N/A |
| **Broken References** | 0 | 1-2 | >2 |

### Layer-Specific

| Layer | Reference Density | Inline Content | Normative Ratio | Completeness |
|-------|-------------------|----------------|-----------------|--------------|
| **SPECS** | 0% | Unlimited | >80% | 100% |
| **CONTEXT** | >30% | <500 lines | N/A | 100% |
| **PROMPTS** | >50% | <5 lines/section | N/A | N/A |
| **COMMANDS** | 100% (1 ref) | 0 lines | N/A | N/A |

---

## Reference Syntax

### Relative References

```markdown
# From prompts/load-context.md

@../project/spec/format-spec.md       # Up one, into project/spec/
@../context/examples.md               # Up one, into context/
@./helper-prompt.md                   # Same directory
```

### Absolute References

```markdown
# From installed location

@~/.claude/gradient/gradient/spec/architecture-spec.md
@~/.claude/ymd-spec/ymd_format_spec.md
```

### Resolution Rules

1. Paths are relative to **current file location**
2. Use `../` to go up one directory level
3. Use `./` for same directory (optional, implicit)
4. Never use system-absolute paths (like `/Users/...`)

---

## Directory Structure Template

```
project-name/
├── project-name-spec/          # SPECS layer
│   ├── core-spec.md
│   ├── principles.md
│   └── standards.md
│
├── context/                    # CONTEXT layer
│   ├── examples.md
│   ├── implementation-guide.md
│   ├── decision-guide.md
│   └── patterns.md
│
├── prompts/                    # PROMPTS layer
│   ├── load-context.md
│   ├── create-workflow.md
│   └── validate-workflow.md
│
├── commands/                   # COMMANDS layer
│   ├── load-context.md
│   ├── create-item.md
│   └── validate-item.md
│
├── agents/                     # AGENTS layer
│   ├── specialist.md
│   └── reviewer.md
│
├── scripts/                    # SCRIPTS layer
│   ├── validate.sh
│   └── generate.sh
│
└── docs/                       # Documentation (for humans)
    └── README.md
```

---

## File Templates

### SPECS Template

```markdown
# {Concept} Specification

**Purpose**: Define complete {concept} structure and rules.

---

## Core Concepts

### {Concept Name}

**Definition**: {Normative definition}

{Concept} MUST/MUST NOT/SHALL:
- {Requirement 1}
- {Requirement 2}
- {Requirement 3}

### {Sub-Concept}

**Definition**: {Normative definition}

**Constraints**:
- {Constraint 1}
- {Constraint 2}

---

## Validation Rules

Valid {concept} if:
- {Validation criterion 1}
- {Validation criterion 2}
- {Validation criterion 3}

---

For examples: @../context/examples.md
For implementation: @../context/implementation-guide.md
```

### CONTEXT Template

```markdown
# {Concept} Examples

For specifications: @../project/spec/{concept}-spec.md

---

## Example 1: {Scenario}

**Purpose**: {What this example demonstrates}

```{language}
{Complete working example}
```

**Validates**: {Why this is valid according to spec}

---

## Example 2: {Scenario}

**Purpose**: {What this example demonstrates}

```{language}
{Complete working example}
```

**Validates**: {Why this is valid according to spec}

---

## Example 3: Invalid {Concept}

**Purpose**: {What this demonstrates - anti-pattern}

```{language}
{Example that violates spec}
```

**Fails validation**:
- {Violation 1}
- {Violation 2}
```

### PROMPTS Template

```markdown
# {Action} Prompt

**Purpose**: {Brief description of orchestration}

---

## Specifications (Normative)

@../project/spec/{spec1}.md
@../project/spec/{spec2}.md

---

## Applied Knowledge (Practical)

@../context/examples.md
@../context/{guide}.md

---

## Your Task

With specifications and examples loaded, you can now:
1. {Task step 1}
2. {Task step 2}
3. {Task step 3}

{Brief meta-instructions for LLM - keep <5 lines}
```

### COMMANDS Template

```markdown
{Brief one-line description of command}

@../prompts/{corresponding-prompt}.md
```

### AGENTS Template

```markdown
# {Agent Name}

You are {role description} specialized in {domain}.

---

## Context

@../project/spec/{spec}.md
@../context/{guide}.md

---

## Your Task

{Specific task description}

{What the agent should do}

---

## Return Format

Return {output type} containing:
- {Output element 1}
- {Output element 2}
- {Output element 3}
```

---

## Common Patterns

### Pattern 1: Simple Project

**When**: Basic plugin with straightforward rules

```
my-plugin/
├── my-plugin-spec/
│   └── core-spec.md
├── context/
│   └── examples.md
└── prompts/
    └── load-context.md
```

### Pattern 2: Multi-Spec Project

**When**: Complex plugin with multiple domains

```
my-plugin/
├── my-plugin-spec/
│   ├── format-spec.md
│   ├── validation-spec.md
│   └── api-spec.md
├── context/
│   ├── format-examples.md
│   ├── validation-examples.md
│   └── implementation-guide.md
└── prompts/
    ├── load-format.md
    ├── load-validation.md
    └── load-complete.md
```

### Pattern 3: With Agents

**When**: Need specialized review/validation

```
my-plugin/
├── my-plugin-spec/
│   └── core-spec.md
├── context/
│   └── examples.md
├── prompts/
│   └── load-context.md
└── agents/
    ├── validator.md
    └── reviewer.md
```

---

## Decision Trees

### Where Does Content Belong?

```
Content Type → Layer

Normative definition      → SPECS
Validation rule           → SPECS
Format specification      → SPECS
Standard/convention       → SPECS

Working example           → CONTEXT
Implementation guide      → CONTEXT
Decision guide            → CONTEXT
Pattern catalog           → CONTEXT
Best practices (applied)  → CONTEXT

Orchestration logic       → PROMPTS
Meta-instructions         → PROMPTS
Context loading           → PROMPTS
Workflow definition       → PROMPTS

API entry point           → COMMANDS
Command description       → COMMANDS

Specialized context       → AGENTS
Validation task           → AGENTS
Review task               → AGENTS

Automation script         → SCRIPTS
Validation logic          → SCRIPTS
Generation logic          → SCRIPTS

Lifecycle handler         → HOOKS
Event trigger             → HOOKS
```

### Should I Reference or Inline?

```
Content Length → Action

< 3 lines        → Inline acceptable
3-5 lines        → Consider extracting
> 5 lines        → Must extract + reference

Already exists  → Always reference
Normative       → Extract to SPECS
Example         → Extract to CONTEXT
```

### Should I Split This Spec?

```
Criteria → Decision

> 500 lines                        → Consider split
Multiple distinct domains          → Split
Multiple independent concepts      → Split
Team works on sections in parallel → Split

Tightly coupled concepts           → Keep together
< 300 lines                        → Keep together
Would create circular deps         → Keep together
```

---

## Validation Commands

### Quick Validation

```bash
# After editing files
bash ~/.claude/gradient/scripts/validate-references.sh .
```

### Full Validation

```bash
# Before committing
bash ~/.claude/gradient/scripts/validate-references.sh .
bash ~/.claude/gradient/scripts/detect-duplication.sh .
bash ~/.claude/gradient/scripts/calculate-metrics.sh .
```

### Complete Review

```bash
# Before releasing
bash ~/.claude/gradient/scripts/calculate-metrics.sh .

# Then in Claude Code:
# "Use architecture-reviewer agent to validate my project"
```

---

## Common Anti-Patterns

### Anti-Pattern: Quick Reference Files

```
✗ DON'T:
project/
├── spec.md
└── quickref.md  ← Duplication

✓ DO:
project/
├── spec.md
└── prompts/
    └── load.md  → @../spec.md
```

### Anti-Pattern: Mixed Layer Files

```
✗ DON'T:
spec.md:
  - Specs (normative)
  - Examples (context)    ← Mixed layers
  - Usage (prompts)

✓ DO:
project/spec/spec.md:     ← SPECS only
  - Normative definitions

context/examples.md:      ← CONTEXT only
  - Working examples

prompts/load.md:          ← PROMPTS only
  - Orchestration
```

### Anti-Pattern: Bloated Commands

```
✗ DON'T:
commands/create.md (50 lines):
  - Explanations
  - Logic           ← Business logic
  - Steps

✓ DO:
commands/create.md (3 lines):
  - Description
  - @reference      ← Delegate to prompt
```

### Anti-Pattern: Inline Duplication

```
✗ DON'T:
prompts/create.md:
  ## Rules
  Files must have...
  [50 lines of spec]    ← Duplicated

✓ DO:
prompts/create.md:
  ## Rules
  @../spec.md           ← Referenced
```

---

## Gradient Commands

### Installation

```bash
# One-line install
bash -c "$(curl -fsSL https://raw.githubusercontent.com/daviguides/gradient/main/install.sh)"

# Manual install
git clone https://github.com/daviguides/gradient.git
cd gradient
./install.sh
```

### Claude Code Usage

```
# Load Gradient context
/load-gradient-context

# Then ask:
"Create a Gradient project structure for {purpose}"
"Validate this file against Gradient specs"
"Where should this content live?"
"How do I eliminate duplication?"
```

---

## Key Metrics at a Glance

### Healthy Project

```
Duplication Ratio:     1.0-1.1  ✓
Reference Density:     >50%     ✓
Command Avg Size:      ≤5 lines ✓
Broken References:     0        ✓
```

### Warning Signs

```
Duplication Ratio:     1.2-1.3  ⚠
Reference Density:     30-50%   ⚠
Command Avg Size:      6-10 lines ⚠
Broken References:     1-2      ⚠
```

### Critical Issues

```
Duplication Ratio:     >1.3     ✗
Reference Density:     <30%     ✗
Command Avg Size:      >10 lines ✗
Broken References:     >2       ✗
```

---

## Bootstrap Sequence

```
1. Create directory structure
   └─→ mkdir -p {project-spec,context,prompts,commands}

2. Write SPECS first
   └─→ {project}-spec/core-spec.md

3. Add CONTEXT (references SPECS)
   └─→ context/examples.md → @../{project}-spec/core-spec.md

4. Create PROMPTS (references SPECS + CONTEXT)
   └─→ prompts/load-context.md → @../{project}-spec/*.md + @../context/*.md

5. Add COMMANDS (references PROMPTS)
   └─→ commands/load-context.md → @../prompts/load-context.md

6. Validate
   └─→ bash validate-references.sh . && bash calculate-metrics.sh .
```

---

## Quick Links

- **[Quick Start]({% link _pages/quick-start.md %})** - 10-minute tutorial
- **[Specifications]({% link _pages/specifications.md %})** - Complete technical specs
- **[Best Practices]({% link _pages/best-practices.md %})** - Detailed guidelines
- **[Tools]({% link _pages/tools.md %})** - Validation scripts
- **[Examples]({% link _pages/examples.md %})** - Real-world projects

---

**Print this page**: Use your browser's print function to create a physical quick reference.
