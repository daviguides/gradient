---
layout: page
title: Quick Start
nav_order: 2
permalink: /quick-start/
---

# Quick Start Guide

Get your first Gradient project running in 10 minutes.

---

## Installation

### One-Line Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/daviguides/gradient/main/install.sh)"
```

**What it does**:
- Copies `gradient-spec/` to `~/.claude/gradient/`
- Optionally configures `~/.claude/CLAUDE.md`
- Makes scripts executable

### Manual Install

```bash
git clone https://github.com/daviguides/gradient.git
cd gradient
./install.sh
```

### Verify Installation

```bash
ls ~/.claude/gradient/
```

**Expected**:
```
gradient-spec/    # Specifications (SPECS)
context/          # Examples & guides (CONTEXT)
prompts/          # Orchestrators (PROMPTS)
commands/         # Entry points (COMMANDS)
agents/           # Specialized contexts (AGENTS)
scripts/          # Validation tools (SCRIPTS)
```

---

## Your First Gradient Project

### Step 1: Create Directory Structure

```bash
mkdir -p my-plugin/{my-plugin-spec,context,prompts,commands}
cd my-plugin
```

**Result**:
```
my-plugin/
├── my-plugin-spec/    # Will contain specifications
├── context/           # Will contain examples
├── prompts/           # Will contain orchestrators
└── commands/          # Will contain entry points
```

### Step 2: Create Your First Spec

Create `my-plugin-spec/format-spec.md`:

```markdown
# Format Specification

**Purpose**: Define the structure of plugin configuration files.

---

## File Structure

Configuration files MUST contain:
1. Settings section (required)
2. Options section (optional)

### Settings Section

Required fields:
- `name`: Plugin name (string, max 50 chars)
- `version`: Semantic version (MAJOR.MINOR.PATCH)
- `enabled`: Boolean flag

**Example**:
```yaml
settings:
  name: "my-plugin"
  version: "1.0.0"
  enabled: true
```

---

## Validation Rules

Valid configuration if:
- All required sections present
- Field types match specification
- Version follows semver format
```

**Key principle**: Specs define WHAT, not HOW.

### Step 3: Create Context with Examples

Create `context/examples.md`:

```markdown
# Configuration Examples

For format rules: @../my-plugin-spec/format-spec.md

---

## Example 1: Minimal Configuration

```yaml
settings:
  name: "simple-plugin"
  version: "1.0.0"
  enabled: true
```

**Validates**: All required fields present, correct types.

---

## Example 2: With Options

```yaml
settings:
  name: "advanced-plugin"
  version: "2.1.0"
  enabled: true

options:
  debug: false
  timeout: 30
```

**Validates**: Optional section added, maintains required fields.

---

## Example 3: Invalid Configuration

```yaml
settings:
  name: "broken-plugin"
  version: "invalid"
  enabled: "yes"
```

**Fails validation**:
- `version`: Not semver format
- `enabled`: String instead of boolean
```

**Key principle**: Context shows HOW to apply specs.

### Step 4: Create Thin Prompt

Create `prompts/load-context.md`:

```markdown
# Load Plugin Context

**Purpose**: Load plugin specifications and examples.

---

## Specifications (Normative)

@../my-plugin-spec/format-spec.md

---

## Examples (Applied)

@../context/examples.md

---

## Your Task

You now have complete plugin configuration knowledge:
- Format specifications
- Working examples
- Validation rules

Guide users in creating valid configuration files.
```

**Key principle**: Prompts orchestrate via references (>50% should be `@`).

### Step 5: Create Command Entry Point

Create `commands/load-context.md`:

```markdown
Load my-plugin context.

@../prompts/load-context.md
```

**Key principle**: Commands are thin wrappers (≤5 lines).

---

## Validate Your Project

### Check References

```bash
bash ~/.claude/gradient/scripts/validate-references.sh my-plugin/
```

**Expected**: "All references valid ✓"

### Calculate Metrics

```bash
bash ~/.claude/gradient/scripts/calculate-metrics.sh my-plugin/
```

**Expected metrics**:
- Duplication ratio: ~1.0
- Reference density: >50%
- All layers present: 3/3

### Detect Duplication

```bash
bash ~/.claude/gradient/scripts/detect-duplication.sh my-plugin/
```

**Expected**: "No significant duplication detected ✓"

---

## Load Context in Claude Code

### Use Your Command

```
/load-context
```

This loads your plugin specifications and examples.

### Test It

Ask Claude Code:
```
Create a valid configuration for my plugin
```

Claude should use your specs and examples to generate correct configuration.

---

## Common Patterns

### Pattern 1: Simple Spec + Examples

**When**: Basic plugin with straightforward rules

**Structure**:
```
my-plugin/
├── my-plugin-spec/
│   └── core-spec.md
├── context/
│   └── examples.md
└── prompts/
    └── load-context.md
```

### Pattern 2: Multi-Spec Plugin

**When**: Complex plugin with multiple domains

**Structure**:
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

### Pattern 3: With Agent

**When**: Need specialized review/validation

**Structure**:
```
my-plugin/
├── my-plugin-spec/
│   └── core-spec.md
├── context/
│   └── examples.md
├── prompts/
│   └── load-context.md
└── agents/
    └── config-validator.md
```

**Agent example** (`agents/config-validator.md`):
```markdown
# Configuration Validator Agent

You are a configuration validator for my-plugin.

## Context

@../my-plugin-spec/format-spec.md
@../context/examples.md

## Your Task

Validate provided configuration files against specifications.

Return:
- Validation status (pass/fail)
- List of errors (if any)
- Suggestions for fixes
```

---

## Next Steps

Now that you have a working Gradient project:

1. **Add more specs**: Create additional specification files
2. **Enrich context**: Add implementation guides, decision trees
3. **Create workflows**: Build multi-step prompts for complex tasks
4. **Add agents**: Create specialized validators or reviewers
5. **Write scripts**: Automate validation or generation tasks

---

## Troubleshooting

### Reference Not Found

**Error**: `ERROR: Broken reference in prompts/load-context.md`

**Fix**: Check relative path from prompt to referenced file
```markdown
# If prompt is in prompts/
@../my-plugin-spec/format-spec.md  # Correct (up one level)
@./my-plugin-spec/format-spec.md   # Wrong (same level)
```

### High Duplication Ratio

**Error**: `Duplication ratio: 1.5` (target: ≤1.1)

**Fix**: Find duplicated content and consolidate
1. Identify what's duplicated
2. Determine Single Source of Truth (SSOT)
3. Move content to SSOT
4. Replace duplicates with `@` references

### Prompt Too Verbose

**Error**: `Reference density: 0.2` (target: >0.5)

**Fix**: Extract inline content to specs/context
```markdown
# Before (verbose)
## Format Rules
Files must have settings with name, version, enabled.
Name is string max 50 chars.
[... 50 lines of spec content ...]

# After (thin)
## Format Rules
@../my-plugin-spec/format-spec.md

## Examples
@../context/examples.md
```

---

## Resources

- [Specifications]({% link _pages/specifications.md %}) - Layer details
- [Architecture Guide]({% link _pages/architecture-guide.md %}) - Deep dive
- [Examples]({% link _pages/examples.md %}) - Real-world projects
- [Tools]({% link _pages/tools.md %}) - Scripts and agents

---

**Ready to build?** Start with a simple spec, add examples, create a thin prompt, and validate!
