#!/bin/bash
# Script: validate-references.sh
# Purpose: Validate that all @ references in markdown files resolve correctly
# Usage: validate-references.sh <project-path>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_PATH="${1:-.}"
ERRORS=0
WARNINGS=0
TOTAL_REFS=0

echo "Validating @ references in: $PROJECT_PATH"
echo "----------------------------------------"

# Function to resolve relative path
resolve_path() {
    local base_dir="$1"
    local ref_path="$2"

    # Remove @ prefix
    ref_path="${ref_path#@}"

    # Handle home directory references
    if [[ "$ref_path" == ~/* ]]; then
        ref_path="${ref_path/#\~/$HOME}"
        echo "$ref_path"
        return
    fi

    # Handle relative paths
    if [[ "$ref_path" == ../* ]] || [[ "$ref_path" == ./* ]]; then
        # Resolve relative to base directory
        resolved=$(cd "$base_dir" && realpath "$ref_path" 2>/dev/null || echo "")
        echo "$resolved"
        return
    fi

    # If not relative or home, treat as relative to base
    resolved=$(cd "$base_dir" && realpath "$ref_path" 2>/dev/null || echo "")
    echo "$resolved"
}

# Find all markdown files
find "$PROJECT_PATH" -name "*.md" -type f | while read -r file; do
    file_dir=$(dirname "$file")
    file_has_refs=false

    # Extract all @ references from the file
    while IFS= read -r line; do
        # Match @path patterns (handles paths with spaces, dots, slashes)
        if [[ "$line" =~ @([^[:space:]]+) ]]; then
            ref="${BASH_REMATCH[1]}"
            TOTAL_REFS=$((TOTAL_REFS + 1))
            file_has_refs=true

            # Resolve the reference path
            resolved_path=$(resolve_path "$file_dir" "@$ref")

            if [ -z "$resolved_path" ]; then
                echo -e "${RED}ERROR${NC}: Broken reference in $file"
                echo "       Reference: @$ref"
                echo "       Could not resolve path"
                ERRORS=$((ERRORS + 1))
                continue
            fi

            # Check if resolved file exists
            if [ ! -f "$resolved_path" ]; then
                echo -e "${RED}ERROR${NC}: Broken reference in $file"
                echo "       Reference: @$ref"
                echo "       Resolved to: $resolved_path"
                echo "       File does not exist"
                ERRORS=$((ERRORS + 1))
            else
                # Optionally show successful resolutions in verbose mode
                if [ "${VERBOSE:-0}" = "1" ]; then
                    echo -e "${GREEN}OK${NC}: @$ref → $resolved_path"
                fi
            fi
        fi
    done < "$file"

    # Show file being processed if it has references
    if [ "$file_has_refs" = true ] && [ "${VERBOSE:-0}" != "1" ]; then
        echo "Checked: $file"
    fi
done

echo "----------------------------------------"
echo "Validation complete"
echo ""
echo "Total references found: $TOTAL_REFS"

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}All references valid ✓${NC}"
    exit 0
else
    echo -e "${RED}Found $ERRORS broken reference(s) ✗${NC}"
    exit 1
fi
