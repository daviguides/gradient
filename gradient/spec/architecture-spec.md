# Gradient Architecture Specification (For LLMs)

**Complete normative specification of the Gradient layered context architecture.**

---

## Purpose

This specification defines the **Gradient** architectural pattern for building Claude Code plugins with layered context injection systems that emphasize:
- **Smooth transitions** between abstraction layers
- **Zero duplication** across components
- **Clear responsibilities** per layer
- **Efficient token usage** through references

---

## Core Concept

### The Gradient Metaphor

Gradient represents **smooth transitions** rather than rigid boundaries:

```
████████░░░░░░░░  SPECS     (Normative - The WHAT)
    ████████░░░░  CONTEXT   (Applied - The HOW)
        ████████  PROMPTS   (Orchestration - The ACTION)
```

Each layer **dissolves into** the next:
- SPECS → CONTEXT: From rules to application
- CONTEXT → PROMPTS: From patterns to action
- PROMPTS → EXECUTION: From orchestration to runtime

### Not Isolated Layers

Gradient is **not**:
- Rigid separation with no overlap
- Mechanical layering (like OSI model)
- Arbitrary divisions

Gradient **is**:
- Organic flow of information
- Intentional transitions
- Fluid boundaries with clear responsibilities

---

## Architecture Layers

### Layer 1: SPECS (Normative)

**Purpose**: Authoritative source of truth

**Contains**:
- Format definitions
- Syntax rules
- Validation criteria
- Semantic specifications
- Standards and conventions

**Does NOT contain**:
- Working examples (→ CONTEXT)
- Implementation guides (→ CONTEXT)
- Orchestration logic (→ PROMPTS)
- Meta-instructions for LLMs (→ PROMPTS)

**File patterns**:
- `*-spec.md` - Format specifications
- `*-principles.md` - Foundational principles
- `*-rules.md` - Normative rules
- `*-standards.md` - Standards definitions

**Validation**:
- Must be complete (no "see elsewhere" for core concepts)
- Must be normative (defines WHAT, not HOW)
- No duplication with other SPECS
- Referenced by CONTEXT, never duplicates CONTEXT

### Layer 2: CONTEXT (Applied)

**Purpose**: Practical application of specs

**Contains**:
- Working examples
- Implementation patterns
- Decision trees
- Practical guides
- Best practices (applied, not stated)

**Does NOT contain**:
- Syntax definitions (→ SPECS)
- Format rules (→ SPECS)
- Normative statements (→ SPECS)
- Orchestration logic (→ PROMPTS)

**File patterns**:
- `examples.md` - Complete working examples
- `*-guide.md` - Implementation/decision guides
- `patterns.md` - Architectural patterns
- `faq.md` - Common questions with applied answers

**Validation**:
- Must reference SPECS for rules (use `@`)
- Must provide unique value (not just spec repetition)
- Examples must be complete and functional
- No duplication with SPECS or other CONTEXT files

### Layer 3: PROMPTS (Orchestration)

**Purpose**: Dynamic orchestration and LLM instructions

**Contains**:
- `@` references to SPECS and CONTEXT
- Meta-instructions for LLMs
- Orchestration logic
- Context loading sequences

**Does NOT contain**:
- Inline spec content (>5 lines)
- Inline examples
- Any duplicated material from SPECS or CONTEXT

**File patterns**:
- `load-*.md` - Context loaders
- `*-workflow.md` - Multi-step orchestrations
- `validate-*.md` - Validation prompts

**Validation**:
- Majority should be `@` references (>50% of lines)
- Minimal inline content (<5 lines per section)
- No duplication of SPECS or CONTEXT
- Clear meta-instructions for LLM tasks

### Layer 4: COMMANDS (API Entry Points)

**Purpose**: Thin API layer for user-facing commands

**Contains**:
- Single `@` reference to corresponding PROMPT
- Optional: Brief description (1-2 lines)

**Structure**:
```markdown
<!-- commands/command-name.md -->
Brief description of what this command does.

@~/.claude/gradient/prompts/prompt-name.md
```

**Validation**:
- One-to-one mapping with PROMPTS
- No business logic (→ PROMPTS)
- Maximum 5 lines total
- Must reference existing PROMPT

### Layer 5: AGENTS (Specialized Contexts)

**Purpose**: Spin-off processes with isolated contexts

**Contains**:
- Role definition (1-3 lines)
- `@` references to SPECS/CONTEXT needed
- Specialized instructions
- Return format specification

**Structure**:
```markdown
<!-- agents/agent-name.md -->
You are a [role] specialized in [domain].

## Context

@~/.claude/gradient/spec/relevant-spec.md
@~/.claude/gradient/context/relevant-guide.md

## Your Task

[Specific instructions]

## Return Format

[What to return to main context]
```

**Command Delegation Pattern** (Acceptable Alternative):

When multiple agents/guides need identical context, command delegation maintains DRY:

```markdown
<!-- agents/agent-name.md -->
You are a [role] specialized in [domain].

## Context

Antes de qualquer passo:
- Execute o command /project:load-context  # Delegates to load workflow

## Your Task

[Specific instructions]
```

This creates one level of indirection but preserves Single Source of Truth for reference lists. Recommended when **3+ files** need identical context.

**Validation**:
- Clear role definition
- References needed specs/context
- Specifies return format
- No duplication of referenced content

### Layer 6: SCRIPTS (Efficiency Layer)

**Purpose**: Code execution when more efficient than LLM tokens

**Contains**:
- Shell scripts
- Python utilities
- Validation tools
- Automation scripts

**When to use**:
- Repetitive tasks
- File system operations
- Validation logic
- Performance-critical operations

**Structure**:
```bash
#!/bin/bash
# Script: script-name.sh
# Purpose: [one-line description]
# Usage: script-name.sh [args]
```

**Validation**:
- Well-documented
- Single responsibility
- Handles errors
- Callable from PROMPTS if needed

### Layer 7: HOOKS (Event-Driven)

**Purpose**: Lifecycle event handlers

**Contains**:
- Event-triggered workflows
- Automated responses
- Validation on events

**Events**:
- Pre-command execution
- Post-command execution
- File changes
- Context switches

**Structure**:
```markdown
<!-- hooks/event-name.md -->
Triggered on: [event]

@~/.claude/gradient/prompts/workflow.md
```

**Validation**:
- Clear trigger event
- Lightweight (avoid heavy processing)
- References PROMPTS for logic

---

## Composition Rules

### Reference Syntax

Use `@` for referencing:

**Absolute references** (from installed location):
```markdown
@~/.claude/gradient/spec/architecture-spec.md
```

**Relative references** (within project):
```markdown
@~/.claude/gradient/spec/architecture-spec.md
@./examples.md
```

### Reference Resolution

**Rules**:
1. Paths are relative to current file
2. Use `../` to go up directories
3. Use `./` for same directory
4. Never use system-absolute paths (`/absolute/path`)

**Example**:
```
gradient/prompts/load-context.md references:
@~/.claude/gradient/spec/architecture-spec.md

Resolution:
/path/to/project/gradient/prompts/ + ../spec/architecture-spec.md
= /path/to/project/gradient/spec/architecture-spec.md
```

### Composition Patterns

**Pattern 1: Thin Loader**
```markdown
<!-- prompts/load-context.md -->
@~/.claude/gradient/spec/spec1.md
@~/.claude/gradient/spec/spec2.md
@~/.claude/gradient/context/examples.md

Your task: [brief meta-instruction]
```

**Pattern 2: Conditional Loading**
```markdown
<!-- prompts/adaptive-load.md -->
{% if need_specs %}
@~/.claude/gradient/spec/detailed-spec.md
{% else %}
@~/.claude/gradient/context/quick-guide.md
{% endif %}
```

**Pattern 3: Layered Loading**
```markdown
<!-- prompts/comprehensive-load.md -->
## Specifications (Normative)
@~/.claude/gradient/spec/spec.md

## Applied Knowledge (Practical)
@~/.claude/gradient/context/guide.md

## Meta-Instructions
[orchestration logic]
```

**Pattern 4: Delegated Loading** (Recommended)
```markdown
<!-- agents/agent-name.md -->
You are a specialist in [domain].

## Context Loading

Antes de qualquer passo faça:
- Execute o command /project:load-context

---

## Your Task
[Agent-specific instructions without any @ references]
```

**Why delegated loading**:
- Eliminates duplication (agents don't list refs)
- Single source of truth (only load workflows have refs)
- Easier maintenance (update load once, affects all agents)
- Cleaner agent files (focus on behavior, not context)

### Load Workflow Patterns

**Purpose**: Load workflows are specialized prompts that serve as Single Source of Truth for context loading.

**Reference Style**:
```markdown
<!-- gradient/prompts/load-context.md -->
# Load Project Context

## Specifications

@~/.claude/project-name/spec/spec1.md
@~/.claude/project-name/spec/spec2.md

## Context

@~/.claude/project-name/context/guide.md
@~/.claude/project-name/context/examples.md
```

**Key Rules**:
- Load workflows MUST use absolute references (`@~/.claude/project/...`)
- Never use relative references in load workflows
- Load workflows are the ONLY place where specs/context are referenced
- Other files (agents, prompts) MUST delegate to load workflows

**Delegation Pattern**:
```markdown
<!-- agents/specialized-agent.md -->
## Context Loading

Antes de qualquer passo faça:
- Execute o command /project:load-context

---
```

**Modular Loads** (when applicable):
```markdown
<!-- For projects with multiple independent contexts -->
/project:load-universal-context  → Universal principles only
/project:load-specific-context   → Domain-specific only
/project:load-complete-context   → Specialized content only
```

**Anti-Duplication in Loads**:
- Each load MUST have independent scope
- NO file should be referenced in multiple loads
- Loads compose via multiple command execution, not via duplication

**Example: Code Zen**:
```markdown
# Modular loads (no duplication)
/code-zen:load-universal-context → naming, structure, error-handling
/code-zen:load-zen-context       → zen principles, patterns
/code-zen:load-python-context    → python specs, libraries, tdd

# Agent uses composition
Antes de qualquer passo faça:
- Execute o command /code-zen:load-universal-context
- Execute o command /code-zen:load-zen-context
- Execute o command /code-zen:load-python-context
```

---

## Validation Rules

### Duplication Check

**MUST NOT duplicate**:
- Syntax definitions (SPECS only)
- Format rules (SPECS only)
- Complete examples (CONTEXT only)
- Orchestration logic (PROMPTS only)

**Check process**:
1. For each file, identify core concepts
2. Search project for duplicate explanations
3. If found, determine SSOT
4. Replace duplicates with `@` references

### Layer Boundaries

**SPECS files must**:
- Be normative (not practical)
- Define WHAT, not HOW
- Be complete (no external dependencies for core concepts)
- Not contain working code examples

**CONTEXT files must**:
- Reference SPECS for rules (via `@`)
- Provide unique applied value
- Use working, complete examples
- Not redefine syntax or formats

**PROMPTS files must**:
- Primarily use `@` references OR command delegations (>50% of content)
  - Command delegations (e.g., "Execute o command /load-context") count as references
  - Both patterns maintain thin orchestrator principle
- Contain <5 lines of inline content per section
- Not duplicate SPECS or CONTEXT
- Focus on orchestration

### Reference Integrity

**All references must**:
- Resolve to existing files
- Be relative to current file
- Not create circular dependencies
- Point to appropriate layer (SPECS → CONTEXT → PROMPTS)

**Validation**:
```bash
# Check all @ references resolve
grep -r "@" --include="*.md" | validate-references.sh
```

---

## Anti-Patterns

### Anti-Pattern 1: Verbose Prompts

**Problem**:
```markdown
<!-- prompts/load.md -->
# YMD Format
YMD files have metadata...
(100 lines of spec content)

# PMD Format
PMD files are pure markdown...
(80 lines of spec content)
```

**Solution**:
```markdown
<!-- prompts/load.md -->
@~/.claude/gradient/spec/ymd-spec.md
@~/.claude/gradient/spec/pmd-spec.md

Your task: [meta-instruction]
```

### Anti-Pattern 2: Quick Reference Files

**Problem**:
```markdown
<!-- context/quick-ref.md -->
Abbreviated version of specs
(Still 200 lines of duplication)
```

**Reason for removal**:
- LLMs process full specs equally fast
- Creates duplication
- Maintenance burden

**Solution**:
Eliminate quick reference files entirely.

### Anti-Pattern 3: Spec in Context

**Problem**:
```markdown
<!-- context/guide.md -->
## YMD Format Rules
YMD files must have meta section with:
- id: unique identifier
- kind: type
...
(redefines spec content)
```

**Solution**:
```markdown
<!-- context/guide.md -->
For YMD format rules:
@~/.claude/gradient/spec/ymd-spec.md

Example YMD file:
```yaml
meta:
  id: example
  ...
```
```

### Anti-Pattern 4: Orchestration in Specs

**Problem**:
```markdown
<!-- project/spec/format-spec.md -->
Now that you understand the format, you can:
1. Create new files
2. Validate existing files
...
(orchestration logic in spec)
```

**Solution**:
```markdown
<!-- project/spec/format-spec.md -->
[Pure specification, no orchestration]

<!-- prompts/format-workflow.md -->
@~/.claude/gradient/project/spec/format-spec.md

Now that specifications are loaded, you can:
1. Create new files
2. Validate existing files
...
```

---

## Project Structure

### Recommended Layout

```
project/
├── spec/                  # SPECS (normative)
│   ├── format-spec.md
│   ├── principles.md
│   └── standards.md
│
├── context/               # CONTEXT (applied)
│   ├── examples.md
│   ├── implementation-guide.md
│   └── decision-guide.md
│
├── prompts/               # PROMPTS (orchestration)
│   ├── load-context.md
│   └── workflow.md
│
├── commands/              # COMMANDS (API)
│   └── command-name.md
│
├── agents/                # AGENTS (specialized)
│   └── agent-name.md
│
├── scripts/               # SCRIPTS (efficiency)
│   └── utility.sh
│
└── hooks/                 # HOOKS (events)
    └── event.md
```

### Bundle Naming Convention

**Rule**: The bundle directory MUST be named exactly as the project name.

**Rationale**:
- Ensures consistency between repository structure and installed structure
- Prevents reference path mismatches
- Simplifies installation and usage

**Structure**:
```
project-name/                    # Repository root
├── commands/                    # Outside bundle
├── agents/                      # Outside bundle
└── project-name/                # Bundle (MUST match project!)
    ├── spec/
    ├── context/
    ├── prompts/
    ├── scripts/ (optional)
    └── hooks/ (optional)
```

**Reference Patterns**:

**From commands/** (external to bundle):
```markdown
@~/.claude/project-name/prompts/workflow.md
```

**From agents/** (external to bundle):
```markdown
@~/.claude/project-name/spec/spec-file.md
```

**From prompts/** (internal to bundle):
```markdown
@~/.claude/gradient/spec/spec-file.md
@~/.claude/gradient/context/guide.md
```

**Installation**:
```bash
# Install preserves bundle name
cp -r project-name/ ~/.claude/project-name/

# References continue to work
# Commands: @~/.claude/project-name/prompts/...
# Prompts: @~/.claude/gradient/spec/... (internal)
```

**Validation**:
- Bundle directory name MUST equal project/repository name
- All external references (commands/, agents/) MUST use correct bundle name
- Install script TARGET_DIR MUST match bundle name
- No mixed naming (some refs using old name, others using new name)

**Anti-Pattern**:
```markdown
❌ BAD:
Repository: my-awesome-plugin/
Bundle: my-awesome-plugin/old-name/
Commands reference: @~/.claude/different-name/
Install target: ~/.claude/yet-another-name/

✅ GOOD:
Repository: my-awesome-plugin/
Bundle: my-awesome-plugin/my-awesome-plugin/
Commands reference: @~/.claude/my-awesome-plugin/
Install target: ~/.claude/my-awesome-plugin/
```

---

### Reference Path Strategy (Source vs Installed)

**Purpose**: Define reference patterns for development (source) and production (installed).

**Rule**: Use relative paths in source code, transform to absolute paths during installation.

**Rationale**:
- Enables local testing during development (references point to local files)
- Maintains compatibility with global installation (references point to ~/.claude/)
- Separates concerns: source code vs built/installed artifacts
- Follows standard build/deploy patterns from software engineering

---

#### Development Phase (Source Code)

**All references use relative paths** starting with `@./bundle-name/`:

```markdown
# In source repository commands/load-context.md
@./code-zen/prompts/load-zen-workflow.md

# In source repository code-zen/prompts/load-zen-workflow.md
@./code-zen/spec/principles/zen-principles-spec.md
@./code-zen/context/guides/zen-implementation-guide.md
```

**Benefits**:
- Claude loads files from local repository during development
- Changes can be tested immediately without reinstalling
- No need to maintain separate dev/prod files
- Git tracks source files with relative references

---

#### Production Phase (Installed)

**All references use absolute paths** starting with `@~/.claude/bundle-name/`:

```markdown
# In installed ~/.claude/commands/load-context.md
@~/.claude/code-zen/prompts/load-zen-workflow.md

# In installed ~/.claude/code-zen/prompts/load-zen-workflow.md
@~/.claude/code-zen/spec/principles/zen-principles-spec.md
@~/.claude/code-zen/context/guides/zen-implementation-guide.md
```

**Benefits**:
- References work correctly in global installation
- Multiple projects can reference same installed bundle
- Standard location for all Claude Code plugins

---

#### Development Toggle (Makefile)

**Implementation**: Use Makefile to toggle between dev/prod modes.

**Makefile Pattern**:
```makefile
.PHONY: dev prod status

BUNDLE_NAME := my-bundle

dev:
	@find . -name "*.md" -exec sed -i.bak 's|@~/\.claude/$(BUNDLE_NAME)/|@./$(BUNDLE_NAME)/|g' {} \;
	@find . -name "*.md.bak" -delete

prod:
	@find . -name "*.md" -exec sed -i.bak 's|@\./$(BUNDLE_NAME)/|@~/.claude/$(BUNDLE_NAME)/|g' {} \;
	@find . -name "*.md.bak" -delete

status:
	@if grep -r "@\./$(BUNDLE_NAME)/" . --include="*.md"; then echo "DEV"; else echo "PROD"; fi
```

**Development Workflow**:
```bash
# Switch to dev mode for local testing
make dev          # @~/.claude/bundle → @./bundle

# Test changes locally
# ...

# Switch back to prod before commit
make prod         # @./bundle → @~/.claude/bundle
git add .
git commit
```

---

#### Validation

**Repository State**:
- [ ] All references use `@~/.claude/bundle-name/...` pattern (production-ready)
- [ ] No `@./` references in committed code
- [ ] Makefile exists with dev/prod targets

**Development Workflow**:
- [ ] `make dev` converts to relative references
- [ ] Local testing works with relative refs
- [ ] `make prod` reverts to absolute references
- [ ] `make status` shows current state

**Testing**:
```bash
# Verify production state (before dev)
make status  # Should show "PRODUCTION mode"
grep -r "@\./bundle-name/" .  # Should be empty

# Test dev mode
make dev
make status  # Should show "DEVELOPMENT mode"

# Test prod mode
make prod
make status  # Should show "PRODUCTION mode"
```

---

#### Anti-Patterns

**❌ BAD: Mixed references in repository**:
```markdown
# Some files use relative
@./code-zen/spec/file.md

# Other files use absolute
@~/.claude/code-zen/spec/file.md
# Inconsistent state!
```

**❌ BAD: Committing dev mode**:
```bash
make dev
# Edit files...
git commit  # Forgot to run make prod!
# Now repo has relative refs - won't work for others!
```

**❌ BAD: Manual dual maintenance**:
```
dev-branch/commands/file.md    # Uses @./
prod-branch/commands/file.md   # Uses @~/.claude/
# Duplication! Maintenance nightmare!
```

**✅ GOOD: Makefile toggle workflow**:
```
# Repository always in prod mode (default)
main branch: @~/.claude/bundle-name/

# Developer workflow:
make dev     # Temporarily convert for local testing
# ... test locally ...
make prod    # Convert back before commit
git commit   # Repository stays production-ready
```

---

### Naming Conventions

**SPECS**:
- `*-spec.md` - Format specifications
- `*-principles.md` - Foundational principles
- `*-standards.md` - Standards

**CONTEXT**:
- `examples.md` - Working examples
- `*-guide.md` - Implementation guides
- `patterns.md` - Design patterns

**PROMPTS**:
- `load-*.md` - Context loaders
- `*-workflow.md` - Multi-step processes
- `validate-*.md` - Validation

**COMMANDS**:
- `command-name.md` - Matches prompt name

**AGENTS**:
- `*-agent.md` or `agent-name.md`

---

## Implementation Guidelines

### For LLMs Creating Gradient Projects

**Step 1: Determine layer**
```
Is this normative definition?     → SPECS
Is this practical application?    → CONTEXT
Is this orchestration?            → PROMPTS
Is this API entry?                → COMMANDS
Is this specialized context?      → AGENTS
Is this automation?               → SCRIPTS
```

**Step 2: Check for duplication**
```
grep -r "concept" --include="*.md"
→ If exists: reference it
→ If not: create in appropriate layer
```

**Step 3: Create with proper structure**
```
SPECS:    Complete, normative, no HOW
CONTEXT:  Examples, applied, references SPECS
PROMPTS:  @ references, meta-instructions
```

**Step 4: Validate**
```
- No duplication?
- Proper layer?
- References resolve?
- Single responsibility?
```

### For Humans Implementing Gradient

See: `@~/.claude/gradient/context/implementation-guide.md`

---

## Validation Checklist

### Project-Wide

- [ ] Zero duplication (each concept in one place)
- [ ] All `@` references resolve
- [ ] Clear SSOT for every concept
- [ ] Layers respect boundaries
- [ ] No circular dependencies

### Per File

**SPECS**:
- [ ] Normative content only
- [ ] Complete definitions
- [ ] No working examples
- [ ] No orchestration

**CONTEXT**:
- [ ] References SPECS for rules
- [ ] Unique applied value
- [ ] Complete working examples
- [ ] No spec redefinition

**PROMPTS**:
- [ ] Majority `@` references
- [ ] <5 lines inline content per section
- [ ] Meta-instructions clear
- [ ] No content duplication

**COMMANDS**:
- [ ] Single `@` reference to PROMPT
- [ ] <5 lines total
- [ ] No business logic

**AGENTS**:
- [ ] Clear role
- [ ] References needed specs/context
- [ ] Specifies return format

---

## Evolution and Maintenance

### When Specs Change

1. Update SSOT (spec file)
2. References automatically reflect change
3. No updates needed in referencing files
4. Validate references still resolve

### When Adding Features

1. Determine appropriate layer
2. Check for existing similar content
3. Create in correct layer
4. Reference from other layers if needed

### When Refactoring

1. Identify duplications
2. Determine SSOT
3. Consolidate content
4. Replace with `@` references
5. Validate all references

---

## Related Specifications

**For detailed anti-duplication rules**:
- `@./anti-duplication-principles.md`

**For layer-specific details**:
- `@./layer-spec.md`

**For implementation guidance** (applied, not normative):
- `@~/.claude/gradient/context/implementation-guide.md`

---

## Summary

Gradient architecture provides:
- **Clear separation**: Each layer has distinct responsibility
- **Smooth transitions**: Information flows naturally between layers
- **Zero duplication**: SSOT principle strictly enforced
- **Efficient tokens**: References minimize redundancy
- **Maintainable**: Changes propagate automatically

**Key principle**: Architecture as a gradient—smooth, intentional transitions from normative specs through applied context to dynamic orchestration.
