# Validate Gradient Architecture

**Purpose**: Comprehensive validation of Gradient architecture compliance in the current project.

## Gradient Architecture Context

Antes de qualquer passo faça:
- Execute o command /gradient:load-gradient-context para carregar o contexto

---

## Validation Workflow

You will perform a comprehensive Gradient architecture validation using the specialized `architecture-reviewer` agent.

### Phase 1: Collect Project Context

Gather the following information about the current project:

**Project Structure**:
- List all `.md` files in the project
- Identify which layers are present (spec/, context/, prompts/, commands/, agents/)
- Note the directory structure

**Sample Content**:
- Read a few representative files from each layer
- Focus on understanding the project's architecture approach

### Phase 2: Launch Architecture Review Agent

Invoke the `architecture-reviewer` agent with comprehensive context:

**Agent Invocation**:
```
Review this project for Gradient architecture compliance.

Project: [current directory name]
Working directory: [current path]

Project structure:
[Complete file tree with .md files]

Sample files analyzed:
[List 2-3 key files from each layer with brief content summary]

Perform a complete validation following the checklist in agents/architecture-reviewer.md and return a detailed JSON report.
```

**Expected Agent Output**:
- Status (PASS/FAIL)
- Summary metrics
- Issues categorized by severity (critical/warning/info)
- Detailed recommendations with priority and effort
- Positive findings

### Phase 3: Format and Present Report

Transform the agent's JSON output into a user-friendly report.

#### Output Format

```markdown
# Gradient Architecture Validation Report

## Executive Summary

**Status**: [PASS | FAIL]
**Project**: [Current directory name]
**Validation Date**: [Current date]

**Quick Stats**:
- Total Files: [number]
- Layers Present: [list]
- Overall Compliance: [percentage from agent]%

---

## Analysis Results

### Critical Issues
[List from agent report where severity = "critical"]

### Warnings
[List from agent report where severity = "warning"]

### Informational Notes
[List from agent report where severity = "info"]

---

## Recommendations

[Sort by priority, then by effort]

### Priority 1 (Critical)
[List recommendations where priority = 1]
- [Action] - Effort: [low/medium/high]
  Rationale: [why this matters]

### Priority 2 (Important)
[List recommendations where priority = 2]
- [Action] - Effort: [low/medium/high]
  Rationale: [why this matters]

### Priority 3 (Nice to Have)
[List recommendations where priority = 3]
- [Action] - Effort: [low/medium/high]
  Rationale: [why this matters]

---

## Positive Findings

[List strengths from agent report]

---

## Next Steps

[If PASS]:
✓ Project follows Gradient architecture excellently!
Consider periodic validation to maintain compliance.

[If FAIL with critical issues]:
1. Address Priority 1 recommendations immediately
2. Run `/validate` again to verify fixes
3. Proceed to Priority 2 recommendations
4. Iterate until compliance is achieved

[If FAIL with warnings only]:
1. Review Priority 2 recommendations
2. Plan incremental improvements
3. Consult implementation-guide.md for guidance

---

## Validation Details

**Method**: Architecture Reviewer Agent
**Agent**: `architecture-reviewer`
**Specifications Applied**:
- architecture-spec.md
- anti-duplication-principles.md
- layer-spec.md

**Validation Areas**:
- Layer boundary compliance
- Duplication detection
- Reference integrity
- File structure conventions
- Naming compliance
- Content appropriateness per layer
```

---

## Execution Instructions

1. **Scan project structure** - Use Glob to find all `.md` files and understand directory layout
2. **Read sample files** - Read 2-3 representative files from each layer to understand approach
3. **Launch agent** - Invoke `architecture-reviewer` with complete context
4. **Wait for completion** - Agent returns a single comprehensive JSON report
5. **Format output** - Transform JSON into user-friendly markdown report
6. **Present results** - Return formatted report to user

---

## Error Handling

**If agent fails**:
- Report the error clearly
- Include any partial output from agent
- Mark validation as INCOMPLETE
- Recommend manual review using specs

**If no Gradient structure found**:
- Report that project doesn't appear to use Gradient architecture
- List what was found vs. what was expected
- Suggest consulting implementation-guide.md
- Offer to help implement Gradient structure

**If project structure is ambiguous**:
- Report findings with uncertainty markers
- Ask clarifying questions if needed
- Provide best-effort analysis based on available information

---

## Important Notes

- This validation runs on the **current working directory**
- Agent analyzes both quantitative metrics and qualitative aspects
- Agent has deep understanding of Gradient principles
- Agent can detect subtle architectural issues humans might miss
- Agent provides actionable, prioritized recommendations

---

## Expected Outcomes

**PASS Criteria** (Agent determines):
- All references valid and appropriate
- Minimal duplication (within acceptable range)
- Proper reference usage (>50% in prompts)
- Command files are thin wrappers
- Layer boundaries respected
- No critical architectural violations

**FAIL Criteria** (Agent determines):
- Broken or inappropriate references
- Significant duplication detected
- Layer boundary violations
- Missing required layers
- Critical architectural anti-patterns

---

## Meta

This prompt follows Gradient principles:
- **Loads context via `@`** (specs referenced, not duplicated)
- **Delegates to specialist** (architecture-reviewer agent)
- **Thin orchestrator** (coordinates, doesn't duplicate logic)
- **Clear workflow** (scan → agent → format → present)
- **Actionable output** (structured report with prioritized recommendations)

The agent is the single source of truth for validation logic, ensuring consistency and maintainability.
