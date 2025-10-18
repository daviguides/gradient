# Anti-Duplication Principles

**Universal principles for preventing duplication and verbosity in layered architectures.**

---

## Core Philosophy

### Single Source of Truth (SSOT)

**Principle**: Every piece of information must exist in exactly **one** authoritative location.

**Rationale**:
- Eliminates maintenance burden (update once, propagate everywhere)
- Prevents inconsistencies (no conflicting versions)
- Reduces cognitive load (one place to look)
- Minimizes token waste (for LLMs)

**Implementation**:
```
Information ─→ Authoritative Location ─→ References
```

Not:
```
Information ─→ Location A (copy)
           ─→ Location B (copy)
           ─→ Location C (copy)
```

---

## Detection: Symptoms of Duplication

### Red Flags

**1. Identical Content in Multiple Files**
```
❌ BAD:
specs/format.md:
  "YMD files have metadata section"

context/guide.md:
  "YMD files have metadata section"
```

**2. Paraphrased Repetition**
```
❌ BAD:
specs/format.md:
  "YMD requires meta section"

context/examples.md:
  "All YMD files must include metadata"
```

**3. Explanation Duplication**
```
❌ BAD:
specs/syntax.md:
  Explains how variables work (50 lines)

context/guide.md:
  Explains how variables work again (45 lines)
```

**4. Example Redundancy**
```
❌ BAD:
Multiple files showing the same example
with slight variations but no new insight
```

### Detection Questions

Ask yourself:
- Does this information exist elsewhere?
- Am I explaining syntax that's already in specs?
- Am I showing an example that's already documented?
- Could I reference instead of repeating?

---

## Prevention: Reference vs Duplicate

### When to Reference

Use `@` references when:
- Information is **normative** (defined elsewhere)
- Content is **explanatory** (already documented)
- Examples are **complete** (shown elsewhere)
- Rules are **authoritative** (specs exist)

**Example**:
```markdown
For format syntax, see:
@./gradient/specs/format-spec.md

For complete examples:
@./gradient/context/examples.md
```

### When to Duplicate (Exceptions)

Only duplicate when:
- **Brief inline references** (1-2 lines)
- **Context-specific interpretation** (applying general rule to specific case)
- **Cross-project boundaries** (external dependency, copy for stability)

**Example of Acceptable Inline**:
```markdown
Use snake_case for identifiers (as defined in naming-spec.md).
```

### When in Doubt

**Default**: Reference, don't duplicate.

---

## Refactoring: Eliminating Duplication

### Step 1: Identify SSOT

For duplicated content, determine:
- Which file is the **authoritative source**?
- Is it normative (SPECS) or applied (CONTEXT)?

**Decision tree**:
```
Is it a rule/definition?
├─ YES → SSOT is in SPECS
└─ NO → Is it an example/pattern?
          ├─ YES → SSOT is in CONTEXT
          └─ NO → Is it orchestration?
                    └─ YES → SSOT is in PROMPTS
```

### Step 2: Consolidate

Move all content to the SSOT location:
- Keep **most complete** version
- Merge **unique insights** from copies
- Preserve **best examples**

### Step 3: Replace with References

In all other locations:
```markdown
<!-- Before (duplicated) -->
Detailed explanation of concept XYZ...
(50 lines repeated)

<!-- After (referenced) -->
For details on concept XYZ:
@./gradient/specs/xyz-spec.md
```

### Step 4: Validate

Check that:
- All references resolve
- No information was lost
- Each concept has ONE authoritative location
- References are clear and helpful

---

## Layer-Specific Guidelines

### SPECS Layer

**Should contain**:
- Complete normative definitions
- Syntax rules
- Validation criteria
- Format specifications

**Should NOT contain**:
- Working examples (→ CONTEXT)
- Implementation guides (→ CONTEXT)
- Orchestration logic (→ PROMPTS)

**Duplication check**:
```
If SPECS explains HOW to apply (not WHAT the rule is)
  → Move to CONTEXT
If SPECS contains orchestration
  → Move to PROMPTS
```

### CONTEXT Layer

**Should contain**:
- Working examples
- Implementation patterns
- Decision trees
- Practical guidance

**Should NOT contain**:
- Syntax rules (→ SPECS)
- Format definitions (→ SPECS)
- Meta-instructions for LLMs (→ PROMPTS)

**Duplication check**:
```
If CONTEXT defines rules (not applies them)
  → Move to SPECS
If CONTEXT repeats spec syntax
  → Replace with @reference
```

### PROMPTS Layer

**Should contain**:
- `@` references to SPECS and CONTEXT
- Meta-instructions for LLMs
- Orchestration logic

**Should NOT contain**:
- Inline spec content
- Inline examples
- Any duplicated material

**Duplication check**:
```
If PROMPTS contains >5 lines of inline content
  → Extract to SPECS or CONTEXT
  → Reference with @
```

### Load Workflows

**Purpose**: Load workflows are specialized PROMPTS that serve as SSOT for context loading.

**Anti-Duplication Rules**:

**Rule 1: Absolute References Only**
```markdown
✅ CORRECT:
<!-- load-context.md -->
@~/.claude/project/spec/format-spec.md

❌ WRONG:
<!-- load-context.md -->
@./gradient/spec/format-spec.md
```

**Why**: Absolute references ensure load workflows work consistently when delegated from agents, prompts, or commands.

**Rule 2: Single Source of Truth for References**
```markdown
✅ CORRECT:
<!-- load-context.md -->
@~/.claude/project/spec/file1.md
@~/.claude/project/spec/file2.md

<!-- agent.md -->
Execute o command /project:load-context

❌ WRONG:
<!-- load-context.md -->
@~/.claude/project/spec/file1.md

<!-- agent.md -->
@~/.claude/project/spec/file1.md
@~/.claude/project/spec/file2.md
```

**Why**: Load workflows are the ONLY place where @ references should exist. Other files delegate via slash commands.

**Rule 3: No File Duplication in Modular Loads**
```markdown
✅ CORRECT (Modular):
<!-- load-universal-context.md -->
@~/.claude/code-zen/spec/universal/naming.md
@~/.claude/code-zen/spec/universal/structure.md

<!-- load-zen-context.md -->
@~/.claude/code-zen/spec/principles/zen.md

<!-- load-python-context.md -->
@~/.claude/code-zen/spec/python/language.md

❌ WRONG (Duplicated):
<!-- load-zen-context.md -->
@~/.claude/code-zen/spec/universal/naming.md  ← duplicated
@~/.claude/code-zen/spec/principles/zen.md

<!-- load-python-context.md -->
@~/.claude/code-zen/spec/universal/naming.md  ← duplicated
@~/.claude/code-zen/spec/python/language.md
```

**Why**: In modular load strategies, each file must be referenced in exactly ONE load workflow. Users compose by calling multiple loads.

**Validation**:
```bash
# Check for duplicated references across load workflows
grep -h "^@" prompts/load-*.md | sort | uniq -d
# Should return empty (no duplicates)
```

**When to Use Modular vs Monolithic**:
- **Monolithic**: Project is cohesive, always needs full context (e.g., Gradient)
- **Modular**: Project has independent contexts that can be composed (e.g., Code Zen: universal + zen + python)

**Duplication check**:
```
If load workflows contain duplicate @ references
  → Refactor to independent loads OR merge into monolithic
If agents/prompts list @ references
  → Extract to load workflow, delegate via slash command
```

### Command Delegation vs Direct References

**Trade-off**: When multiple files need the same context, you face a choice:

#### Approach A: Direct @ References

**Pattern**:
```markdown
# file-1.md
@./spec/a.md
@./spec/b.md
@./spec/c.md

# file-2.md (duplicates references)
@./spec/a.md
@./spec/b.md
@./spec/c.md
```

**Pros**:
- ✅ Explicit - see exactly what's loaded
- ✅ No indirection - direct path to content
- ✅ Self-contained - all dependencies visible

**Cons**:
- ❌ Violates DRY - reference list duplicated
- ❌ Harder to maintain - changes in N places
- ❌ More lines - scales linearly with consumers

#### Approach B: Command Delegation

**Pattern**:
```markdown
# prompts/load-context.md (SSOT for references)
@./spec/a.md
@./spec/b.md
@./spec/c.md

# file-1.md
- Execute o command /project:load-context

# file-2.md
- Execute o command /project:load-context
```

**Pros**:
- ✅ DRY - reference list in one place
- ✅ Easier maintenance - change once, apply everywhere
- ✅ Composable - can combine multiple load commands
- ✅ Centralized control - manage context loading in one location

**Cons**:
- ❌ Indirection - follow command to see what's loaded
- ❌ Less explicit - dependencies not immediately visible

#### Guideline: Choose Based on Reuse

**Use Command Delegation when**:
- **3+ files** need identical context
- Reference list is **5+ files**
- Context loading is a **standard pattern**
- **Centralized control** is valuable
- **Maintenance** > explicitness

**Example**: Code Zen has 5 guides needing same 6 specs → command delegation saves 19 lines

**Use Direct References when**:
- **1-2 files** need context
- Each file needs **unique subset** of context
- **Explicitness** is more valuable than DRY
- Reference lists are **short (<5 files)**
- **Self-documentation** > centralization

**Example**: Single specialized workflow needing 2 specific specs → direct references clearer

#### Architectural Validity

**Both approaches are valid Gradient architecture**. The choice is a trade-off between:
- **DRY principle** (command delegation)
- **Explicitness principle** (direct references)

**Severity Classification**:
- Using commands for DRY: **INFO** level (acceptable architectural choice)
- Using commands unnecessarily (1-2 consumers): **WARNING** level (premature abstraction)

**Validation Rule**:
```
If command delegation used:
  Count consumers of that command
  ├─ 3+ consumers → INFO: "DRY via command delegation (acceptable)"
  ├─ 1-2 consumers → WARNING: "Premature abstraction, use direct @references"
  └─ Reference list <3 files → WARNING: "Short list, direct references clearer"
```

**Real-World Example**: The code-zen project correctly uses command delegation because 5+ files need the same 6 specs, saving significant duplication while maintaining DRY.

---

## Validation Checklist

### For Any File

- [ ] Does this content exist elsewhere?
- [ ] Am I explaining something already defined in SPECS?
- [ ] Am I showing an example already in CONTEXT?
- [ ] Could this be a reference instead?
- [ ] Is this the authoritative source for this information?

### For SPECS Files

- [ ] No working examples (only minimal illustrations)
- [ ] No implementation guides
- [ ] No repeated content from other specs
- [ ] All content is normative

### For CONTEXT Files

- [ ] No syntax definitions (reference SPECS instead)
- [ ] No repeated examples
- [ ] Each example provides unique value
- [ ] References specs for rules

### For PROMPTS Files

- [ ] Mostly `@` references
- [ ] <5 lines of inline content per section
- [ ] No duplicated instructions
- [ ] Orchestration only

---

## Common Anti-Patterns

### Anti-Pattern 1: Spec Repetition

**Problem**:
```markdown
<!-- specs/format.md -->
YMD files must have meta section with id, kind, version, title.

<!-- context/guide.md -->
YMD files must have a meta section containing:
- id: unique identifier
- kind: type
- version: semver
- title: description
```

**Solution**:
```markdown
<!-- context/guide.md -->
For YMD metadata requirements:
@./gradient/specs/format.md

Example metadata:
```yaml
meta:
  id: example
  kind: task
  version: 1.0.0
  title: Example
```
```

### Anti-Pattern 2: Example Duplication

**Problem**:
```markdown
<!-- context/examples.md -->
Example: Simple YMD
(50 lines)

<!-- context/guide.md -->
Here's a simple YMD example:
(same 50 lines with minor changes)
```

**Solution**:
```markdown
<!-- context/guide.md -->
For complete examples:
@./examples.md

Quick reference:
```yaml
meta:
  id: ...
```
(5 lines, essential only)
```

### Anti-Pattern 3: Verbose Prompts

**Problem**:
```markdown
<!-- prompts/load-context.md -->
YMD Format Overview:
(100 lines explaining YMD format)

PMD Format Overview:
(80 lines explaining PMD format)

Composition Rules:
(120 lines explaining composition)
```

**Solution**:
```markdown
<!-- prompts/load-context.md -->
## Format Specifications

@~/.claude/ymd-spec/spec/ymd-spec.md
@~/.claude/ymd-spec/spec/pmd-spec.md
@~/.claude/ymd-spec/spec/composition-spec.md

## Your Task

With these specs loaded, you can now...
```

### Anti-Pattern 4: Quick Reference Files

**Problem**:
```markdown
<!-- context/quick-reference.md -->
(Summarizes all specs in shorter form)
(Still 200 lines of duplication)
```

**Rationale for removal**:
- For LLMs: No value (can process full specs equally fast)
- Creates duplication
- Maintenance burden
- Quick ≠ Better for machines

**Solution**:
Eliminate "quick reference" files entirely.

---

## For LLMs: Implementation Guidelines

### When Generating Content

**Before writing**, ask:
1. Does this information exist in SPECS?
   - YES → Reference it with `@`, don't duplicate
2. Does this example exist in CONTEXT?
   - YES → Reference it, don't recreate
3. Is this a new, unique contribution?
   - YES → Place in appropriate layer

### When Reviewing Content

**Check for**:
- Syntax explanations in non-SPEC files
- Repeated examples
- Paraphrased rules
- Verbose prompts with inline content

**Action**: Flag and suggest refactoring to references.

### When Refactoring

**Process**:
1. Identify SSOT (SPECS > CONTEXT > PROMPTS)
2. Consolidate all content there
3. Replace duplicates with `@` references
4. Validate all references resolve

---

## For Humans: Practical Checklist

### Before Creating New File

- [ ] What layer does this belong to?
- [ ] Does similar content exist?
- [ ] Am I about to duplicate something?
- [ ] Could I reference instead?

### While Writing

- [ ] Am I explaining syntax (should be in SPECS)?
- [ ] Am I showing examples (should be in CONTEXT)?
- [ ] Am I orchestrating (should be in PROMPTS)?
- [ ] Is this line unique or duplicated?

### After Writing

- [ ] Run duplication check (search for similar content)
- [ ] Verify all references resolve
- [ ] Confirm SSOT for each concept
- [ ] Test that removing file doesn't lose information

---

## Metrics: Measuring Duplication

### Quantitative

**Duplication Ratio**:
```
Total Lines / Unique Information Lines = Duplication Ratio

Target: ≤ 1.1 (10% acceptable overlap for context)
Danger: > 1.3 (30% duplication indicates problems)
```

**Reference Density** (for PROMPTS):
```
@ References / Total Lines

Target: > 0.5 (majority should be references)
Danger: < 0.2 (too much inline content)
```

### Qualitative

**Red Flags**:
- Can't determine SSOT for a concept
- Multiple files "explain" the same thing
- Changes require updates in >2 places
- Difficult to locate authoritative information

**Green Flags**:
- Clear SSOT for every concept
- References feel natural
- Changes propagate automatically via references
- Easy to find authoritative source

---

## Evolution and Maintenance

### Handling Changes

**When spec changes**:
```
1. Update SSOT (specs file)
2. References automatically reflect change
3. No need to update referencing files
```

**When context changes**:
```
1. Update SSOT (context file)
2. References automatically reflect change
3. No duplication to sync
```

### Preventing Decay

**Regular audits**:
- Monthly: Scan for new duplication
- After major changes: Validate references
- Before releases: Run duplication metrics

**Tools** (potential):
- `find-duplicates.sh` - Detects similar content
- `validate-references.sh` - Checks @ links resolve
- `calculate-metrics.sh` - Measures duplication ratio

---

## Summary

### Core Principles

1. **Single Source of Truth**: One authoritative location per concept
2. **Reference, Don't Repeat**: Use `@` links liberally
3. **Layer Boundaries**: Respect SPECS → CONTEXT → PROMPTS separation
4. **Default to Reference**: When in doubt, reference
5. **Validate Continuously**: Check for duplication drift

### Key Outcomes

- **Zero duplication** across layers
- **Minimal maintenance** burden
- **Clear information hierarchy**
- **Efficient token usage** (for LLMs)
- **Easy navigation** (for humans)

---

## Related Documents

**For architecture details**:
- `@./architecture-spec.md` - Complete Gradient architecture
- `@./layer-spec.md` - Layer-specific specifications

**For implementation**:
- `@./gradient/context/implementation-guide.md` - Step-by-step guide
- `@./gradient/context/decision-guide.md` - Decision trees

---

**Remember**: Duplication is a bug, not a feature. Every repeated piece of information is a maintenance liability and a source of potential inconsistency.
