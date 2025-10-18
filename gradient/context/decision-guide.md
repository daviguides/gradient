# Gradient Decision Guide

**Decision trees and guidance for making architectural choices when implementing Gradient.**

For architecture specifications: @~/.claude/gradient/spec/architecture-spec.md
For layer specifications: @~/.claude/gradient/spec/layer-spec.md

---

## Table of Contents

1. [Layer Assignment Decisions](#layer-assignment-decisions)
2. [Reference vs Inline Decisions](#reference-vs-inline-decisions)
3. [File Organization Decisions](#file-organization-decisions)
4. [Duplication Resolution Decisions](#duplication-resolution-decisions)
5. [Prompt Design Decisions](#prompt-design-decisions)
6. [Agent Creation Decisions](#agent-creation-decisions)
7. [Migration Strategy Decisions](#migration-strategy-decisions)

---

## Layer Assignment Decisions

### Decision 1: Where Does This Content Belong?

**Question**: I have content to add - which layer should it go in?

#### Decision Tree

```
Start: I have content about [X]
│
├─ Is it a normative definition or rule?
│  ├─ YES: Does it define WHAT something is?
│  │  └─ YES → SPECS layer
│  │      File: project/spec/*-spec.md
│  │
│  └─ NO: Continue...
│
├─ Is it a working example or practical guide?
│  ├─ YES: Does it show HOW to apply rules?
│  │  └─ YES → CONTEXT layer
│  │      File: context/examples.md or context/*-guide.md
│  │
│  └─ NO: Continue...
│
├─ Is it orchestration or meta-instructions?
│  ├─ YES: Does it load context and guide LLM?
│  │  └─ YES → PROMPTS layer
│  │      File: prompts/load-*.md or prompts/*-workflow.md
│  │
│  └─ NO: Continue...
│
├─ Is it an API entry point?
│  ├─ YES: Does it just reference a prompt?
│  │  └─ YES → COMMANDS layer
│  │      File: commands/command-name.md
│  │
│  └─ NO: Continue...
│
├─ Is it a specialized context?
│  ├─ YES: Does it need isolated execution?
│  │  └─ YES → AGENTS layer
│  │      File: agents/agent-name.md
│  │
│  └─ NO: Continue...
│
└─ Is it code/automation?
   └─ YES → SCRIPTS layer
       File: scripts/script-name.sh
```

#### Quick Reference Table

| Content Type | Layer | File Pattern |
|--------------|-------|--------------|
| Format definition | SPECS | `*-spec.md` |
| Validation rules | SPECS | `*-spec.md` |
| Foundational principles | SPECS | `*-principles.md` |
| Working examples | CONTEXT | `examples.md` |
| Implementation steps | CONTEXT | `implementation-guide.md` |
| Decision guidance | CONTEXT | `decision-guide.md` |
| Context loader | PROMPTS | `load-context.md` |
| Multi-step workflow | PROMPTS | `*-workflow.md` |
| User command | COMMANDS | `command-name.md` |
| Specialized task | AGENTS | `agent-name.md` |
| Validation script | SCRIPTS | `validate-*.sh` |

### Decision 2: Should I Create a New File or Add to Existing?

#### Create New File When:

- New domain/concept unrelated to existing files
- Existing file would exceed 500 lines
- Content has different audience (LLMs vs humans)
- Separation improves maintainability

**Example**: You have `format-spec.md` (300 lines) and need to add validation rules (250 lines).

**Decision**: Create `validation-spec.md` (separate concern)

#### Add to Existing File When:

- Content naturally extends existing topic
- File is under 300 lines
- Concept is tightly coupled with existing content
- Separation would create artificial boundaries

**Example**: You have `format-spec.md` (150 lines) and need to add format validation rules (50 lines).

**Decision**: Add to `format-spec.md` (tightly coupled)

### Decision 3: Specs vs Context - Borderline Cases

**Scenario**: Content seems like it could go in either SPECS or CONTEXT.

#### Use SPECS If:

- Defines normative rules ("MUST", "SHALL", "SHOULD")
- Provides complete definition of concept
- Is authoritative source of truth
- Other files will reference this definition
- Answers "WHAT is it?"

**Example**:
```markdown
# In SPECS
## Email Validation Rule

Email addresses MUST match RFC 5322 format:
- Local part (before @)
- @ symbol
- Domain part (after @)
- Valid TLD

Pattern: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
```

#### Use CONTEXT If:

- Shows how to apply rules
- Provides working examples
- Offers implementation guidance
- Presents decision trees
- Answers "HOW do I use it?"

**Example**:
```markdown
# In CONTEXT
## Email Validation Examples

For validation rules: @~/.claude/gradient/project/spec/validation-spec.md

### Valid Emails
- user@example.com ✓
- test.email@subdomain.domain.co.uk ✓
- user+tag@domain.org ✓

### Invalid Emails
- invalid (missing @) ✗
- @domain.com (missing local part) ✗
- user@domain (missing TLD) ✗
```

---

## Reference vs Inline Decisions

### Decision 4: Should I Reference or Write Inline?

#### Decision Tree

```
Start: I need content about [X]
│
├─ Does this content exist elsewhere?
│  ├─ YES: Is it normative (in SPECS)?
│  │  └─ YES → Use @reference
│  │
│  ├─ YES: Is it an example (in CONTEXT)?
│  │  └─ YES → Use @reference
│  │
│  └─ NO: Continue...
│
├─ Is this content <5 lines AND contextual?
│  ├─ YES: Does it add unique value here?
│  │  └─ YES → Write inline (exception)
│  │
│  └─ NO: Continue...
│
├─ Will this content be reused elsewhere?
│  ├─ YES → Create in appropriate layer, then @reference
│  │
│  └─ NO: Is it >5 lines?
│     ├─ YES → Extract to appropriate layer, then @reference
│     └─ NO → Write inline (exception)
```

#### Quick Guidelines

**Always Reference** (use `@`):
- Normative definitions from SPECS
- Complete examples from CONTEXT
- Validation rules from SPECS
- Implementation patterns from CONTEXT
- Any content >5 lines

**Sometimes Inline** (write directly):
- Brief reminders (<5 lines)
- Context-specific notes
- Meta-instructions in prompts
- Transition text between references

**Never Inline**:
- Complete spec definitions
- Working code examples (>10 lines)
- Repeated content
- Content that exists elsewhere

### Decision 5: Creating vs Referencing Existing

**Scenario**: You need content, but you're not sure if it exists.

#### Process:

**Step 1: Search existing content**
```bash
grep -r "concept name" project/spec/ context/ --include="*.md"
```

**Step 2: Evaluate results**

| Result | Action |
|--------|--------|
| Found in SPECS | Use `@reference` to specs |
| Found in CONTEXT | Use `@reference` to context |
| Found in PROMPTS | Don't reference prompts from other layers |
| Not found | Create in appropriate layer |
| Found in multiple places | **RED FLAG** - consolidate to SSOT first |

**Step 3: If creating new content**

1. Determine appropriate layer (see Decision 1)
2. Create in that layer
3. Reference from wherever you need it

---

## File Organization Decisions

### Decision 6: File Naming Strategy

#### For SPECS:

**Pattern**: `[domain]-spec.md` or `[domain]-principles.md`

**Choose `-spec.md` when**:
- Defining format or structure
- Specifying validation rules
- Documenting standards

**Examples**: `format-spec.md`, `validation-spec.md`, `api-spec.md`

**Choose `-principles.md` when**:
- Documenting foundational philosophy
- Defining universal guidelines
- Establishing core values

**Examples**: `anti-duplication-principles.md`, `architecture-principles.md`

#### For CONTEXT:

**Pattern**: `[topic]-guide.md` or `examples.md` or `patterns.md`

**Choose `examples.md` when**:
- Single file for all examples works
- Project has <10 example scenarios
- Examples span multiple domains

**Choose `[topic]-examples.md` when**:
- Need separation by domain
- Project has many examples
- Each domain has 5+ examples

**Examples**: `format-examples.md`, `validation-examples.md`

**Choose `[topic]-guide.md` when**:
- Providing step-by-step guidance
- Documenting implementation approach
- Offering decision support

**Examples**: `implementation-guide.md`, `decision-guide.md`, `migration-guide.md`

#### For PROMPTS:

**Pattern**: `load-[scope].md` or `[action]-workflow.md`

**Choose `load-*.md` when**:
- Primary purpose is loading context
- Minimal orchestration logic
- Straightforward context assembly

**Examples**: `load-context.md`, `load-format-context.md`

**Choose `*-workflow.md` when**:
- Multi-step process guidance
- Complex orchestration
- Sequential task execution

**Examples**: `create-workflow.md`, `validation-workflow.md`

### Decision 7: File Splitting Strategy

**Question**: When should I split one file into multiple?

#### Split When:

**Size threshold exceeded**:
- SPECS: >500 lines
- CONTEXT: >500 lines
- PROMPTS: >200 lines

**Multiple distinct concerns**:
```
# Instead of single all-in-one-spec.md (800 lines)
project/spec/
├── format-spec.md      (300 lines)
├── validation-spec.md  (250 lines)
└── api-spec.md         (250 lines)
```

**Different audiences**:
```
# LLMs vs Humans
├── project/spec/       # For LLMs
│   └── core-spec.md
└── docs/               # For Humans
    └── user-guide.md
```

**Different usage patterns**:
```
# Frequently loaded separately
prompts/
├── load-format-only.md
├── load-validation-only.md
└── load-complete.md
```

#### Keep Together When:

- Total file <300 lines
- Concepts tightly coupled
- Always loaded together
- Splitting creates artificial boundaries

### Decision 8: Directory Structure Depth

**Question**: Should I use nested directories or flat structure?

#### Flat Structure (Recommended for Most Projects)

```
project/spec/
├── format-spec.md
├── validation-spec.md
└── api-spec.md
```

**Use when**:
- <10 files per directory
- Simple project structure
- No clear subdomain separation

#### Nested Structure

```
project/spec/
├── core/
│   ├── format-spec.md
│   └── validation-spec.md
├── advanced/
│   ├── composition-spec.md
│   └── extensions-spec.md
└── api/
    ├── rest-spec.md
    └── graphql-spec.md
```

**Use when**:
- >10 files per directory
- Clear subdomain separation
- Complex project with multiple areas
- Team organization matches structure

**Guideline**: Start flat, nest only when necessary.

---

## Duplication Resolution Decisions

### Decision 9: Identifying SSOT

**Scenario**: Content exists in multiple files - which is the SSOT?

#### Decision Process:

**Step 1: Classify content type**
- Normative definition? → SSOT should be SPECS
- Example/pattern? → SSOT should be CONTEXT
- Orchestration? → SSOT should be PROMPTS

**Step 2: Evaluate completeness**
- Which file has the most complete version?
- Which file has the most accurate version?
- Which file is most up-to-date?

**Step 3: Evaluate location**
- Is it in the correct layer?
- Is it in a file with appropriate scope?
- Would other files naturally reference this location?

#### Example:

**Found in 3 files**:
```
1. README.md (lines 50-100): Brief overview
2. docs/guide.md (lines 1-150): Complete definition with examples
3. prompts/load.md (lines 10-60): Partial definition
```

**Analysis**:
- Type: Normative definition → Should be in SPECS
- Completeness: guide.md most complete
- Location: None are in correct layer (SPECS)

**Decision**:
1. Create `project/spec/format-spec.md` with complete definition
2. Replace README.md content with `@~/.claude/gradient/project/spec/format-spec.md`
3. Extract examples from guide.md to `context/examples.md`
4. Update guide.md to reference both
5. Replace prompts/load.md content with `@~/.claude/gradient/project/spec/format-spec.md`

### Decision 10: Consolidation Strategy

**Question**: Multiple files need consolidation - how to approach?

#### Strategy A: Create New SSOT

**When**:
- No existing file is in correct layer
- All existing versions are incomplete
- Fresh start is cleaner

**Process**:
1. Create new file in correct layer
2. Consolidate all unique content
3. Replace all instances with `@reference`
4. Validate no content lost

#### Strategy B: Promote Existing to SSOT

**When**:
- One file is mostly correct and complete
- File is already in correct layer
- Incremental improvement is better

**Process**:
1. Identify best existing file
2. Move to correct location if needed
3. Enhance with any missing content
4. Replace other instances with `@reference`
5. Validate completeness

#### Strategy C: Eliminate Duplication

**When**:
- Clear SSOT already exists
- Other files are pure duplication
- No unique content in duplicates

**Process**:
1. Verify SSOT is complete
2. Replace duplicates with `@reference`
3. Delete files if they become empty
4. Update all references

---

## Prompt Design Decisions

### Decision 11: Granular vs Comprehensive Loading

**Question**: Should I create one prompt that loads everything or multiple prompts for specific contexts?

#### Granular Loading (Multiple Prompts)

```
prompts/
├── load-format-context.md
├── load-validation-context.md
└── load-api-context.md
```

**Use when**:
- Different use cases need different context
- Performance matters (avoid loading unnecessary content)
- Clear separation between domains
- Users will typically need specific areas

**Example**: Plugin with format, validation, and API specs where users typically work on one area at a time.

#### Comprehensive Loading (Single Prompt)

```
prompts/
└── load-complete-context.md
```

**Use when**:
- All context usually needed together
- Project is small (<5 specs, <5 context files)
- Context is tightly integrated
- Performance is not a concern

**Example**: Simple validation plugin where format, rules, and examples are always used together.

#### Hybrid Approach (Recommended)

```
prompts/
├── load-format-context.md      # Specific
├── load-validation-context.md  # Specific
├── load-api-context.md         # Specific
└── load-complete-context.md    # Comprehensive
```

**Benefits**:
- Flexibility for different use cases
- Performance optimization available
- Comprehensive option for complex tasks

### Decision 12: Prompt Complexity

**Question**: How much orchestration logic should a prompt contain?

#### Minimal Orchestration

```markdown
# Load Context

@~/.claude/gradient/project/spec/core-spec.md
@~/.claude/gradient/context/examples.md

Your task: Guide users in creating files following the spec.
```

**Use when**:
- Context is self-explanatory
- LLM can infer workflow
- Simple use case
- Minimal guidance needed

#### Moderate Orchestration

```markdown
# Create Workflow

@~/.claude/gradient/project/spec/format-spec.md
@~/.claude/gradient/context/implementation-guide.md

Your task:
1. Gather requirements from user
2. Generate structure following format-spec.md
3. Validate against spec
4. Present result

Remember:
- Reference spec for validation criteria
- Use implementation-guide.md for patterns
```

**Use when**:
- Multi-step process
- Specific workflow order matters
- Users need structured guidance
- Clear reminders help consistency

#### Detailed Orchestration

```markdown
# Complex Workflow

@~/.claude/gradient/project/spec/core-spec.md
@~/.claude/gradient/context/implementation-guide.md
@~/.claude/gradient/context/decision-guide.md

Your task: [Detailed steps]

Step 1: [Specific instructions]
- [Sub-step A]
- [Sub-step B]

Step 2: [More instructions]
- [Sub-step A]
- [Sub-step B]

Decision points:
- If [condition], use [pattern A]
- If [condition], use [pattern B]

Validation checklist:
- [ ] [Item 1]
- [ ] [Item 2]
```

**Use when**:
- Complex multi-step process
- Many decision points
- High error risk without guidance
- Consistency is critical

**Caution**: Even detailed orchestration should maintain >50% reference density. If exceeding this, extract to CONTEXT.

---

## Agent Creation Decisions

### Decision 13: Agent vs Prompt

**Question**: Should I create an agent or just use a prompt?

#### Create Agent When:

- **Isolated execution needed**: Should run separately from main context
- **Different permissions**: Needs access to different tools
- **Specialized expertise**: Requires focused, deep knowledge
- **Background processing**: Long-running or asynchronous tasks
- **Summarized results**: Should return condensed findings
- **Spin-off analysis**: Separate analysis that shouldn't pollute main context

**Examples**:
- Architecture reviewer agent
- Code validator agent
- Performance analyzer agent

#### Use Prompt When:

- **Main workflow**: Part of user's primary task
- **Integrated context**: Needs access to full conversation
- **Interactive**: User will provide multiple inputs
- **Direct output**: Results directly shown to user
- **Simple orchestration**: Just loading and organizing context

**Examples**:
- Create workflow prompt
- Validation workflow prompt
- Load context prompt

### Decision 14: Agent Specialization

**Question**: How specialized should an agent be?

#### Highly Specialized

**Scope**: Single, focused task

**Example**:
```markdown
# YAML Validator Agent

You are a YAML syntax validator.

@~/.claude/gradient/project/spec/yaml-spec.md

Validate ONLY syntax. Do not check:
- Business logic
- Semantic meaning
- Integration concerns
```

**Use when**:
- Clear, bounded task
- Reusable across contexts
- Performance critical
- Want consistent results

#### Moderately Specialized

**Scope**: Related set of tasks

**Example**:
```markdown
# Format Validator Agent

You validate format compliance.

@~/.claude/gradient/project/spec/format-spec.md
@~/.claude/gradient/project/spec/validation-spec.md

Validate:
- Structure compliance
- Field presence
- Type correctness
- Format rules
```

**Use when**:
- Tasks naturally group together
- Shared context beneficial
- Reasonable scope
- Balance between focus and flexibility

#### Broadly Specialized

**Scope**: Domain expert

**Example**:
```markdown
# Architecture Expert Agent

You are an architecture reviewer.

@~/.claude/gradient/spec/architecture-spec.md
@~/.claude/gradient/spec/anti-duplication-principles.md
@~/.claude/gradient/spec/layer-spec.md

Review all aspects of architecture:
- Structure
- Duplication
- References
- Layer boundaries
- Naming conventions
```

**Use when**:
- Domain requires holistic view
- Multiple aspects interconnected
- Expert judgment needed
- Trade-offs must be balanced

**Guideline**: Start specialized, broaden only if necessary.

---

## Migration Strategy Decisions

### Decision 15: Big Bang vs Incremental Migration

**Question**: Should I migrate entire project at once or gradually?

#### Big Bang Migration

**Approach**: Convert entire project to Gradient in one effort.

**Process**:
1. Create complete Gradient structure
2. Migrate all content at once
3. Update all references
4. Validate entire project
5. Switch over

**Use when**:
- Small project (<20 files)
- Short migration window available
- Team can pause development
- High duplication ratio (>1.5)
- Clean break preferred

**Pros**:
- Clean, consistent result
- No hybrid state
- All issues found at once

**Cons**:
- Disruptive
- High risk
- Resource intensive

#### Incremental Migration

**Approach**: Migrate layer by layer or domain by domain.

**Process (Layer by Layer)**:
1. Week 1: Migrate SPECS
2. Week 2: Migrate CONTEXT
3. Week 3: Migrate PROMPTS
4. Week 4: Migrate COMMANDS

**Process (Domain by Domain)**:
1. Sprint 1: Migrate format domain
2. Sprint 2: Migrate validation domain
3. Sprint 3: Migrate API domain

**Use when**:
- Large project (>20 files)
- Can't pause development
- Need to maintain working state
- Want to learn and adjust
- Lower risk preferred

**Pros**:
- Lower risk
- Continuous validation
- Learn and improve
- Less disruptive

**Cons**:
- Hybrid state period
- More coordination needed
- Longer timeline

**Recommendation**: For most projects, use incremental migration by layer (SPECS → CONTEXT → PROMPTS → COMMANDS).

### Decision 16: Migration Testing Strategy

**Question**: How thoroughly should I test during migration?

#### Continuous Testing

**Approach**: Test after each file migrated.

**Process**:
1. Migrate file
2. Validate references
3. Check duplication metrics
4. Test affected workflows
5. Fix issues
6. Move to next file

**Use when**:
- Critical project (production use)
- Low tolerance for errors
- Small migrations (few files)
- Want immediate feedback

#### Batch Testing

**Approach**: Test after completing each layer or domain.

**Process**:
1. Migrate all SPECS files
2. Validate entire SPECS layer
3. Test workflows using SPECS
4. Fix all SPECS issues
5. Move to CONTEXT layer

**Use when**:
- Lower criticality
- Higher error tolerance
- Large migrations (many files)
- Efficiency prioritized

#### Milestone Testing

**Approach**: Test at major milestones only.

**Process**:
1. Migrate complete layer or domain
2. Comprehensive validation
3. Full workflow testing
4. Performance testing
5. User acceptance testing

**Use when**:
- Non-critical migration
- Experimental approach
- Want to see bigger picture
- Fast iteration preferred

**Recommendation**: Use batch testing for most migrations - balance between safety and efficiency.

### Decision 17: Command Delegation vs Direct @ References

**Question**: Should files load context via slash commands or direct @ references?

#### Decision Tree

```
Start: Multiple files need same context
│
├─ How many files need this context?
│  ├─ 1-2 files → Use direct @ references (no duplication)
│  │
│  └─ 3+ files → Continue...
│
├─ How many specs/context files to load?
│  ├─ 1-4 files → Direct references acceptable
│  │
│  └─ 5+ files → Command delegation preferred
│
├─ Is this a standard pattern?
│  ├─ YES: Used across project → Command delegation
│  │
│  └─ NO: One-off case → Direct references
│
└─ What's more valuable?
   ├─ Explicitness → Direct references
   └─ Maintainability → Command delegation
```

#### Comparison Table

| Factor | Direct References | Command Delegation |
|--------|------------------|-------------------|
| DRY Compliance | ❌ Duplicates list | ✅ Single source |
| Explicitness | ✅ See all refs | ⚠️ Follow command |
| Maintenance | ⚠️ Update N files | ✅ Update 1 file |
| Indirection | ✅ None | ⚠️ One level |
| Best for | 1-2 consumers | 3+ consumers |

#### Real-World Example: Code Zen

**Scenario**: 5 guides need same context (6 spec files)

**Approach A - Direct References** (before):
```markdown
# zen-check-guide.md (50 lines with 6 refs)
@./spec/universal/code-structure-spec.md
@./spec/universal/naming-conventions-spec.md
@./spec/universal/error-handling-spec.md
@./spec/principles/zen-principles-spec.md
@./spec/python/python-language-spec.md
@./spec/python/python-style-spec.md

# zen-refactor-guide.md (duplicates same 6 refs)
# python-patterns.md (duplicates same 6 refs)
# ... (3 more files)
```
**Result**: 6 references × 5 files = **30 duplicated lines**

**Approach B - Command Delegation** (better):
```markdown
# prompts/load-python-workflow.md (SSOT - 6 refs)
@./spec/universal/code-structure-spec.md
@./spec/universal/naming-conventions-spec.md
@./spec/universal/error-handling-spec.md
@./spec/principles/zen-principles-spec.md
@./spec/python/python-language-spec.md
@./spec/python/python-style-spec.md

# zen-check-guide.md (1 line delegation)
Antes de qualquer passo:
- Execute o command /code-zen:load-python-context

# zen-refactor-guide.md (1 line delegation)
Antes de qualquer passo:
- Execute o command /code-zen:load-python-context
```
**Result**: 6 references in SSOT + 5 delegations = **11 total lines**
**Savings**: 30 - 11 = **19 lines eliminated** (63% reduction)

#### When Command Delegation Wins

**Metrics favoring command delegation**:
- Consumers: **5 files** (> 3 threshold)
- Reference list: **6 files** (> 5 threshold)
- Duplication eliminated: **19 lines**
- Maintenance points: **1** (vs 5 with direct refs)

**Trade-off**: Adds one level of indirection, but DRY benefit is substantial.

#### When Direct References Win

**Example**: Single specialized workflow
```markdown
# validate-specific-format.md
@./spec/format-spec.md
@./spec/validation-spec.md
```

**Metrics favoring direct references**:
- Consumers: **1 file** (< 3 threshold)
- Reference list: **2 files** (< 5 threshold)
- No duplication risk
- Self-contained and explicit

**Trade-off**: Minor duplication if another consumer emerges, but current state is clearest.

#### Recommendation

**Default**: Use command delegation when **3+ files** need same context.

**Override**: Use direct references when:
- Explicitness matters more than DRY
- Only 1-2 consumers exist
- Reference list is very short (<3 files)

**Important**: Both approaches are architecturally valid Gradient patterns. Choose based on:
1. Number of consumers (3+ → commands)
2. Size of reference list (5+ → commands)
3. Project philosophy (DRY vs explicitness)

---

## Summary

### Quick Decision Reference

| Question | Key Factor | Primary Decision |
|----------|------------|------------------|
| Which layer? | Content type | Normative → SPECS, Applied → CONTEXT, Orchestration → PROMPTS |
| Reference or inline? | Exists elsewhere? | Yes → Reference, No → Consider size |
| New file or existing? | Size & coupling | >500 lines → Split, Tightly coupled → Combine |
| Flat or nested? | Number of files | <10 → Flat, >10 → Consider nesting |
| SSOT location? | Content type | Normative → SPECS, Examples → CONTEXT |
| Granular or comprehensive? | Usage pattern | Specific needs → Granular, Always together → Comprehensive |
| Agent or prompt? | Isolation need | Separate execution → Agent, Integrated → Prompt |
| Migration strategy? | Project size | <20 files → Big bang, >20 files → Incremental |
| Command delegation or direct refs? | Number of consumers | 3+ consumers → Commands, 1-2 → Direct refs |

### Decision Support Resources

**For layer questions**: @~/.claude/gradient/spec/layer-spec.md
**For duplication questions**: @~/.claude/gradient/spec/anti-duplication-principles.md
**For architecture questions**: @~/.claude/gradient/spec/architecture-spec.md
**For implementation questions**: @./implementation-guide.md
**For examples**: @./examples.md

---

**Remember**: Gradient encourages smooth transitions, not rigid rules. Use your judgment, maintain SSOT principle, and adapt to your specific needs.
