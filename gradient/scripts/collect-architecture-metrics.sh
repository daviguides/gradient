#!/bin/bash
# Script: collect-architecture-metrics.sh
# Purpose: Collect objective metrics for Gradient architecture validation
# Usage: collect-architecture-metrics.sh [project-root]
# Output: JSON structure with project metrics

set -euo pipefail

# Project root (default: current directory)
PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

# === DATA COLLECTION ===

# Project name (from current directory)
PROJECT_NAME=$(basename "$PWD")

# Bundle directory (directory containing spec/)
BUNDLE_DIR=$(find . -maxdepth 2 -type d -name "spec" 2>/dev/null \
    | head -1 \
    | xargs dirname 2>/dev/null \
    | xargs basename 2>/dev/null \
    || echo "NOT_FOUND")

# Bundle name validation
if [ "$PROJECT_NAME" = "$BUNDLE_DIR" ]; then
    BUNDLE_VALIDATION="PASS"
    BUNDLE_MATCH="true"
else
    BUNDLE_VALIDATION="FAIL"
    BUNDLE_MATCH="false"
fi

# Layers present (detect directories within bundle)
LAYERS_FOUND=$(find . -maxdepth 3 -type d \
    \( -name "spec" -o -name "context" -o -name "prompts" \
       -o -name "commands" -o -name "agents" -o -name "scripts" -o -name "hooks" \) 2>/dev/null \
    | sed 's|.*/||' \
    | sort -u \
    | tr '\n' ',' \
    | sed 's/,$//')

# Command file references (extract bundle names from @~/.claude/BUNDLE/)
if [ -d "commands" ]; then
    COMMAND_REFS=$(grep -h "@~/.claude/" commands/*.md 2>/dev/null \
        | grep -o "@~/.claude/[^/]*" \
        | sed 's|@~/.claude/||' \
        | sort -u \
        | tr '\n' ',' \
        | sed 's/,$//' \
        || echo "NONE")
else
    COMMAND_REFS="NO_COMMANDS_DIR"
fi

# File counts per layer
SPEC_FILES=$(find . -path "*/spec/*.md" 2>/dev/null | wc -l | tr -d ' ')
CONTEXT_FILES=$(find . -path "*/context/*.md" 2>/dev/null | wc -l | tr -d ' ')
PROMPT_FILES=$(find . -path "*/prompts/*.md" 2>/dev/null | wc -l | tr -d ' ')
COMMAND_FILES=$(find . -path "*/commands/*.md" 2>/dev/null | wc -l | tr -d ' ')
AGENT_FILES=$(find . -path "*/agents/*.md" 2>/dev/null | wc -l | tr -d ' ')
SCRIPT_FILES=$(find . -path "*/scripts/*.sh" 2>/dev/null | wc -l | tr -d ' ')
HOOK_FILES=$(find . -path "*/hooks/*.md" 2>/dev/null | wc -l | tr -d ' ')

TOTAL_ARCH_FILES=$((SPEC_FILES + CONTEXT_FILES + PROMPT_FILES + COMMAND_FILES + AGENT_FILES))

# All markdown files (excluding common noise directories)
MD_FILES=$(find . -name "*.md" \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*" \
    -not -path "*/docs/_site/*" \
    -not -path "*/.claude/*" \
    2>/dev/null \
    | sort)

# Count total markdown files
TOTAL_MD_FILES=$(echo "$MD_FILES" | grep -c "." || echo "0")

# === JSON OUTPUT ===

cat <<EOF
{
  "validation_timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "project_name": "$PROJECT_NAME",
  "bundle_dir": "$BUNDLE_DIR",
  "bundle_validation": {
    "status": "$BUNDLE_VALIDATION",
    "match": $BUNDLE_MATCH,
    "expected": "$PROJECT_NAME",
    "actual": "$BUNDLE_DIR"
  },
  "layers": {
    "detected": "$LAYERS_FOUND",
    "has_spec": $([ -d "*/spec" ] 2>/dev/null && echo "true" || echo "false"),
    "has_context": $([ -d "*/context" ] 2>/dev/null && echo "true" || echo "false"),
    "has_prompts": $([ -d "*/prompts" ] 2>/dev/null && echo "true" || echo "false")
  },
  "command_references": {
    "bundles": "$COMMAND_REFS",
    "consistent": $([ "$COMMAND_REFS" = "$PROJECT_NAME" ] && echo "true" || echo "false")
  },
  "file_counts": {
    "spec": $SPEC_FILES,
    "context": $CONTEXT_FILES,
    "prompts": $PROMPT_FILES,
    "commands": $COMMAND_FILES,
    "agents": $AGENT_FILES,
    "scripts": $SCRIPT_FILES,
    "hooks": $HOOK_FILES,
    "total_architectural": $TOTAL_ARCH_FILES,
    "total_markdown": $TOTAL_MD_FILES
  },
  "markdown_files": [
$(echo "$MD_FILES" | sed 's/^/    "/;s/$/",/' | sed '$ s/,$//')
  ]
}
EOF

exit 0
