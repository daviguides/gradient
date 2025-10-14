#!/bin/bash
# Script: detect-duplication.sh
# Purpose: Detect potential content duplication across markdown files
# Usage: detect-duplication.sh <project-path>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_PATH="${1:-.}"
MIN_SIMILARITY_LINES=3  # Minimum lines to consider as potential duplication

echo "Detecting potential duplication in: $PROJECT_PATH"
echo "----------------------------------------"

# Create temporary directory for analysis
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Function to extract significant text blocks (headers and paragraphs)
extract_blocks() {
    local file="$1"
    local output="$2"

    # Extract headers (##, ###) and first line of paragraphs
    grep -E "^#{2,3}[[:space:]]|^[A-Z]" "$file" 2>/dev/null | \
        sed 's/^[#[:space:]]*//' | \
        grep -v "^$" > "$output" || true
}

# Build index of significant blocks
echo "Building content index..."
file_count=0
find "$PROJECT_PATH" -name "*.md" -type f | while read -r file; do
    file_count=$((file_count + 1))
    relative_path="${file#$PROJECT_PATH/}"

    # Extract significant blocks
    blocks_file="$TEMP_DIR/blocks_${file_count}.txt"
    extract_blocks "$file" "$blocks_file"

    # Store mapping
    echo "$file" > "$TEMP_DIR/file_${file_count}.txt"
done

# Find duplicated sections
echo "Analyzing for duplications..."
echo ""

duplications_found=0

# Compare each file with every other file
for blocks1 in "$TEMP_DIR"/blocks_*.txt; do
    file1_id="${blocks1##*/blocks_}"
    file1_id="${file1_id%.txt}"
    file1=$(cat "$TEMP_DIR/file_${file1_id}.txt")

    for blocks2 in "$TEMP_DIR"/blocks_*.txt; do
        file2_id="${blocks2##*/blocks_}"
        file2_id="${file2_id%.txt}"

        # Skip self-comparison and already compared pairs
        if [ "$file1_id" -ge "$file2_id" ]; then
            continue
        fi

        file2=$(cat "$TEMP_DIR/file_${file2_id}.txt")

        # Find common lines
        common_lines=$(comm -12 <(sort "$blocks1") <(sort "$blocks2") | wc -l)

        if [ "$common_lines" -ge "$MIN_SIMILARITY_LINES" ]; then
            duplications_found=$((duplications_found + 1))

            echo -e "${YELLOW}Potential duplication detected:${NC}"
            echo "  File 1: ${file1#$PROJECT_PATH/}"
            echo "  File 2: ${file2#$PROJECT_PATH/}"
            echo "  Common content blocks: $common_lines"
            echo ""
            echo "  Common sections:"
            comm -12 <(sort "$blocks1") <(sort "$blocks2") | head -5 | while read -r line; do
                echo "    - $line"
            done
            if [ "$common_lines" -gt 5 ]; then
                echo "    ... and $((common_lines - 5)) more"
            fi
            echo ""
            echo "  ${BLUE}Action${NC}: Review these files for potential consolidation"
            echo "  ${BLUE}Reference${NC}: anti-duplication-principles.md#detection"
            echo "----------------------------------------"
        fi
    done
done

echo ""
echo "Detection complete"
echo ""

if [ $duplications_found -eq 0 ]; then
    echo -e "${GREEN}No significant duplication detected ✓${NC}"
    exit 0
else
    echo -e "${YELLOW}Found $duplications_found potential duplication(s) ⚠${NC}"
    echo ""
    echo "Note: Not all detected similarities are duplications."
    echo "Review each case to determine if consolidation is needed."
    echo ""
    echo "Guidelines:"
    echo "  - Specs should not duplicate context"
    echo "  - Context should reference specs, not redefine them"
    echo "  - Prompts should reference, not duplicate"
    echo "  - Each concept should have exactly one SSOT"
    exit 1
fi
