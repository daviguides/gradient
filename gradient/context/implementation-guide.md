# Gradient Implementation Guide

**Step-by-step guide for implementing Gradient architecture in your projects.**

For architecture specifications: @~/.claude/gradient/spec/architecture-spec.md
For anti-duplication principles: @~/.claude/gradient/spec/anti-duplication-principles.md
For layer specifications: @~/.claude/gradient/spec/layer-spec.md

---

## Table of Contents

1. [Before You Start](#before-you-start)
2. [Phase 1: Planning](#phase-1-planning)
3. [Phase 2: Creating Specifications](#phase-2-creating-specifications)
4. [Phase 3: Building Context](#phase-3-building-context)
5. [Phase 4: Writing Prompts](#phase-4-writing-prompts)
6. [Phase 5: Adding Commands](#phase-5-adding-commands)
7. [Phase 6: Creating Agents](#phase-6-creating-agents)
8. [Phase 7: Validation](#phase-7-validation)
9. [Migrating Existing Projects](#migrating-existing-projects)
10. [Troubleshooting](#troubleshooting)

---

## Before You Start

### Prerequisites

- Understanding of your project's domain and requirements
- Familiarity with Markdown syntax
- Basic understanding of file organization
- (Optional) Knowledge of Jinja2 for advanced features

### Questions to Answer

Before implementing Gradient, clarify:

1. **What is the normative content?** (rules, definitions, formats)
2. **What are the examples?** (working demonstrations)
3. **What are the orchestration needs?** (how will context be loaded?)
4. **Who are the users?** (LLMs, humans, or both?)
5. **What is the scope?** (simple plugin or complex system?)

### Recommended Tools

- Text editor with Markdown support
- Version control (Git)
- Validation scripts (provided in Gradient project)
- Terminal access for running scripts

---

## Phase 1: Planning

### Step 1.1: Identify Core Concepts

List all concepts that need documentation:

**Example for a validation plugin**:
- Validation rules (normative)
- Data formats (normative)
- Error handling (normative)
- Example validations (applied)
- Implementation patterns (applied)

### Step 1.2: Classify Content

For each concept, determine its layer:

| Concept | Layer | Rationale |
|---------|-------|-----------|
| Validation rules | SPECS | Defines WHAT rules are |
| Data formats | SPECS | Defines WHAT format is required |
| Error handling | SPECS | Defines WHAT constitutes error |
| Example validations | CONTEXT | Shows HOW to apply rules |
| Implementation patterns | CONTEXT | Shows HOW to implement |

### Step 1.3: Identify Duplication Risks

Check for potential duplication:

- Do you have existing documentation?
- Are concepts explained in multiple places?
- Is there a "quick reference" that duplicates specs?
- Do prompts contain inline specifications?

Mark these for consolidation during implementation.

### Step 1.4: Design Directory Structure

Plan your directory layout:

```
my-project/
├── project/spec/       # Your specifications
├── context/            # Your examples and guides
├── prompts/            # Your orchestrators
├── commands/           # Your API entry points
├── agents/             # Specialized contexts (if needed)
├── scripts/            # Automation scripts (if needed)
└── docs/               # Human documentation (if needed)
```

Adjust based on your needs. Minimum viable structure:
```
my-project/
├── project/spec/       # Required
├── context/            # Required
└── prompts/            # Required
```

---

## Phase 2: Creating Specifications

### Step 2.1: Create Directory

```bash
mkdir -p my-project/project-spec
```

### Step 2.2: Start with Core Spec

Create your main specification file:

**Template**: `project/spec/core-spec.md`

```markdown
# [Project Name] Specification

**Purpose**: [One-line description of what this spec defines]

---

## Core Concept 1

[Complete normative definition]

### Subconcept 1.1

[Detailed specification]

### Subconcept 1.2

[Detailed specification]

---

## Core Concept 2

[Complete normative definition]

---

## Validation Rules

[How to validate against this specification]

- Rule 1: [validation criterion]
- Rule 2: [validation criterion]

---

## Related Specifications

@./related-spec.md
```

### Step 2.3: Use Normative Language

Write specifications using clear, definitive language:

**Good normative language**:
- "Files MUST contain..."
- "Values SHALL be..."
- "Fields SHOULD include..."
- "Valid if..."
- "Required: ..."

**Avoid**:
- "You can..." (instructional, not normative)
- "Try to..." (too vague)
- "For example..." (examples go in CONTEXT)
- "Here's how..." (application goes in CONTEXT)

### Step 2.4: Keep Specs Pure

**SPECS should contain**:
- Complete definitions
- Syntax rules
- Format specifications
- Validation criteria
- Normative statements

**SPECS should NOT contain**:
- Working code examples (>10 lines)
- Implementation guides
- "How to" instructions
- Orchestration logic
- Meta-instructions for LLMs

### Step 2.5: Create Additional Specs

If you have multiple domains, create separate specs:

```
project/spec/
├── core-spec.md          # Main definitions
├── format-spec.md        # Format-specific rules
├── validation-spec.md    # Validation rules
└── principles.md         # Foundational principles
```

Each spec should be self-contained for its domain but can reference other specs:

```markdown
# Advanced Specification

For core concepts: @./core-spec.md

## Advanced Concept A

Builds upon Core Concept 1 (see core-spec.md).
Adds features X, Y, Z.
```

### Step 2.6: Validate Specs

Check your specs against layer-spec.md criteria:

- [ ] Completeness: 100% (all concepts defined)
- [ ] Normative language used throughout
- [ ] No working examples (only minimal illustrations)
- [ ] No "how to" instructions
- [ ] Self-contained (can be understood standalone)

---

## Phase 3: Building Context

### Step 3.1: Create Directory

```bash
mkdir -p my-project/context
```

### Step 3.2: Create Examples File

**Template**: `context/examples.md`

```markdown
# [Project Name] Examples

For specifications: @~/.claude/gradient/project/spec/core-spec.md

---

## Example 1: [Scenario Name]

**Purpose**: [What this example demonstrates]

### Complete Implementation

```[language]
[working code or complete example]
```

### Explanation

[How it works, why it's structured this way, key points to notice]

**Validation**:
- Follows [rule from spec]
- Demonstrates [concept from spec]

---

## Example 2: [Another Scenario]

...
```

### Step 3.3: Reference Specs, Don't Duplicate

**When writing examples**:

**Bad** (duplicates spec):
```markdown
## Example 1: Valid File

Files must have three sections: header, body, footer.

Header section contains:
- id: unique identifier
- version: semantic version
- title: human-readable title

[example follows]
```

**Good** (references spec):
```markdown
## Example 1: Valid File

For format requirements: @~/.claude/gradient/project/spec/format-spec.md

```yaml
header:
  id: example_001
  version: 1.0.0
  title: "Example File"

body:
  content: "..."

footer:
  timestamp: "2025-01-15T10:00:00Z"
```

**Key points**:
- All three required sections present
- Header fields follow format-spec.md requirements
- Version uses semantic versioning as specified
```

### Step 3.4: Create Implementation Guide

**Template**: `context/implementation-guide.md`

```markdown
# Implementation Guide

For format specification: @~/.claude/gradient/project/spec/format-spec.md
For validation rules: @~/.claude/gradient/project/spec/validation-spec.md

---

## Getting Started

### Prerequisites

[What users need before implementing]

### Step 1: [First Step]

[Practical guidance with examples]

**Example**:
```[language]
[code showing this step]
```

### Step 2: [Second Step]

[Practical guidance]

---

## Common Patterns

### Pattern 1: [Pattern Name]

**When to use**: [Scenario description]

**Implementation**:
```[language]
[complete working example]
```

**Rationale**: [Why this pattern works]

---

## Best Practices

- [Practice 1 with explanation]
- [Practice 2 with explanation]
- [Practice 3 with explanation]

---

## Common Mistakes

### Mistake 1: [Description]

**Problem**: [What goes wrong]

**Solution**: [How to fix it]

**Example**:
```[language]
// Bad
[code showing mistake]

// Good
[code showing solution]
```
```

### Step 3.5: Add Decision Guide (Optional)

If your project involves choices, create a decision guide:

**Template**: `context/decision-guide.md`

```markdown
# Decision Guide

For specifications: @~/.claude/gradient/project/spec/core-spec.md

---

## Decision 1: [Choice Description]

**Question**: When should I use [Option A] vs [Option B]?

### Use Option A When

- Condition 1
- Condition 2
- Condition 3

**Example scenario**: [Real-world case]

### Use Option B When

- Condition 1
- Condition 2
- Condition 3

**Example scenario**: [Real-world case]

---

## Decision Tree: [Complex Choice]

```
Start
├─ Condition A?
│  ├─ Yes → Use Pattern X
│  └─ No → Continue
│      ├─ Condition B?
│      │  ├─ Yes → Use Pattern Y
│      │  └─ No → Use Pattern Z
```

**Explanation**: [Rationale for each path]
```

### Step 3.6: Validate Context

Check against layer-spec.md criteria:

- [ ] References SPECS for all rules (via @)
- [ ] Provides unique value (not duplicating specs)
- [ ] Examples are complete and functional
- [ ] No syntax redefinition
- [ ] No format respecification

---

## Phase 4: Writing Prompts

### Step 4.1: Create Directory

```bash
mkdir -p my-project/prompts
```

### Step 4.2: Create Main Context Loader

**Template**: `prompts/load-context.md`

```markdown
# Load [Project Name] Context

**Purpose**: [One-line description]

---

## Specifications (Normative)

@~/.claude/gradient/project/spec/core-spec.md
@~/.claude/gradient/project/spec/format-spec.md
@~/.claude/gradient/project/spec/validation-spec.md

---

## Applied Knowledge (Practical)

@~/.claude/gradient/context/examples.md
@~/.claude/gradient/context/implementation-guide.md
@~/.claude/gradient/context/decision-guide.md

---

## Your Task

You now have complete [project name] context loaded:
- [Specification area 1]
- [Specification area 2]
- [Context area 1]
- [Context area 2]

With this context, you can:
- [Task 1]
- [Task 2]
- [Task 3]

Remember:
- [Important note 1]
- [Important note 2]
- [Important note 3]

---

## Context Loaded

You now understand:
- [Concept 1]
- [Concept 2]
- [Concept 3]
```

### Step 4.3: Keep Prompts Thin

**Target metrics**:
- >50% of lines should be `@` references
- <5 lines of inline content per section
- No duplication of specs or context

**Bad** (too much inline content):
```markdown
# Load Context

## Format Rules

Files have three sections:

1. Header: Contains id, version, title
   - id must be snake_case
   - version must be semver
   - title max 100 chars

2. Body: Contains content
   - Markdown format
   - Max 10000 chars

3. Footer: Contains metadata
   - timestamp required
   - author optional

[100 more lines of spec content]
```

**Good** (thin orchestrator):
```markdown
# Load Context

## Format Rules

@~/.claude/gradient/project/spec/format-spec.md

## Examples

@~/.claude/gradient/context/examples.md

## Your Task

Guide users in creating properly formatted files.
Reference format-spec.md for rules.
Use examples.md for patterns.
```

### Step 4.4: Create Workflow Prompts (Optional)

For complex multi-step processes:

**Template**: `prompts/create-workflow.md`

```markdown
# Create [Entity] Workflow

**Purpose**: Guide user through creation process.

---

## Context

@~/.claude/gradient/project/spec/core-spec.md
@~/.claude/gradient/context/implementation-guide.md
@~/.claude/gradient/context/examples.md

---

## Workflow Steps

### Step 1: [Step Name]

[Brief instructions for this step]

**Guidance**: [Where to find details in context]

### Step 2: [Step Name]

[Brief instructions]

### Step 3: Validation

Validate against all specifications before finalizing.

---

## Success Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
```

### Step 4.5: Validate Prompts

Check against layer-spec.md criteria:

- [ ] >50% of lines are `@` references
- [ ] <5 lines inline content per section
- [ ] All references resolve
- [ ] No circular references
- [ ] Meta-instructions are clear
- [ ] No content duplication

---

## Phase 5: Adding Commands

### Step 5.1: Create Directory

```bash
mkdir -p my-project/commands
```

### Step 5.2: Create Command Files

**Template**: `commands/command-name.md`

```markdown
[Optional: One-line description]

@~/.claude/gradient/prompts/corresponding-prompt.md
```

**That's it!** Commands should be exactly this simple.

### Step 5.3: Map Commands to Prompts

One-to-one mapping:

```
commands/
├── load-context.md        → prompts/load-context.md
├── create-entity.md       → prompts/create-workflow.md
├── validate-entity.md     → prompts/validate-workflow.md
└── update-entity.md       → prompts/update-workflow.md
```

### Step 5.4: Follow Naming Conventions

**Command names should**:
- Be verb-based for actions (`create-task`, `validate-file`)
- Be noun-based for loaders (`load-context`)
- Match their prompt names
- Use kebab-case

### Step 5.5: Validate Commands

Check against layer-spec.md criteria:

- [ ] File ≤5 lines
- [ ] References exactly one PROMPT
- [ ] PROMPT file exists
- [ ] No business logic

---

## Phase 6: Creating Agents

### Step 6.1: Determine Need

**Create agents when**:
- You need specialized contexts
- You want isolated tool permissions
- You need background processing
- You want summarized results

**Skip agents if**:
- Simple project with one context
- No specialized needs
- Commands and prompts are sufficient

### Step 6.2: Create Directory (If Needed)

```bash
mkdir -p my-project/agents
```

### Step 6.3: Create Agent Files

**Template**: `agents/agent-name.md`

```markdown
# [Agent Name]

You are a [role] specialized in [domain].

---

## Context

@~/.claude/gradient/project/spec/relevant-spec.md
@~/.claude/gradient/context/relevant-guide.md

---

## Your Task

[Specific agent instructions]

### [Subtask 1]

[Details]

### [Subtask 2]

[Details]

---

## Return Format

Return summary containing:
- [Item 1]
- [Item 2]
- [Item 3]

Do not include:
- [Excluded item 1]
- [Excluded item 2]

---

## Example Output

```[format]
[Show expected output format]
```
```

### Step 6.4: Keep Agents Self-Contained

Agents should:
- Load all needed context via `@` references
- Have clear role definitions
- Specify return format explicitly
- Not assume main context knowledge

### Step 6.5: Validate Agents

Check against layer-spec.md criteria:

- [ ] Role clearly defined
- [ ] Specialization specified
- [ ] Context loaded via references
- [ ] Return format explicit
- [ ] Self-contained instructions

---

## Phase 7: Validation

### Step 7.1: Run Reference Validation

Check all `@` references resolve:

```bash
# Using Gradient validation script
~/.claude/gradient/scripts/validate-references.sh my-project/

# Or manually
find my-project -name "*.md" -exec grep -l "@" {} \;
```

Verify each reference points to an existing file.

### Step 7.2: Check Duplication

Scan for duplicated content:

```bash
# Look for repeated concept definitions
grep -r "Core Concept X" my-project/ --include="*.md"

# Should only appear in ONE file (the SSOT)
```

### Step 7.3: Measure Metrics

Calculate quality metrics:

**For SPECS**:
```bash
# Count total lines
wc -l project/spec/*.md

# Check for examples (should be minimal)
grep -c "```" project/spec/*.md

# Check for "how to" language (should be absent)
grep -i "how to\|step 1\|first," project/spec/*.md
```

**For PROMPTS**:
```bash
# Count @ references
grep -c "@" prompts/*.md

# Count total lines
wc -l prompts/*.md

# Calculate ratio (should be >50%)
```

### Step 7.4: Validate Structure

Check directory structure matches architecture:

```bash
# Required directories present?
ls -d my-project/project-spec
ls -d my-project/context
ls -d my-project/prompts

# Commands are thin?
wc -l commands/*.md  # All should be ≤5 lines

# Specs don't have examples?
grep -l "```" project/spec/*.md | wc -l  # Should be 0 or minimal
```

### Step 7.5: Test Usage

Manually test the implementation:

1. **Load context**: Try `/load-context` command
2. **Check completeness**: Is all necessary information available?
3. **Test workflows**: Try create/update/validate commands
4. **Test agents** (if applicable): Launch agents and check results

### Step 7.6: Document Validation Results

Create validation report:

```markdown
# Validation Report

**Date**: 2025-01-15
**Project**: my-project
**Version**: 1.0.0

## Metrics

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Duplication Ratio | ≤1.1 | 1.0 | ✓ PASS |
| Reference Density (Prompts) | >50% | 75% | ✓ PASS |
| Command File Size | ≤5 lines | 3 avg | ✓ PASS |
| Spec Completeness | 100% | 100% | ✓ PASS |

## Reference Validation

- Total references: 24
- Broken references: 0
- Circular dependencies: 0
- Status: ✓ PASS

## Structure Validation

- Required directories: ✓ Present
- Naming conventions: ✓ Followed
- Layer boundaries: ✓ Respected

## Overall Status: ✓ PASS
```

---

## Migrating Existing Projects

### Step 1: Audit Existing Content

Map all existing documentation:

```
Current Structure:
├── README.md              (500 lines - mixed)
├── docs/guide.md          (800 lines - mixed)
├── docs/quick-ref.md      (300 lines - duplication)
└── examples/             (various files)
```

### Step 2: Identify Duplication

For each major concept:

| Concept | README.md | guide.md | quick-ref.md | SSOT Location |
|---------|-----------|----------|--------------|---------------|
| Format Rules | Lines 50-100 | Lines 1-150 | Lines 10-50 | guide.md (most complete) |
| Examples | None | Lines 151-400 | None | guide.md |
| API | Lines 101-200 | Lines 401-500 | Lines 51-100 | README.md |

### Step 3: Create Gradient Structure

```bash
mkdir -p my-project/{project-spec,context,prompts,commands}
```

### Step 4: Extract to SPECS

Move normative content to specs:

**From guide.md lines 1-150** → **project/spec/format-spec.md**:
```markdown
# Format Specification

[Extract only normative definitions, remove "how to" language]
```

### Step 5: Extract to CONTEXT

Move examples and guides to context:

**From guide.md lines 151-400** → **context/examples.md**:
```markdown
# Examples

For format rules: @~/.claude/gradient/project/spec/format-spec.md

[Extract examples, add references to specs]
```

### Step 6: Create Thin Prompts

New `prompts/load-context.md`:
```markdown
@~/.claude/gradient/project/spec/format-spec.md
@~/.claude/gradient/context/examples.md

Your task: [orchestration logic]
```

### Step 7: Delete Duplications

```bash
# Delete quick-ref.md (100% duplication)
rm docs/quick-ref.md

# Update README.md to reference instead
# From: [500 lines of inline content]
# To: [Brief intro + references]
```

### Step 8: Update All References

Replace inline content with `@` references:

**Before**:
```markdown
# Using the Plugin

The format requires three sections:
[50 lines explaining format]
```

**After**:
```markdown
# Using the Plugin

For format details: @project/spec/format-spec.md
For examples: @context/examples.md
```

### Step 9: Validate Migration

- [ ] All content preserved (nothing lost)
- [ ] Duplication eliminated
- [ ] References resolve correctly
- [ ] Metrics improved (duplication ratio, etc.)
- [ ] Functionality intact

---

## Phase 8: Development Workflow Setup

### Overview

When developing a Gradient project, use a **Makefile toggle system** to switch between development (relative refs) and production (absolute refs) modes.

**Key Principle**: Repository uses absolute paths (production-ready), Makefile temporarily converts for local testing.

### Step 8.1: Understand Reference Strategy

**Repository (Default/Production)**:
```markdown
# Committed code uses absolute paths (production-ready)
@~/.claude/my-bundle/spec/core-spec.md
@~/.claude/my-bundle/context/examples.md
@~/.claude/my-bundle/prompts/workflow.md
```

**Development (Temporary)**:
```markdown
# make dev converts to relative paths (local testing)
@./my-bundle/spec/core-spec.md
@./my-bundle/context/examples.md
@./my-bundle/prompts/workflow.md
```

**Benefits**:
- Repository always production-ready (works if cloned)
- Local testing possible via make dev
- No build step needed in install.sh
- Single source maintained

### Step 8.2: Create Makefile

Add to your project root:

```makefile
.PHONY: dev prod status help

BUNDLE_NAME := my-bundle

help:
	@echo "Development Utilities"
	@echo ""
	@echo "  make dev     - Convert to relative refs"
	@echo "  make prod    - Convert to absolute refs"
	@echo "  make status  - Show current state"

dev:
	@echo "Converting to development mode..."
	@find . -name "*.md" -exec sed -i.bak 's|@~/\.claude/$(BUNDLE_NAME)/|@./$(BUNDLE_NAME)/|g' {} \;
	@find . -name "*.md.bak" -delete
	@echo "✓ Ready for local development"

prod:
	@echo "Converting to production mode..."
	@find . -name "*.md" -exec sed -i.bak 's|@\./$(BUNDLE_NAME)/|@~/.claude/$(BUNDLE_NAME)/|g' {} \;
	@find . -name "*.md.bak" -delete
	@echo "✓ Ready for commit"

status:
	@if grep -r "@\./$(BUNDLE_NAME)/" . --include="*.md" 2>/dev/null | grep -q .; then \
		echo "DEVELOPMENT mode"; \
	else \
		echo "PRODUCTION mode (ready to commit)"; \
	fi
```

### Step 8.3: Workflow During Development

**Daily workflow**:
```bash
# Start development
make dev

# Make changes and test locally
# References now point to local files

# Before committing
make status      # Verify current state
make prod        # Convert back to production refs
git add .
git commit -m "Your changes"
git push
```

**Why this works**:
- Repository is always production-ready (absolute refs)
- `make dev` temporarily converts for local testing
- `make prod` reverts before commit
- No build step needed during installation

### Step 8.4: Validate Reference State

**Check production state** (before starting work):
```bash
make status
# Should show: PRODUCTION mode (ready to commit)

# Verify no relative references
grep -r "@\./" . --include="*.md"
# Should be empty
```

**After switching to dev**:
```bash
make dev
make status
# Should show: DEVELOPMENT mode

# Verify relative references exist
grep -r "@\./my-bundle/" . --include="*.md" | head -5
```

**Before committing**:
```bash
make prod
make status
# Should show: PRODUCTION mode (ready to commit)

# Verify only absolute references
grep -r "@~/.claude/my-bundle/" . --include="*.md" | head -5
```

### Step 8.5: Test Both Modes

**1. Test production mode** (default):
```bash
# Repository in production state
make status  # Should show PROD

# Clone and use (simulates other users)
cd /tmp
git clone your-repo test-install
cd test-install
# Should work without any make commands
```

**2. Test development mode**:
```bash
# In your working directory
make dev

# Make changes to files
# Test with Claude Code
# Changes load from local files immediately
```

**3. Test transition**:
```bash
make dev
# ... work on features ...
make prod
git diff  # Should only show your actual changes, not ref changes
```

### Step 8.6: Document Workflow

Add to `README.md`:

```markdown
## Development Workflow

### For Contributors

This project uses a Makefile to manage development/production reference modes:

**Setup**:
```bash
git clone https://github.com/user/my-bundle.git
cd my-bundle
make status  # Should show "PRODUCTION mode"
```

**Development**:
```bash
make dev     # Convert to local references
# ... make changes and test locally ...
make prod    # Convert back before committing
git commit
```

**Important**: Always run `make prod` before committing! The repository must stay in production mode (absolute references).

**Commands**:
- `make dev` - Enable local development mode
- `make prod` - Return to production mode
- `make status` - Check current state
- `make help` - Show all available commands

### For Users

Just install normally - no special steps needed:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/user/my-bundle/main/install.sh)"
```
```

### Step 8.7: Add CI/CD Validation (Optional)

Add GitHub Actions workflow to ensure production state:

```yaml
name: Validate Production State
on: [push, pull_request]

jobs:
  validate-refs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Check repository is in production mode
        run: |
          if grep -r "@\./my-bundle/" . --include="*.md" 2>/dev/null; then
            echo "ERROR: Repository has relative refs (dev mode)"
            echo "Run 'make prod' before committing"
            exit 1
          fi
          echo "✓ Repository is in production mode"

      - name: Verify Makefile exists
        run: |
          if [ ! -f "Makefile" ]; then
            echo "ERROR: Makefile not found"
            exit 1
          fi
          echo "✓ Makefile exists"

      - name: Test Makefile commands
        run: |
          make status | grep -q "PRODUCTION"
          echo "✓ Makefile status command works"
```

### Success Criteria

- [ ] Repository uses absolute references (`@~/.claude/bundle-name/...`)
- [ ] Makefile exists with dev/prod/status targets
- [ ] `.gitignore` includes `*.md.bak`
- [ ] `make dev` successfully converts to relative refs
- [ ] `make prod` successfully converts back to absolute refs
- [ ] `make status` accurately reports current mode
- [ ] Local development works in dev mode (loads local files)
- [ ] Production mode works when cloned (no make needed)
- [ ] Documentation explains Makefile workflow
- [ ] CI/CD validates production state (if applicable)

---

## Phase 9: Automated Architecture Metrics

### Overview

Gradient includes an automated script for collecting objective architecture metrics without requiring multiple permission requests or inline bash snippets.

**Script**: `gradient/scripts/collect-architecture-metrics.sh`

**Purpose**: Single-execution data collection for architecture validation

### Using the Script

#### Standalone Usage

```bash
# From project root
./gradient/scripts/collect-architecture-metrics.sh

# From any directory (specify project root)
./gradient/scripts/collect-architecture-metrics.sh /path/to/project
```

#### Output Format

The script returns structured JSON:

```json
{
  "validation_timestamp": "2025-10-18T18:35:10Z",
  "project_name": "gradient",
  "bundle_dir": "gradient",
  "bundle_validation": {
    "status": "PASS",
    "match": true,
    "expected": "gradient",
    "actual": "gradient"
  },
  "layers": {
    "detected": "agents,commands,context,prompts,scripts,spec",
    "has_spec": true,
    "has_context": true,
    "has_prompts": true
  },
  "command_references": {
    "bundles": "gradient",
    "consistent": true
  },
  "file_counts": {
    "spec": 3,
    "context": 3,
    "prompts": 2,
    "commands": 2,
    "agents": 1,
    "total_architectural": 11,
    "total_markdown": 27
  },
  "markdown_files": [...]
}
```

### Integration with Validation Workflow

The script is automatically called by `/gradient:validate` (Phase 1.5).

**Benefits**:
- ✅ **Single permission request** (vs 5-7 inline commands)
- ✅ **Structured output** (JSON for easy parsing)
- ✅ **Tested commands** (100% functional)
- ✅ **Can be pre-approved** in Claude Code settings

### Pre-Approving the Script

To avoid permission prompts entirely, add to Claude Code settings:

**File**: `~/.config/claude-code/settings.json` (or your settings location)

```json
{
  "pre_approved_commands": [
    "bash ./gradient/scripts/collect-architecture-metrics.sh",
    "bash gradient/scripts/collect-architecture-metrics.sh"
  ]
}
```

Or add to project-specific `.claude/settings.json`:

```json
{
  "approved_tools": {
    "Bash": {
      "patterns": [
        "./gradient/scripts/collect-architecture-metrics.sh*"
      ]
    }
  }
}
```

### What the Script Collects

**Bundle Validation**:
- Project name (from directory)
- Bundle directory name (containing spec/)
- Name match status (PASS/FAIL)

**Layer Detection**:
- Lists all architectural layers present
- Checks for required layers (spec, context, prompts)

**Reference Consistency**:
- Extracts bundle names from commands/*.md
- Validates all references use same bundle name

**File Counts**:
- Files per layer (spec, context, prompts, commands, agents, scripts, hooks)
- Total architectural files
- Total markdown files

**File Listing**:
- Complete list of all .md files
- Excludes: node_modules, .git, docs/_site

### Error Handling

**Script exits with code 0** on success, returns valid JSON even if validation fails.

**Common scenarios**:
- `bundle_dir: "NOT_FOUND"` → No spec/ directory found
- `bundle_validation.status: "FAIL"` → Name mismatch
- `command_references.bundles: "NONE"` → No commands or no references
- `layers.detected: ""` → No architectural layers found

### Testing the Script

```bash
# Test execution
./gradient/scripts/collect-architecture-metrics.sh

# Validate JSON output (requires jq)
./gradient/scripts/collect-architecture-metrics.sh | jq .

# Check specific field
./gradient/scripts/collect-architecture-metrics.sh | jq '.bundle_validation.status'
```

### Customizing for Your Project

The script is designed for Gradient architecture but can be adapted:

1. **Add custom checks**: Extend data collection logic
2. **Modify layer detection**: Add project-specific layers
3. **Change output format**: Adjust JSON structure
4. **Add validation rules**: Extend FAIL conditions

**Location**: `gradient/scripts/collect-architecture-metrics.sh` (edit as needed)

---

## Troubleshooting

### Problem: Broken References

**Symptom**: References don't resolve

**Causes**:
- Wrong relative path
- File moved but references not updated
- Typo in filename

**Solution**:
```bash
# Find all references
find . -name "*.md" -exec grep -H "@" {} \;

# Check each path manually or use validation script
~/.claude/gradient/scripts/validate-references.sh .
```

### Problem: High Duplication Ratio

**Symptom**: Duplication ratio >1.3

**Causes**:
- Content repeated across files
- Specs duplicated in context
- Prompts have inline content

**Solution**:
1. Identify duplicated content
2. Determine SSOT location
3. Consolidate to SSOT
4. Replace with `@` references
5. Re-measure

### Problem: Prompts Too Verbose

**Symptom**: Reference density <30%

**Causes**:
- Inline spec content
- Inline examples
- Too much orchestration logic

**Solution**:
```markdown
# Before (verbose)
## Format Rules
Files must have:
- Header with id, version, title
- Body with content
[... 100 lines ...]

# After (thin)
## Format Rules
@~/.claude/gradient/project/spec/format-spec.md

## Examples
@~/.claude/gradient/context/examples.md
```

### Problem: Unclear Layer Boundaries

**Symptom**: Specs contain examples, context contains rules

**Causes**:
- Not following layer responsibilities
- Mixed normative and applied content

**Solution**:
1. Review layer-spec.md for each layer's rules
2. Identify misplaced content
3. Move to appropriate layer
4. Update references

### Problem: Circular References

**Symptom**: File A references B, B references A

**Causes**:
- Poor separation of concerns
- Specs and context too intertwined

**Solution**:
1. Identify cycle (A → B → A)
2. Determine dependency direction (specs should not reference context)
3. Refactor to break cycle
4. Ensure correct layer hierarchy (SPECS ← CONTEXT ← PROMPTS)

---

## Next Steps

After implementing Gradient:

1. **Document your implementation**: Create project-specific docs
2. **Share patterns**: If you discover new patterns, contribute them
3. **Monitor metrics**: Track duplication ratio over time
4. **Iterate**: Refine your structure based on usage
5. **Teach others**: Help team members understand the architecture

---

## Additional Resources

**Specifications**:
- @~/.claude/gradient/spec/architecture-spec.md - Complete architecture
- @~/.claude/gradient/spec/anti-duplication-principles.md - Duplication prevention
- @~/.claude/gradient/spec/layer-spec.md - Layer technical specs

**Examples**:
- @./examples.md - Working examples of Gradient projects

**Decision Support**:
- @./decision-guide.md - When to use what pattern

---

**Remember**: Gradient is about smooth transitions, not rigid rules. Adapt to your needs while maintaining the core principle of zero duplication through SSOT.
