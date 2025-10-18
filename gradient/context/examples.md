# Gradient Architecture Examples

**Complete working examples demonstrating Gradient architecture patterns.**

For architecture specifications: @./gradient/spec/architecture-spec.md

---

## Table of Contents

1. [Simple Plugin Example](#simple-plugin-example)
2. [Multi-Layer Example](#multi-layer-example)
3. [Reference Chain Example](#reference-chain-example)
4. [Migration Example](#migration-example)
5. [Agent Example](#agent-example)
6. [Complete Project Example](#complete-project-example)

---

## Simple Plugin Example

### Scenario

Creating a simple validation plugin with one specification, one context guide, and one prompt.

### Directory Structure

```
validation-plugin/
├── validation-spec/
│   └── rules-spec.md
├── context/
│   └── examples.md
└── prompts/
    └── load-context.md
```

### File: validation-spec/rules-spec.md

```markdown
# Validation Rules Specification

**Purpose**: Define validation rules for data integrity checks.

---

## Core Validation Rules

### Rule 1: Non-Empty Values

Fields marked as required MUST NOT be empty strings, null, or undefined.

**Validation**:
- Check field exists in data structure
- Check field value is not: `""`, `null`, `undefined`

### Rule 2: Type Consistency

Fields MUST match their declared type throughout the system.

**Validation**:
- String fields contain only string values
- Number fields contain only numeric values
- Boolean fields contain only true/false

### Rule 3: Format Compliance

Fields with format requirements MUST match the specified pattern.

**Common formats**:
- Email: Must match RFC 5322 standard
- Phone: Must match E.164 international format
- Date: Must be ISO 8601 format (YYYY-MM-DD)

---

## Validation Workflow

1. Check required fields (Rule 1)
2. Verify type consistency (Rule 2)
3. Validate format compliance (Rule 3)
4. Return validation result with specific errors
```

### File: context/examples.md

```markdown
# Validation Examples

For validation rules: @./gradient/validation-spec/rules-spec.md

---

## Example 1: User Data Validation

### Input Data

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30,
  "phone": "+15551234567"
}
```

### Validation Process

**Step 1 - Required Fields** (Rule 1):
- `name`: "John Doe" → Valid (non-empty string)
- `email`: "john@example.com" → Valid (non-empty string)
- `age`: 30 → Valid (non-empty number)

**Step 2 - Type Consistency** (Rule 2):
- `name`: string → Valid
- `email`: string → Valid
- `age`: number → Valid
- `phone`: string → Valid

**Step 3 - Format Compliance** (Rule 3):
- `email`: Matches RFC 5322 → Valid
- `phone`: Matches E.164 → Valid

**Result**: All validations passed ✓

---

## Example 2: Invalid Data

### Input Data

```json
{
  "name": "",
  "email": "invalid-email",
  "age": "thirty",
  "phone": "555-1234"
}
```

### Validation Process

**Step 1 - Required Fields** (Rule 1):
- `name`: "" → **Invalid** (empty string)

**Step 2 - Type Consistency** (Rule 2):
- `age`: "thirty" (string, expected number) → **Invalid**

**Step 3 - Format Compliance** (Rule 3):
- `email`: "invalid-email" → **Invalid** (missing @ and domain)
- `phone`: "555-1234" → **Invalid** (not E.164 format)

**Result**: Validation failed with 4 errors

### Error Report

```json
{
  "valid": false,
  "errors": [
    {
      "field": "name",
      "rule": "non_empty_values",
      "message": "Field 'name' cannot be empty"
    },
    {
      "field": "age",
      "rule": "type_consistency",
      "message": "Field 'age' must be number, got string"
    },
    {
      "field": "email",
      "rule": "format_compliance",
      "message": "Field 'email' must match RFC 5322 format"
    },
    {
      "field": "phone",
      "rule": "format_compliance",
      "message": "Field 'phone' must match E.164 format (+NNNNNNNNNN)"
    }
  ]
}
```

---

## Example 3: Partial Data

### Input Data

```json
{
  "name": "Jane Smith",
  "email": "jane@example.com"
}
```

### Validation Process

**Optional fields** (age, phone) are not required.

**Step 1 - Required Fields**:
- `name`: "Jane Smith" → Valid
- `email`: "jane@example.com" → Valid

**Step 2 - Type Consistency**:
- `name`: string → Valid
- `email`: string → Valid

**Step 3 - Format Compliance**:
- `email`: Matches RFC 5322 → Valid

**Result**: All validations passed ✓
```

### File: prompts/load-context.md

```markdown
# Load Validation Context

**Purpose**: Load validation rules and examples for data validation tasks.

---

## Validation Rules (Normative)

@./gradient/validation-spec/rules-spec.md

---

## Applied Examples (Practical)

@./gradient/context/examples.md

---

## Your Task

You now have complete validation context loaded:
- Normative rules defining validation requirements
- Working examples showing validation in action

When validating data:
1. Apply rules in order (required → type → format)
2. Collect all errors (don't stop at first failure)
3. Return structured error report matching example format
4. Reference rules by name in error messages
```

### Usage

```markdown
<!-- commands/validate-data.md -->
Validate data against defined rules.

@./gradient/prompts/load-context.md
```

**Result**: Clean separation with zero duplication. Rules defined once, examples show application, prompt orchestrates.

---

## Multi-Layer Example

### Scenario

Plugin with multiple specs, multiple context files, and layered prompts.

### Directory Structure

```
content-plugin/
├── content-spec/
│   ├── format-spec.md
│   ├── metadata-spec.md
│   └── validation-spec.md
├── context/
│   ├── format-examples.md
│   ├── metadata-examples.md
│   └── implementation-guide.md
└── prompts/
    ├── load-format-context.md
    ├── load-metadata-context.md
    └── load-complete-context.md
```

### File: prompts/load-format-context.md

```markdown
# Load Format Context

Load only format-related specifications and examples.

---

## Format Specification

@./gradient/content-spec/format-spec.md

---

## Format Examples

@./gradient/context/format-examples.md

---

## Your Task

You now understand the format requirements.
Guide users in creating properly formatted content.
```

### File: prompts/load-metadata-context.md

```markdown
# Load Metadata Context

Load only metadata-related specifications and examples.

---

## Metadata Specification

@./gradient/content-spec/metadata-spec.md

---

## Metadata Examples

@./gradient/context/metadata-examples.md

---

## Your Task

You now understand metadata requirements.
Help users define appropriate metadata.
```

### File: prompts/load-complete-context.md

```markdown
# Load Complete Context

Load all specifications and context for comprehensive assistance.

---

## All Specifications

@./gradient/content-spec/format-spec.md
@./gradient/content-spec/metadata-spec.md
@./gradient/content-spec/validation-spec.md

---

## All Context

@./gradient/context/format-examples.md
@./gradient/context/metadata-examples.md
@./gradient/context/implementation-guide.md

---

## Your Task

You now have complete content plugin context.
Assist with all aspects: format, metadata, validation, and implementation.
```

### Commands Layer

```markdown
<!-- commands/load-format.md -->
@./gradient/prompts/load-format-context.md

<!-- commands/load-metadata.md -->
@./gradient/prompts/load-metadata-context.md

<!-- commands/load-all.md -->
@./gradient/prompts/load-complete-context.md
```

**Benefits**:
- Granular loading (load only what's needed)
- Complete loading (load everything when needed)
- No duplication (specs/context defined once)
- Flexible composition (mix and match)

---

## Reference Chain Example

### Scenario

Complex reference chain showing how context references specs, and prompts reference both.

### Directory Structure

```
chain-demo/
├── chain-spec/
│   ├── core-spec.md
│   └── advanced-spec.md
├── context/
│   ├── basic-examples.md      (references core-spec.md)
│   └── advanced-examples.md   (references advanced-spec.md)
└── prompts/
    └── load-chain.md          (references all)
```

### File: chain-spec/core-spec.md

```markdown
# Core Specification

## Concept A

Definition of Concept A with complete normative rules.

## Concept B

Definition of Concept B with validation criteria.
```

### File: chain-spec/advanced-spec.md

```markdown
# Advanced Specification

For core concepts: @./core-spec.md

## Concept C

Builds on Concept A (see core spec).
Adds advanced features X, Y, Z.

## Concept D

Combines Concept A and Concept B in sophisticated ways.
```

### File: context/basic-examples.md

```markdown
# Basic Examples

For core concepts: @./gradient/chain-spec/core-spec.md

---

## Example 1: Using Concept A

[Shows Concept A in action without redefining it]

## Example 2: Using Concept B

[Shows Concept B in action without redefining it]
```

### File: context/advanced-examples.md

```markdown
# Advanced Examples

For core concepts: @./gradient/chain-spec/core-spec.md
For advanced concepts: @./gradient/chain-spec/advanced-spec.md

---

## Example 3: Using Concept C

[Shows Concept C building on Concept A]

## Example 4: Combining Concepts

[Shows Concepts A, B, C, D working together]
```

### File: prompts/load-chain.md

```markdown
# Load Complete Chain

## Specifications

@./gradient/chain-spec/core-spec.md
@./gradient/chain-spec/advanced-spec.md

## Examples

@./gradient/context/basic-examples.md
@./gradient/context/advanced-examples.md

## Your Task

All concepts loaded through reference chain.
Assist users with both basic and advanced usage.
```

**Reference Resolution Flow**:

```
load-chain.md
├─→ core-spec.md (loaded directly)
├─→ advanced-spec.md
│   └─→ references core-spec.md (already loaded)
├─→ basic-examples.md
│   └─→ references core-spec.md (already loaded)
└─→ advanced-examples.md
    ├─→ references core-spec.md (already loaded)
    └─→ references advanced-spec.md (already loaded)
```

**Result**: Each file loaded once, references resolved correctly, no circular dependencies.

---

## Migration Example

### Before Gradient

```
legacy-plugin/
├── comprehensive-guide.md    # 800 lines (mixed spec + examples + instructions)
├── quick-ref.md             # 300 lines (duplicates comprehensive-guide)
└── README.md                # 200 lines (duplicates both)
```

**Issues**:
- 1300 total lines
- ~600 lines duplication (46% duplication ratio)
- Update in 3 places
- Unclear which is authoritative

### After Gradient

```
legacy-plugin/
├── plugin-spec/
│   ├── core-spec.md              # 400 lines (pure spec)
│   └── principles.md             # 100 lines (foundational)
├── context/
│   ├── examples.md               # 300 lines (working examples)
│   └── implementation-guide.md   # 200 lines (step-by-step)
├── prompts/
│   └── load-context.md           # 50 lines (references)
└── commands/
    └── load.md                   # 3 lines (thin wrapper)
```

**Improvements**:
- 1053 total lines (19% reduction)
- 0 lines duplication (0% duplication ratio)
- Update once in spec
- Clear SSOT

### Migration Process

**Step 1: Extract Normative Content**

From `comprehensive-guide.md` lines 1-400:
```markdown
# Plugin Format

Files must have:
1. Header section
2. Content section
3. Footer section
```

→ Moved to `plugin-spec/core-spec.md`

**Step 2: Extract Examples**

From `comprehensive-guide.md` lines 401-700:
```markdown
Example 1:
[complete working example]
```

→ Moved to `context/examples.md` with reference to spec:
```markdown
For format rules: @./gradient/plugin-spec/core-spec.md

## Example 1
[complete working example]
```

**Step 3: Delete Quick Reference**

`quick-ref.md` deleted entirely (100% duplication).

**Step 4: Update README**

From `README.md`:
```markdown
# Plugin

Format rules:
[200 lines of duplicated spec content]
```

→ To:
```markdown
# Plugin

For complete specifications: @plugin-spec/core-spec.md
For examples: @context/examples.md

[Brief introduction only]
```

**Step 5: Create Thin Prompt**

New `prompts/load-context.md`:
```markdown
@./gradient/plugin-spec/core-spec.md
@./gradient/context/examples.md

Your task: [orchestration logic]
```

**Step 6: Validate**

```bash
# Check all references resolve
./scripts/validate-references.sh

# Check duplication ratio
./scripts/calculate-metrics.sh

# Result: All checks pass
```

---

## Agent Example

### Scenario

Specialized agent for architecture review.

### File: agents/architecture-reviewer.md

```markdown
# Architecture Reviewer Agent

You are an architecture reviewer specialized in Gradient compliance validation.

---

## Gradient Architecture Context

@./gradient/spec/architecture-spec.md
@./gradient/spec/anti-duplication-principles.md
@./gradient/spec/layer-spec.md

---

## Your Task

Review the provided project structure for Gradient architecture compliance.

### Check For

1. **Layer Boundaries Respected**
   - SPECS contain only normative content
   - CONTEXT references SPECS appropriately
   - PROMPTS use @ references (>50%)

2. **No Duplication**
   - Each concept has single source of truth
   - No paraphrased repetition across files
   - Examples don't redefine specs

3. **Proper References**
   - All @ references resolve to existing files
   - No circular dependencies
   - References point to appropriate layers

4. **File Structure**
   - Naming conventions followed
   - Directory structure matches architecture
   - File sizes appropriate for layer

### Validation Process

1. Scan all files for duplication
2. Check reference integrity
3. Verify layer boundaries
4. Validate file structure

---

## Return Format

Return summary containing:

**Compliance Status**: PASS | FAIL

**Issues Found**:
- List of specific violations
- File locations
- Severity (critical | warning | info)

**Recommendations**:
- Specific refactoring suggestions
- Reference architecture-spec sections
- Priority order

Do not include:
- Full file contents
- Line-by-line analysis
- Redundant explanations

---

## Example Output

```json
{
  "status": "FAIL",
  "issues": [
    {
      "file": "prompts/load-context.md",
      "severity": "critical",
      "violation": "inline_content_exceeded",
      "details": "Contains 200 lines inline content (max: 5 per section)",
      "reference": "architecture-spec.md#prompts-layer"
    },
    {
      "file": "context/guide.md",
      "severity": "warning",
      "violation": "spec_duplication",
      "details": "Lines 45-67 duplicate content from specs/format-spec.md",
      "reference": "anti-duplication-principles.md#detection"
    }
  ],
  "recommendations": [
    {
      "priority": 1,
      "action": "Extract inline content from prompts/load-context.md to context/",
      "rationale": "Prompts should be thin orchestrators"
    },
    {
      "priority": 2,
      "action": "Replace duplication in context/guide.md with @reference",
      "rationale": "Maintain single source of truth"
    }
  ]
}
```
```

### Usage

```bash
# Launch agent
claude-code agent architecture-reviewer

# Agent reviews project structure
# Returns compliance report
# User addresses issues
```

**Benefits**:
- Automated compliance checking
- Consistent validation criteria
- Clear, actionable feedback
- References loaded via @, not duplicated

---

## Complete Project Example

### Scenario

Full-featured Claude Code plugin following Gradient architecture.

### Directory Structure

```
task-manager-plugin/
├── task-spec/
│   ├── task-format-spec.md
│   ├── priority-spec.md
│   ├── status-spec.md
│   └── validation-spec.md
│
├── context/
│   ├── examples.md
│   ├── implementation-guide.md
│   ├── decision-guide.md
│   └── patterns.md
│
├── prompts/
│   ├── load-context.md
│   ├── create-task-workflow.md
│   ├── update-task-workflow.md
│   └── validate-task-workflow.md
│
├── commands/
│   ├── load-context.md
│   ├── create-task.md
│   ├── update-task.md
│   └── validate-task.md
│
├── agents/
│   ├── task-author.md
│   ├── task-validator.md
│   └── task-optimizer.md
│
├── scripts/
│   ├── validate-references.sh
│   ├── calculate-metrics.sh
│   └── generate-report.sh
│
└── docs/
    ├── architecture-guide.md
    └── getting-started.md
```

### File: task-spec/task-format-spec.md

```markdown
# Task Format Specification

**Purpose**: Define the complete structure and syntax of task files.

---

## File Structure

Task files MUST contain:

1. Metadata section (required)
2. Content section (required)
3. Status section (required)
4. History section (optional)

### Metadata Section

Required fields:
- `id`: Unique identifier (UUID v4)
- `title`: Task title (max 100 characters)
- `created`: ISO 8601 timestamp
- `priority`: Priority level (see priority-spec.md)

### Content Section

Task description and details.

Format: Markdown
Maximum length: 10000 characters

### Status Section

Current task status (see status-spec.md).

---

## Validation Rules

Valid task file if:
- All required sections present
- Metadata fields valid
- Priority matches spec
- Status matches spec
- Timestamps are ISO 8601
```

### File: context/implementation-guide.md

```markdown
# Task Manager Implementation Guide

For format specification: @./gradient/task-spec/task-format-spec.md
For priority rules: @./gradient/task-spec/priority-spec.md
For status rules: @./gradient/task-spec/status-spec.md

---

## Creating Your First Task

### Step 1: Define Metadata

Start with required metadata fields:

```yaml
metadata:
  id: "550e8400-e29b-41d4-a716-446655440000"
  title: "Implement user authentication"
  created: "2025-01-15T10:30:00Z"
  priority: "high"
```

See priority-spec.md for valid priority values.

### Step 2: Add Content

Write task description in Markdown:

```markdown
## Description

Implement JWT-based authentication for API endpoints.

## Requirements

- Use industry-standard JWT library
- Support token refresh
- Implement proper error handling
```

### Step 3: Set Status

Define current status (see status-spec.md):

```yaml
status:
  current: "in_progress"
  updated: "2025-01-15T14:20:00Z"
  assignee: "john.doe"
```

### Step 4: Validate

Use validation workflow to ensure compliance with all specs.
```

### File: prompts/load-context.md

```markdown
# Load Task Manager Context

**Purpose**: Load complete task manager specifications and guidance.

---

## Specifications (Normative)

@./gradient/task-spec/task-format-spec.md
@./gradient/task-spec/priority-spec.md
@./gradient/task-spec/status-spec.md
@./gradient/task-spec/validation-spec.md

---

## Implementation Guidance (Applied)

@./gradient/context/implementation-guide.md
@./gradient/context/examples.md
@./gradient/context/decision-guide.md

---

## Your Task

You now have complete task manager context:
- All format specifications
- Priority and status rules
- Validation requirements
- Implementation guidance and examples

Assist users with:
- Creating tasks
- Updating tasks
- Validating task files
- Making decisions about task structure
```

### File: prompts/create-task-workflow.md

```markdown
# Create Task Workflow

**Purpose**: Guide user through task creation process.

---

## Context

@./gradient/task-spec/task-format-spec.md
@./gradient/context/implementation-guide.md
@./gradient/context/examples.md

---

## Workflow Steps

### Step 1: Gather Requirements

Ask user:
- Task title
- Task description
- Priority level (reference priority-spec.md)
- Assignee (if known)

### Step 2: Generate Metadata

Create metadata section following format-spec.md:
- Generate UUID for id
- Use provided title
- Set created timestamp to now
- Set priority from user input

### Step 3: Format Content

Structure description as Markdown following best practices.

### Step 4: Set Initial Status

Default status for new tasks:
```yaml
status:
  current: "todo"
  updated: [current timestamp]
  assignee: [from user input or null]
```

### Step 5: Validate

Run validation against all specs before finalizing.

### Step 6: Present Result

Show complete task file and ask for confirmation.
```

### File: commands/create-task.md

```markdown
Create a new task following task manager specifications.

@./gradient/prompts/create-task-workflow.md
```

### File: agents/task-author.md

```markdown
# Task Author Agent

You are a task authoring specialist for the task manager plugin.

---

## Context

@./gradient/task-spec/task-format-spec.md
@./gradient/task-spec/priority-spec.md
@./gradient/task-spec/status-spec.md
@./gradient/context/implementation-guide.md
@./gradient/context/examples.md

---

## Your Specialization

You excel at:
- Crafting clear, actionable task descriptions
- Choosing appropriate priority levels
- Structuring complex tasks effectively
- Following all format specifications precisely

---

## Your Task

Assist in authoring high-quality task files that:
- Follow all specifications exactly
- Use clear, concise language
- Include all necessary details
- Are properly prioritized
- Validate successfully

---

## Return Format

Return complete task file ready to use.
Include validation confirmation.
Highlight any decisions made and rationale.
```

### Usage Example

```bash
# User command
/create-task

# System loads create-task.md command
# Which loads create-task-workflow.md prompt
# Which loads all necessary specs and context
# LLM guides user through creation process
# Validates against specs
# Returns complete task file
```

**Metrics**:

| Metric | Value |
|--------|-------|
| Total files | 19 |
| Total lines | ~2500 |
| Duplication ratio | 1.0 (zero duplication) |
| Reference density (prompts) | 75% |
| Commands (thin wrappers) | 4 (all ≤5 lines) |
| Specs (SSOT) | 4 |
| Context files (unique value) | 4 |

**Benefits**:
- Complete separation of concerns
- Zero duplication across all files
- Clear reference chains
- Thin orchestrators
- Maintainable and extensible
- Follows Gradient architecture perfectly

---

## Summary

These examples demonstrate:

1. **Simple plugin**: Minimum viable Gradient structure
2. **Multi-layer**: Granular loading with multiple specs
3. **Reference chain**: Complex reference resolution
4. **Migration**: Before/after showing improvements
5. **Agent**: Specialized context for specific tasks
6. **Complete project**: Full-featured implementation

**Key patterns**:
- Specs define once (SSOT)
- Context shows application (references specs)
- Prompts orchestrate (references both)
- Commands are thin (reference prompts)
- Agents are specialized (reference what they need)
- Zero duplication throughout

For architectural details: @./gradient/spec/architecture-spec.md
For implementation guidance: @./implementation-guide.md
