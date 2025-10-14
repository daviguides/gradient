# Creating Plugin Documentation with Jekyll

**Purpose**: Reusable prompt/plan for creating complete Jekyll documentation site for any Gradient plugin.

**Audience**:
- LLMs generating documentation
- Human developers creating docs manually
- Reference for documentation standards

---

## Overview

This document provides a complete guide for creating a Jekyll-based documentation site for Gradient plugins, following the pattern established in the Gradient project itself.

### What You Get (Standard Files)

The following files are provided as standards and **should not be modified** (or only minimally):

```
docs/
├── _config.yml          # Base configuration (customize title/description only)
├── Gemfile              # Ruby dependencies (standard, no changes needed)
├── _includes/           # Reusable components (standard)
├── _layouts/            # Page templates (standard)
├── _sass/               # Stylesheets (standard)
└── assets/
    └── css/            # Custom styles (standard)
```

### What You Create (Plugin-Specific)

For each plugin, you will create:

```
docs/
├── index.md             # Home page (plugin-specific)
├── README.md            # Development instructions (plugin-specific)
├── _pages/              # Documentation pages (all plugin-specific)
│   ├── quick-start.md
│   ├── why-{plugin}.md
│   ├── specifications.md
│   ├── examples.md
│   ├── tools.md
│   ├── best-practices.md
│   ├── cheatsheet.md
│   └── migration-guide.md (optional)
└── assets/
    └── images/
        └── logo.png     # Plugin logo
```

---

## Phase 1: Configuration

### Step 1.1: Update `_config.yml`

**What to customize** (keep everything else as-is):

```yaml
title: {PLUGIN_NAME}
description: {PLUGIN_DESCRIPTION}
repository: {GITHUB_USER}/{PLUGIN_REPO}

# Update header navigation
header_pages:
  - index.md
  - _pages/quick-start.md
  - _pages/why-{plugin}.md
  - _pages/specifications.md
  - _pages/examples.md
  - _pages/tools.md
```

**Placeholders to replace**:
- `{PLUGIN_NAME}` → e.g., "YMD-Spec", "Semantic Docstrings", "Code-Zen"
- `{PLUGIN_DESCRIPTION}` → Brief description (1-2 sentences)
- `{GITHUB_USER}/{PLUGIN_REPO}` → GitHub repository path
- `{plugin}` → Plugin name in kebab-case (e.g., "ymd-spec", "semantic-docstrings")

### Step 1.2: Add Plugin Logo

```bash
# Place logo in assets/images/
cp /path/to/logo.png docs/assets/images/logo.png
```

**Requirements**:
- Format: PNG (transparent background preferred)
- Size: ~300-400px width
- Name: `logo.png`

---

## Phase 2: Home Page (`index.md`)

### Template

```markdown
---
layout: home
title: Home
---
<img src="assets/images/logo.png" alt="{PLUGIN_NAME} Logo" align="left" style="width: 300px; margin-left: -30px; margin-top:-30px; box-shadow:none;"/>

# {PLUGIN_NAME}

<blockquote style="border: none;">
  <p><strong>{PLUGIN_TAGLINE}</strong></p>
</blockquote>

{PLUGIN_DESCRIPTION_EXPANDED}

```
{PLUGIN_ASCII_ART}
```

<br clear="left"/>

---

## Quick Start

### One-Line Installation

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/{GITHUB_USER}/{PLUGIN_REPO}/main/install.sh)"
```

{INSTALLATION_DETAILS}

---

## Why {PLUGIN_NAME}?

### Problems Solved

{LIST_PROBLEMS}

### With {PLUGIN_NAME}

{LIST_SOLUTIONS}

[Learn more →]({% link _pages/why-{plugin}.md %})

---

## What is {PLUGIN_NAME}?

{PLUGIN_EXPLANATION}

### Core Concept

{CORE_CONCEPT_EXPLANATION}

### {PLUGIN_SPECIFIC_DIAGRAM}

[Full specifications →]({% link _pages/specifications.md %})

---

## Documentation

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0;">

<div style="border: 1px solid #ddd; padding: 15px; border-radius: 5px;">
<h3>Quick Start</h3>
<p>{QUICK_START_DESCRIPTION}</p>
<a href="{% link _pages/quick-start.md %}">Get Started →</a>
</div>

<div style="border: 1px solid #ddd; padding: 15px; border-radius: 5px;">
<h3>Why {PLUGIN_NAME}?</h3>
<p>{WHY_DESCRIPTION}</p>
<a href="{% link _pages/why-{plugin}.md %}">Learn Why →</a>
</div>

<div style="border: 1px solid #ddd; padding: 15px; border-radius: 5px;">
<h3>Specifications</h3>
<p>{SPECS_DESCRIPTION}</p>
<a href="{% link _pages/specifications.md %}">Read Specs →</a>
</div>

<div style="border: 1px solid #ddd; padding: 15px; border-radius: 5px;">
<h3>Examples</h3>
<p>{EXAMPLES_DESCRIPTION}</p>
<a href="{% link _pages/examples.md %}">See Examples →</a>
</div>

<div style="border: 1px solid #ddd; padding: 15px; border-radius: 5px;">
<h3>Tools & Scripts</h3>
<p>{TOOLS_DESCRIPTION}</p>
<a href="{% link _pages/tools.md %}">View Tools →</a>
</div>

</div>

---

## Tools & Integration

### Validation Scripts

{PLUGIN_VALIDATION_SCRIPTS}

### Specialized Agents

{PLUGIN_AGENTS}

### Claude Code Commands

{PLUGIN_COMMANDS}

[Full tool documentation →]({% link _pages/tools.md %})

---

## Community

### Contribute

{CONTRIBUTION_GUIDELINES}

### Philosophy

> "{PLUGIN_PHILOSOPHY_QUOTE}"

{PHILOSOPHY_EXPLANATION}

---

## Get Started

1. [Install {PLUGIN_NAME}](#quick-start)
2. [Follow Quick Start Guide]({% link _pages/quick-start.md %})
3. [Explore Examples]({% link _pages/examples.md %})

**Ready to {CALL_TO_ACTION}?** [Get Started →]({% link _pages/quick-start.md %})
```

### Placeholders Guide

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{PLUGIN_NAME}` | Full plugin name | "YMD-Spec" |
| `{PLUGIN_TAGLINE}` | Short tagline | "Structured, modular AI prompts" |
| `{PLUGIN_DESCRIPTION_EXPANDED}` | 2-3 sentence description | "YMD/PMD provides..." |
| `{PLUGIN_ASCII_ART}` | Visual representation | Gradient bars, file structure, etc. |
| `{GITHUB_USER}/{PLUGIN_REPO}` | GitHub path | "daviguides/ymd-spec" |
| `{plugin}` | Lowercase kebab-case | "ymd-spec" |
| `{LIST_PROBLEMS}` | Bullet list of problems | "- Duplication\n- Complexity" |
| `{LIST_SOLUTIONS}` | Bullet list of solutions | "- Zero duplication\n- Clear structure" |
| `{CALL_TO_ACTION}` | Action phrase | "eliminate duplication", "write better docs" |

---

## Phase 3: Essential Pages

### Page 1: `quick-start.md`

**Purpose**: Get users started in 10-15 minutes

**Template**:
```markdown
---
layout: page
title: Quick Start
nav_order: 2
permalink: /quick-start/
---

# Quick Start Guide

Get your first {PLUGIN_NAME} {PROJECT_TYPE} running in 10 minutes.

---

## Installation

### One-Line Install

```bash
{INSTALLATION_COMMAND}
```

**What it does**:
{INSTALLATION_EXPLANATION}

### Manual Install

{MANUAL_INSTALLATION_STEPS}

### Verify Installation

```bash
{VERIFICATION_COMMAND}
```

**Expected**:
{EXPECTED_OUTPUT}

---

## Your First {PROJECT_TYPE}

### Step 1: {FIRST_STEP_TITLE}

{FIRST_STEP_INSTRUCTIONS}

**Result**:
{FIRST_STEP_RESULT}

### Step 2: {SECOND_STEP_TITLE}

{SECOND_STEP_INSTRUCTIONS}

### Step 3: {THIRD_STEP_TITLE}

{THIRD_STEP_INSTRUCTIONS}

### Step 4: {FOURTH_STEP_TITLE}

{FOURTH_STEP_INSTRUCTIONS}

### Step 5: {FIFTH_STEP_TITLE}

{FIFTH_STEP_INSTRUCTIONS}

---

## Validate Your {PROJECT_TYPE}

{VALIDATION_INSTRUCTIONS}

---

## Load Context in Claude Code

### Use Your Command

{COMMAND_USAGE_EXAMPLE}

### Test It

{TEST_INSTRUCTIONS}

---

## Common Patterns

### Pattern 1: {PATTERN_1_NAME}

**When**: {PATTERN_1_USE_CASE}

**Structure**:
{PATTERN_1_STRUCTURE}

### Pattern 2: {PATTERN_2_NAME}

{PATTERN_2_DETAILS}

### Pattern 3: {PATTERN_3_NAME}

{PATTERN_3_DETAILS}

---

## Troubleshooting

{COMMON_ISSUES_AND_SOLUTIONS}

---

## Resources

{LINKS_TO_OTHER_PAGES}

---

**Ready to build?** {CLOSING_CTA}
```

### Page 2: `why-{plugin}.md`

**Purpose**: Explain problems solved and philosophy

**Template**:
```markdown
---
layout: page
title: Why {PLUGIN_NAME}?
nav_order: 3
permalink: /why-{plugin}/
---

# Why {PLUGIN_NAME}?

Understanding the problems that {PLUGIN_NAME} solves and the philosophy behind its design.

---

## The Problem: {MAIN_PROBLEM_TITLE}

### Symptom: {SYMPTOM_1}

{PROBLEM_DESCRIPTION_WITH_DIAGRAM}

```mermaid
{PROBLEM_VISUALIZATION}
```

**Real-world impact**:
{IMPACT_LIST}

### Symptom: {SYMPTOM_2}

{SYMPTOM_2_DESCRIPTION}

### Symptom: {SYMPTOM_3}

{SYMPTOM_3_DESCRIPTION}

---

## The {PLUGIN_NAME} Solution

### {SOLUTION_1_TITLE}

{SOLUTION_1_DESCRIPTION_WITH_DIAGRAM}

```mermaid
{SOLUTION_1_VISUALIZATION}
```

**Benefits**:
{BENEFITS_LIST}

### {SOLUTION_2_TITLE}

{SOLUTION_2_DESCRIPTION}

### {SOLUTION_3_TITLE}

{SOLUTION_3_DESCRIPTION}

---

## Before and After: Real-World Impact

### Case Study: {CASE_STUDY_NAME}

**Before {PLUGIN_NAME}**:

{BEFORE_STATE}

**Issues**:
{ISSUES_LIST}

**After {PLUGIN_NAME}**:

{AFTER_STATE}

**Results**:
{RESULTS_LIST}

**Metrics Comparison**:

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
{METRICS_TABLE}

---

## The Philosophy: {PHILOSOPHY_TITLE}

{PHILOSOPHY_EXPLANATION}

---

## Key Benefits Summary

### For {AUDIENCE_1}

{BENEFITS_FOR_AUDIENCE_1}

### For {AUDIENCE_2}

{BENEFITS_FOR_AUDIENCE_2}

### For {AUDIENCE_3}

{BENEFITS_FOR_AUDIENCE_3}

---

## When You Need {PLUGIN_NAME}

### Ideal Use Cases

{IDEAL_USE_CASES}

### When {PLUGIN_NAME} is Overkill

{WHEN_NOT_TO_USE}

**Rule of thumb**: {DECISION_RULE}

---

## Next Steps

{LINKS_TO_NEXT_PAGES}

---

**Key Insight**: {KEY_TAKEAWAY}
```

### Page 3: `specifications.md`

**Purpose**: Technical specifications overview

**Template**: Similar structure to Gradient's specifications.md, adapted for plugin's specific layers/components.

### Page 4: `examples.md`

**Purpose**: Real-world implementations

**Template**: Showcase actual usage examples, architecture diagrams, directory structures.

### Page 5: `tools.md`

**Purpose**: Scripts, agents, commands documentation

**Template**: Document validation scripts, specialized agents, Claude Code commands specific to the plugin.

---

## Phase 4: Complementary Pages (Optional)

### Page 6: `best-practices.md`

**Purpose**: Guidelines, anti-patterns, decision frameworks

**When to include**: For plugins with complex usage patterns or common mistakes

### Page 7: `cheatsheet.md`

**Purpose**: Quick reference

**When to include**: For plugins with many commands, options, or syntax

### Page 8: `migration-guide.md`

**Purpose**: Refactoring existing projects

**When to include**: When users have existing projects to migrate

---

## Execution Checklist

### Pre-Creation

- [ ] Standard files provided (_config.yml, Gemfile, layouts, etc.)
- [ ] Plugin logo prepared (300-400px PNG)
- [ ] Plugin information gathered:
  - [ ] Name, tagline, description
  - [ ] Installation command
  - [ ] GitHub repository path
  - [ ] Core concepts and philosophy
  - [ ] Problems solved
  - [ ] Target audience
  - [ ] Example usage

### Phase 1: Configuration

- [ ] Update `_config.yml` (title, description, repository, navigation)
- [ ] Add logo to `assets/images/logo.png`
- [ ] Update `Gemfile` if needed (usually no changes)

### Phase 2: Home Page

- [ ] Create `index.md` from template
- [ ] Replace all placeholders
- [ ] Add plugin-specific ASCII art or visualization
- [ ] Create Mermaid diagrams if needed
- [ ] Add documentation grid with all pages

### Phase 3: Essential Pages

- [ ] Create `_pages/quick-start.md`
  - [ ] 5-step tutorial with code examples
  - [ ] Validation instructions
  - [ ] Common patterns (3+)
  - [ ] Troubleshooting section

- [ ] Create `_pages/why-{plugin}.md`
  - [ ] 3+ problems with diagrams
  - [ ] 3+ solutions with diagrams
  - [ ] Before/after case study with metrics
  - [ ] Philosophy section

- [ ] Create `_pages/specifications.md`
  - [ ] Complete technical specifications
  - [ ] Layer descriptions (if applicable)
  - [ ] Mermaid diagrams for architecture

- [ ] Create `_pages/examples.md`
  - [ ] 3+ real-world examples
  - [ ] Directory structures
  - [ ] Code snippets
  - [ ] Architecture diagrams

- [ ] Create `_pages/tools.md`
  - [ ] All validation scripts documented
  - [ ] All agents documented
  - [ ] All commands documented
  - [ ] Usage examples

### Phase 4: Complementary Pages (if applicable)

- [ ] Create `_pages/best-practices.md` (if needed)
- [ ] Create `_pages/cheatsheet.md` (if needed)
- [ ] Create `_pages/migration-guide.md` (if needed)

### Phase 5: Development README

- [ ] Create `docs/README.md`
  - [ ] Local development instructions
  - [ ] Site structure
  - [ ] Content guidelines
  - [ ] Contributing instructions

### Phase 6: Validation

- [ ] Test locally: `bundle exec jekyll serve`
- [ ] Check all internal links work
- [ ] Verify all Mermaid diagrams render
- [ ] Check navigation menu
- [ ] Review mobile responsiveness
- [ ] Validate all code examples
- [ ] Proofread all content

### Phase 7: Deployment

- [ ] Commit all files
- [ ] Push to GitHub
- [ ] Enable GitHub Pages (if applicable)
- [ ] Verify online deployment
- [ ] Update main README with docs link

---

## Content Guidelines

### Writing Style

**Do**:
- Use smart brevity (scannable, dense information)
- Write technical, precise content
- Use Mermaid diagrams abundantly
- Include complete, working code examples
- Provide before/after comparisons
- Add real-world metrics when possible

**Don't**:
- Use emojis (unless plugin-specific style requires it)
- Write marketing fluff
- Include incomplete examples
- Skip error handling in examples
- Duplicate content across pages

### Mermaid Diagrams

**Standard color palette**:
```
SPECS/Definitions:  #e74c3c (red)
CONTEXT/Applied:    #f39c12 (orange)
PROMPTS/Action:     #27ae60 (green)
COMMANDS/API:       #3498db (blue)
AGENTS/Specialized: #9b59b6 (purple)
SCRIPTS/Tools:      #95a5a6 (gray)
HOOKS/Events:       #34495e (dark gray)
```

**Use diagrams for**:
- Architecture visualization
- Flow diagrams (before/after)
- Decision trees
- Component relationships
- File structures

### Code Examples

**All code examples must**:
- Be complete (not snippets)
- Include comments explaining key parts
- Show expected output
- Include error handling where relevant
- Follow language best practices
- Be tested and working

---

## Adaptation Examples

### Example 1: YMD-Spec Plugin

**Original placeholders**:
```
{PLUGIN_NAME} → YMD-Spec
{PLUGIN_TAGLINE} → Structured, modular AI prompts
{plugin} → ymd-spec
{PROJECT_TYPE} → YMD/PMD file
{GITHUB_USER}/{PLUGIN_REPO} → daviguides/ymd-spec
```

**Quick Start adaptations**:
- Step 1: Create YMD manifest
- Step 2: Add PMD components
- Step 3: Validate composition
- Pattern 1: Simple YMD
- Pattern 2: Multi-PMD composition

### Example 2: Semantic Docstrings Plugin

**Original placeholders**:
```
{PLUGIN_NAME} → Semantic Docstrings
{PLUGIN_TAGLINE} → Documentation as a semantic layer
{plugin} → semantic-docstrings
{PROJECT_TYPE} → Python module with semantic docstrings
{GITHUB_USER}/{PLUGIN_REPO} → daviguides/semantic-docstrings
```

**Quick Start adaptations**:
- Step 1: Load semantic context
- Step 2: Add module docstring
- Step 3: Add class docstrings
- Step 4: Add function docstrings
- Pattern 1: Module documentation
- Pattern 2: Class documentation

---

## Common Mistakes to Avoid

### Configuration

- ❌ Forgetting to update navigation in `_config.yml`
- ❌ Wrong repository path
- ❌ Inconsistent plugin name across files

### Content

- ❌ Broken internal links
- ❌ Missing frontmatter in pages
- ❌ Placeholders left unreplaced
- ❌ Incomplete code examples
- ❌ Missing Mermaid diagram syntax tags

### Structure

- ❌ Pages not in `_pages/` directory
- ❌ Wrong permalink format
- ❌ Missing `nav_order` in frontmatter
- ❌ Assets not in `assets/` directory

---

## Testing Locally

### Quick Test

```bash
cd docs
bundle exec jekyll serve
# Visit http://localhost:4000
```

**Check**:
- [ ] All pages load
- [ ] Navigation works
- [ ] Internal links work
- [ ] Mermaid diagrams render
- [ ] Images load
- [ ] Mobile view works
- [ ] No broken links

### Build Test

```bash
cd docs
bundle exec jekyll build
# Check _site/ directory for output
```

**Validate**:
- [ ] No build errors
- [ ] All pages generated
- [ ] Assets copied correctly

---

## Deployment

### GitHub Pages

1. Enable in repository settings
2. Set source to `main` branch, `/docs` folder
3. Wait for deployment (1-2 minutes)
4. Access at `https://{GITHUB_USER}.github.io/{PLUGIN_REPO}/`

### Custom Domain (Optional)

1. Add `CNAME` file to `docs/`:
   ```
   docs.example.com
   ```

2. Configure DNS:
   ```
   CNAME record: docs → {GITHUB_USER}.github.io
   ```

3. Update `_config.yml`:
   ```yaml
   url: "https://docs.example.com"
   baseurl: ""
   ```

---

## Maintenance

### Regular Updates

- Update examples when plugin changes
- Keep metrics current
- Add new use cases as they emerge
- Fix broken links
- Update screenshots/diagrams

### Version-Specific Docs

For major version changes:
- Create versioned documentation
- Maintain compatibility guides
- Link to previous versions

---

## Resources

### Jekyll & Plugins

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [Minima Theme](https://github.com/jekyll/minima)
- [Jekyll Spaceship](https://github.com/jeffreytse/jekyll-spaceship)

### Diagrams & Visualization

- [Mermaid Documentation](https://mermaid.js.org/)
- [Mermaid Live Editor](https://mermaid.live/)

### Writing & Style

- [Smart Brevity Guide](https://www.axios.com/about/smart-brevity)
- [Technical Writing Best Practices](https://developers.google.com/tech-writing)

---

## Summary

This document provides everything needed to create complete, professional Jekyll documentation for any Gradient plugin. Follow the phases sequentially, replace all placeholders with plugin-specific content, and validate thoroughly before deployment.

**Key Success Factors**:
1. Use templates consistently
2. Replace ALL placeholders
3. Include working code examples
4. Add abundant Mermaid diagrams
5. Test locally before deploying
6. Follow Gradient architecture principles in documentation structure

**Result**: Professional, maintainable documentation site that helps users understand, install, and use your plugin effectively.
