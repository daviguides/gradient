# Layer Specification (For LLMs)

**Technical specification of each Gradient architecture layer.**

---

## Purpose

This specification provides detailed technical requirements for each layer in the Gradient architecture:
- Expected file structure
- Required sections
- Content validation rules
- Quality metrics
- Examples of valid structures

---

## SPECS Layer

### Purpose
Normative source of truth for format definitions, rules, and standards.

### File Structure

```markdown
# [Spec Name] Specification

**Purpose**: [One-line purpose]

---

## [Core Concept 1]

[Complete normative definition]

### [Subconcept]

[Detailed specification]

## [Core Concept 2]

[Complete normative definition]

---

## Validation Rules

[How to validate against this spec]

---

## Related Specifications

@./related-spec.md
```

### Required Sections

**Mandatory**:
- Title (# header)
- Purpose statement
- At least one core concept section
- Validation rules section

**Optional**:
- Related specifications
- Examples (minimal, illustrative only)
- Definitions
- Terminology

### Content Rules

**MUST contain**:
- Complete definitions
- Normative statements (SHALL, MUST, SHOULD)
- Syntax rules
- Format specifications
- Validation criteria

**MUST NOT contain**:
- Working code examples (>10 lines)
- Implementation guides
- "How to" instructions
- Orchestration logic
- Meta-instructions for LLMs

### Validation Criteria

**Completeness**:
- [ ] Every core concept fully defined
- [ ] No "see elsewhere" for essential concepts
- [ ] All syntax rules specified
- [ ] Validation criteria provided

**Normative Language**:
- [ ] Uses SHALL/MUST/SHOULD appropriately
- [ ] Statements are definitive
- [ ] No ambiguous wording
- [ ] Clear, unambiguous definitions

**Independence**:
- [ ] Can be understood standalone
- [ ] References external specs only for non-core concepts
- [ ] No dependency on CONTEXT for understanding

### Quality Metrics

**Target**:
- Completeness: 100% (all concepts defined)
- Clarity: High (no ambiguous statements)
- Independence: High (minimal external dependencies)
- Normative ratio: >80% (normative vs descriptive text)

### Example

```markdown
# Format Specification

**Purpose**: Define the complete structure and syntax of XYZ format.

---

## File Structure

XYZ files MUST contain:
1. Metadata section (required)
2. Content section (required)
3. Footer section (optional)

### Metadata Section

The metadata section MUST include:
- `id`: Unique identifier (snake_case)
- `version`: Semantic version (MAJOR.MINOR.PATCH)
- `title`: Human-readable title

Example:
```yaml
meta:
  id: example
  version: 1.0.0
  title: Example
```

## Validation Rules

Valid XYZ file if:
- Contains all required sections
- Metadata fields present and valid
- Syntax follows specification

---

## Related Specifications

@./syntax-spec.md
```

---

## CONTEXT Layer

### Purpose
Applied knowledge, working examples, and practical implementation guidance.

### File Structure

#### For Examples

```markdown
# [Topic] Examples

[Brief introduction]

---

## Example 1: [Name]

**Purpose**: [What this demonstrates]

### Complete Implementation

```[language]
[working code]
```

### Explanation

[How it works, key points]

---

## Example 2: [Name]

...
```

#### For Guides

```markdown
# [Topic] Guide

**For format rules**: @../[project]-spec/format-spec.md

---

## [Section 1]

[Practical guidance]

### [Subsection]

[Applied knowledge]

---

## Related Guides

- @./other-guide.md
- @./related-guide.md
```

### Required Sections

**For examples.md**:
- Introduction
- At least 3 complete examples
- Explanation per example

**For guides**:
- Reference to relevant SPECS (first section)
- At least 3 practical sections
- Related guides section

### Content Rules

**MUST contain**:
- Complete working examples
- Practical application guidance
- Decision trees (for decision-guide.md)
- Real-world patterns

**MUST reference SPECS for**:
- Syntax rules
- Format definitions
- Validation criteria
- Normative statements

**MUST NOT contain**:
- Syntax redefinition
- Format specification
- Normative statements (use SPECS)
- Orchestration logic

### Validation Criteria

**Unique Value**:
- [ ] Examples are complete and functional
- [ ] Guidance provides practical value
- [ ] Not just restating specs
- [ ] Answers "how to apply" questions

**Proper References**:
- [ ] References SPECS for rules (via @)
- [ ] No syntax redefinition
- [ ] No format respecification
- [ ] Links to specs are valid

**Completeness**:
- [ ] Examples are runnable/usable
- [ ] Guides cover common scenarios
- [ ] Decision trees have clear outcomes
- [ ] No hanging references

### Quality Metrics

**Target**:
- Reference ratio: >30% (references to SPECS)
- Unique value: High (not duplicating specs)
- Completeness: 100% (examples work)
- Practical utility: High (solves real problems)

### Example

```markdown
# Implementation Guide

**For format specifications**: @../spec/format-spec.md

---

## Getting Started

To create your first file:

1. Define metadata (see format spec for requirements)
2. Add content sections
3. Validate structure

### Example Setup

```yaml
meta:
  id: my_first_file
  version: 1.0.0
  title: My First File
```

## Common Patterns

### Pattern 1: Simple Structure

[Applied example]

### Pattern 2: Complex Structure

[Applied example]

---

## Decision Guide

Use simple structure when:
- Small scope
- Few sections
- Single use case

Use complex structure when:
- Large scope
- Many sections
- Multiple use cases

---

## Related Guides

@./advanced-guide.md
@./examples.md
```

---

## PROMPTS Layer

### Purpose
Thin orchestration layer that loads specs/context and provides meta-instructions.

### File Structure

```markdown
# [Prompt Name]

**Purpose**: [One-line purpose]

---

## [Section Name] (Normative)

[Brief intro]

@../[project]-spec/spec1.md
@../[project]-spec/spec2.md

---

## [Section Name] (Applied)

[Brief intro]

@../context/guide1.md
@../context/examples.md

---

## Your Task

[Meta-instructions for LLM]

## [Task Name]

[Specific instructions]

---

## Context Loaded

[Confirmation checklist]
```

### Required Sections

**Mandatory**:
- Purpose statement
- At least one `@` reference section
- "Your Task" or equivalent meta-instructions section

**Optional**:
- Context loaded checklist
- Additional instructions
- Conditional loading logic

### Content Rules

**MUST contain**:
- `@` references to SPECS/CONTEXT (>50% of content)
- Meta-instructions for LLM tasks
- Brief section introductions (<5 lines each)

**MUST NOT contain**:
- Inline spec content (>5 lines)
- Inline examples
- Redefined rules
- Duplicated content from SPECS/CONTEXT

### Validation Criteria

**Reference Density**:
- [ ] >50% of lines are `@` references
- [ ] <5 lines inline content per section
- [ ] All references resolve
- [ ] No circular references

**Orchestration Quality**:
- [ ] Meta-instructions are clear
- [ ] Task definition is specific
- [ ] Context loading is organized
- [ ] No content duplication

### Quality Metrics

**Target**:
- Reference ratio: >50% (@ references / total lines)
- Inline content: <5 lines per section
- Duplication: 0% (no repeated content)
- Clarity: High (task definition clear)

### Example

```markdown
# Load Context Prompt

**Purpose**: Load format specifications and implementation knowledge.

---

## Format Specifications (Normative)

@../spec/format-spec.md
@../spec/syntax-spec.md

---

## Applied Knowledge (Practical)

@../context/implementation-guide.md
@../context/examples.md

---

## Your Task

With these specifications and guides loaded, you can now:

1. Create new files following format spec
2. Validate existing files
3. Guide users on implementation

Remember:
- YMD has metadata, PMD does not
- Reference specs for syntax rules
- Use examples for patterns

---

## Context Loaded

You now understand:
- Complete format specification
- Practical implementation patterns
- Common use cases and examples
```

---

## COMMANDS Layer

### Purpose
Thin API entry points that map one-to-one with PROMPTS.

### File Structure

```markdown
[Optional: One-line description]

@../prompts/corresponding-prompt.md
```

### Required Sections

**Mandatory**:
- Single `@` reference to PROMPT

**Optional**:
- Brief description (1 line)

### Content Rules

**MUST contain**:
- One `@` reference to corresponding PROMPT
- Total file length ≤5 lines

**MUST NOT contain**:
- Business logic
- Multiple prompts
- Inline instructions
- Any duplication

### Validation Criteria

**One-to-One Mapping**:
- [ ] References exactly one PROMPT
- [ ] PROMPT file exists
- [ ] No business logic in COMMAND
- [ ] File ≤5 lines

### Quality Metrics

**Target**:
- File size: ≤5 lines
- Reference count: Exactly 1
- Logic: 0 (no business logic)

### Example

```markdown
Load Gradient architecture context.

@../prompts/load-context.md
```

---

## AGENTS Layer

### Purpose
Specialized contexts that run as spin-off processes with isolated state.

### File Structure

```markdown
# [Agent Name]

You are a [role] specialized in [domain].

---

## Context

@../[project]-spec/relevant-spec.md
@../context/relevant-guide.md

---

## Your Task

[Specific agent instructions]

### [Subtask]

[Details]

---

## Return Format

Return summary containing:
- [Item 1]
- [Item 2]

Do not include:
- [Excluded item 1]
- [Excluded item 2]
```

### Required Sections

**Mandatory**:
- Role definition (1-3 lines)
- Context section (with @ references)
- Task section
- Return format section

**Optional**:
- Subtasks
- Examples
- Constraints

### Content Rules

**MUST contain**:
- Clear role definition
- `@` references to needed specs/context
- Specific task instructions
- Return format specification

**MUST NOT contain**:
- Duplicated spec content
- Business logic (→ PROMPTS)
- Inline examples (→ CONTEXT)

### Validation Criteria

**Role Clarity**:
- [ ] Role clearly defined
- [ ] Specialization specified
- [ ] Context loaded via references
- [ ] Return format explicit

**Isolation**:
- [ ] Does not assume main context
- [ ] Self-contained instructions
- [ ] Clear input/output contract

### Quality Metrics

**Target**:
- Role clarity: High
- Task specificity: High
- Return format: Explicit
- Context loading: Via references

### Example

```markdown
# Architecture Reviewer Agent

You are an architecture reviewer specialized in Gradient compliance validation.

---

## Context

@../spec/architecture-spec.md
@../spec/anti-duplication-principles.md
@../context/decision-guide.md

---

## Your Task

Review the provided project structure for Gradient architecture compliance.

### Check For

1. Layer boundaries respected
2. No duplication across files
3. Proper use of @ references
4. Specs vs context separation

### Validate

- SPECS contain only normative content
- CONTEXT references SPECS appropriately
- PROMPTS use @ references (>50%)
- No circular references

---

## Return Format

Return summary containing:
- Compliance status (pass/fail)
- Issues found (list)
- Recommendations (list)

Do not include:
- Full file contents
- Line-by-line analysis
- Redundant explanations
```

---

## SCRIPTS Layer

### Purpose
Efficiency layer for tasks better done in code than tokens.

### File Structure

```bash
#!/bin/bash
# Script: script-name.sh
# Purpose: [One-line description]
# Usage: script-name.sh [args]
# Author: [optional]
# Date: [optional]

set -e  # Exit on error

# Main logic
main() {
    # Implementation
}

# Run main
main "$@"
```

### Required Sections

**Mandatory**:
- Shebang (#!/bin/bash or #!/usr/bin/env python3)
- Purpose comment
- Usage comment
- Error handling (set -e or try/except)

**Optional**:
- Author
- Date
- Dependencies
- Examples

### Content Rules

**MUST contain**:
- Single responsibility
- Error handling
- Clear usage documentation
- Meaningful exit codes

**MUST NOT contain**:
- Multiple unrelated functions
- Hardcoded paths (use parameters)
- Undocumented behavior

### Validation Criteria

**Code Quality**:
- [ ] Single responsibility
- [ ] Error handling present
- [ ] Usage documented
- [ ] Exit codes meaningful

**Integration**:
- [ ] Callable from PROMPTS if needed
- [ ] Parameters, not hardcoded values
- [ ] Clear input/output contract

### Quality Metrics

**Target**:
- Responsibility: Single
- Error handling: Present
- Documentation: Complete
- Testability: High

### Example

```bash
#!/bin/bash
# Script: validate-structure.sh
# Purpose: Validate Gradient project structure compliance
# Usage: validate-structure.sh <project-path>

set -e

PROJECT_PATH="$1"

if [ -z "$PROJECT_PATH" ]; then
    echo "Usage: validate-structure.sh <project-path>"
    exit 1
fi

# Check for required directories
required_dirs=("spec" "context" "prompts")

for dir in "${required_dirs[@]}"; do
    if [ ! -d "$PROJECT_PATH/$dir" ]; then
        echo "ERROR: Missing required directory: $dir"
        exit 1
    fi
done

echo "Structure validation passed"
exit 0
```

---

## HOOKS Layer

### Purpose
Event-driven workflows triggered by Claude Code lifecycle events.

### File Structure

```markdown
# [Hook Name]

**Triggered on**: [event name]

**Purpose**: [What this hook does]

---

## Action

@../prompts/workflow-prompt.md

---

## Configuration

[Optional configuration]
```

### Required Sections

**Mandatory**:
- Trigger event specification
- Purpose statement
- Action (@ reference to PROMPT)

**Optional**:
- Configuration
- Conditions
- Examples

### Content Rules

**MUST contain**:
- Clear trigger event
- `@` reference to PROMPT for logic
- Purpose statement

**MUST NOT contain**:
- Heavy processing logic (keep lightweight)
- Inline workflow (→ PROMPTS)
- Business logic

### Validation Criteria

**Event Clarity**:
- [ ] Trigger event specified
- [ ] Purpose clear
- [ ] Action references PROMPT
- [ ] Lightweight (no heavy processing)

### Quality Metrics

**Target**:
- Event clarity: High
- Lightweight: Yes (delegates to PROMPTS)
- Purpose clarity: High

### Example

```markdown
# Pre-Command Validation Hook

**Triggered on**: Before command execution

**Purpose**: Validate architecture compliance before running commands.

---

## Action

@../prompts/validate-architecture.md

---

## Configuration

Skip validation for commands:
- help
- version
```

---

## Cross-Layer Validation

### Reference Integrity

**All layers must**:
- Have valid `@` references
- No circular dependencies
- References point to appropriate layers

**Validation**:
```bash
# Check all references resolve
find . -name "*.md" -exec grep -l "@" {} \; | validate-refs.sh
```

### Duplication Check

**Process**:
1. Extract key concepts from each file
2. Search for duplicates across layers
3. Validate SSOT for each concept
4. Ensure proper references

**Command**:
```bash
detect-duplication.sh <project-path>
```

### Boundary Respect

**Check that**:
- SPECS don't contain HOW guidance
- CONTEXT doesn't redefine WHAT rules
- PROMPTS primarily use references
- COMMANDS are thin entry points
- AGENTS are self-contained

---

## Summary

Each layer has:
- **Clear structure**: Defined sections and format
- **Specific content rules**: What MUST and MUST NOT be included
- **Validation criteria**: Measurable quality checks
- **Quality metrics**: Targets for excellence

**Use this specification** to validate existing files and guide creation of new files in Gradient projects.

---

## Related Specifications

**For architectural context**:
- `@./architecture-spec.md`

**For anti-duplication rules**:
- `@./anti-duplication-principles.md`
