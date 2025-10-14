#!/bin/bash
# Script: calculate-metrics.sh
# Purpose: Calculate Gradient architecture quality metrics
# Usage: calculate-metrics.sh <project-path>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_PATH="${1:-.}"

echo "Calculating Gradient metrics for: $PROJECT_PATH"
echo "========================================"

# Function to count lines in files
count_lines() {
    local pattern="$1"
    find "$PROJECT_PATH" -path "$pattern" -name "*.md" -type f -exec wc -l {} + 2>/dev/null | \
        tail -1 | awk '{print $1}' || echo "0"
}

# Function to count files
count_files() {
    local pattern="$1"
    find "$PROJECT_PATH" -path "$pattern" -name "*.md" -type f 2>/dev/null | wc -l
}

# Function to count @ references
count_references() {
    local pattern="$1"
    find "$PROJECT_PATH" -path "$pattern" -name "*.md" -type f -exec grep -o "@" {} + 2>/dev/null | wc -l
}

# Function to calculate percentage
calc_percentage() {
    local value=$1
    local total=$2
    if [ "$total" -eq 0 ]; then
        echo "0"
    else
        echo "scale=2; ($value * 100) / $total" | bc
    fi
}

# Function to evaluate status
eval_status() {
    local value=$1
    local target=$2
    local comparison=${3:-">="}  # >= or <=

    if [ "$comparison" = ">=" ]; then
        if (( $(echo "$value >= $target" | bc -l) )); then
            echo -e "${GREEN}PASS${NC}"
        elif (( $(echo "$value >= ($target * 0.8)" | bc -l) )); then
            echo -e "${YELLOW}WARNING${NC}"
        else
            echo -e "${RED}FAIL${NC}"
        fi
    else
        if (( $(echo "$value <= $target" | bc -l) )); then
            echo -e "${GREEN}PASS${NC}"
        elif (( $(echo "$value <= ($target * 1.2)" | bc -l) )); then
            echo -e "${YELLOW}WARNING${NC}"
        else
            echo -e "${RED}FAIL${NC}"
        fi
    fi
}

echo ""
echo -e "${CYAN}1. Project Structure${NC}"
echo "----------------------------------------"

# Count files per layer
specs_files=$(count_files "*-spec")
context_files=$(count_files "*/context")
prompts_files=$(count_files "*/prompts")
commands_files=$(count_files "*/commands")
agents_files=$(count_files "*/agents")

total_files=$((specs_files + context_files + prompts_files + commands_files + agents_files))

echo "SPECS files:    $specs_files"
echo "CONTEXT files:  $context_files"
echo "PROMPTS files:  $prompts_files"
echo "COMMANDS files: $commands_files"
echo "AGENTS files:   $agents_files"
echo "Total files:    $total_files"

echo ""
echo -e "${CYAN}2. Duplication Ratio${NC}"
echo "----------------------------------------"

# Count total lines
total_lines=$(find "$PROJECT_PATH" -name "*.md" -type f -exec wc -l {} + 2>/dev/null | \
    tail -1 | awk '{print $1}' || echo "0")

# Estimate unique lines (simplified: assume some overlap)
# Real implementation would need more sophisticated analysis
# For now, use a heuristic based on reference density
total_refs=$(count_references "*")
estimated_duplicate_lines=$((total_refs * 10))  # Rough estimate: each ref saves ~10 lines
unique_lines=$((total_lines - estimated_duplicate_lines))
if [ $unique_lines -lt 1 ]; then
    unique_lines=$total_lines
fi

if [ "$unique_lines" -eq 0 ]; then
    duplication_ratio="N/A"
    dup_status="N/A"
else
    duplication_ratio=$(echo "scale=2; $total_lines / $unique_lines" | bc)
    dup_status=$(eval_status "$duplication_ratio" "1.1" "<=")
fi

echo "Total lines:           $total_lines"
echo "Estimated unique:      $unique_lines"
echo "Duplication ratio:     $duplication_ratio"
echo "Target:                ≤ 1.1"
echo "Status:                $dup_status"

echo ""
echo -e "${CYAN}3. Reference Density (PROMPTS)${NC}"
echo "----------------------------------------"

prompts_lines=$(count_lines "*/prompts")
prompts_refs=$(count_references "*/prompts")

if [ "$prompts_lines" -eq 0 ]; then
    ref_density="N/A"
    ref_status="N/A"
else
    ref_density=$(echo "scale=2; $prompts_refs / $prompts_lines" | bc)
    ref_status=$(eval_status "$ref_density" "0.5" ">=")
fi

echo "PROMPTS total lines:   $prompts_lines"
echo "PROMPTS @ references:  $prompts_refs"
echo "Reference density:     $ref_density"
echo "Target:                > 0.5"
echo "Status:                $ref_status"

echo ""
echo -e "${CYAN}4. Command File Sizes${NC}"
echo "----------------------------------------"

if [ "$commands_files" -eq 0 ]; then
    echo "No command files found"
    avg_cmd_size="N/A"
    max_cmd_size="N/A"
    cmd_status="N/A"
else
    # Calculate average and max command file size
    cmd_sizes=$(find "$PROJECT_PATH" -path "*/commands" -name "*.md" -type f -exec wc -l {} + 2>/dev/null | \
        grep -v "total" | awk '{print $1}')

    total_cmd_lines=0
    max_cmd_size=0
    count=0

    while IFS= read -r size; do
        total_cmd_lines=$((total_cmd_lines + size))
        count=$((count + 1))
        if [ "$size" -gt "$max_cmd_size" ]; then
            max_cmd_size=$size
        fi
    done <<< "$cmd_sizes"

    if [ "$count" -eq 0 ]; then
        avg_cmd_size="N/A"
        cmd_status="N/A"
    else
        avg_cmd_size=$(echo "scale=2; $total_cmd_lines / $count" | bc)
        cmd_status=$(eval_status "$max_cmd_size" "5" "<=")
    fi

    echo "Average size:          $avg_cmd_size lines"
    echo "Maximum size:          $max_cmd_size lines"
    echo "Target:                ≤ 5 lines"
    echo "Status:                $cmd_status"
fi

echo ""
echo -e "${CYAN}5. Layer Compliance${NC}"
echo "----------------------------------------"

# Check if required directories exist
required_dirs=("*-spec" "*/context" "*/prompts")
present_dirs=0

for dir_pattern in "${required_dirs[@]}"; do
    if find "$PROJECT_PATH" -path "$dir_pattern" -type d 2>/dev/null | grep -q .; then
        present_dirs=$((present_dirs + 1))
    fi
done

compliance=$(calc_percentage "$present_dirs" "3")
if (( $(echo "$compliance >= 100" | bc -l) )); then
    compliance_status=$(echo -e "${GREEN}PASS${NC}")
else
    compliance_status=$(echo -e "${RED}FAIL${NC}")
fi

echo "Required layers present: $present_dirs/3"
echo "Compliance:              $compliance%"
echo "Status:                  $compliance_status"

echo ""
echo -e "${CYAN}6. Reference Integrity${NC}"
echo "----------------------------------------"

# Run reference validation (if script exists)
if [ -f "$PROJECT_PATH/scripts/validate-references.sh" ] || [ -f "$(dirname "$0")/validate-references.sh" ]; then
    ref_script="$(dirname "$0")/validate-references.sh"
    if [ -f "$ref_script" ]; then
        if bash "$ref_script" "$PROJECT_PATH" > /dev/null 2>&1; then
            echo -e "Status:                  ${GREEN}All references valid ✓${NC}"
        else
            echo -e "Status:                  ${RED}Broken references found ✗${NC}"
            echo "Run validate-references.sh for details"
        fi
    else
        echo "Status:                  Not tested (script not found)"
    fi
else
    echo "Status:                  Not tested (script not found)"
fi

echo ""
echo "========================================"
echo -e "${BLUE}Summary${NC}"
echo "========================================"

# Overall assessment
issues=0

if [ "$duplication_ratio" != "N/A" ] && (( $(echo "$duplication_ratio > 1.1" | bc -l) )); then
    issues=$((issues + 1))
fi

if [ "$ref_density" != "N/A" ] && (( $(echo "$ref_density < 0.5" | bc -l) )); then
    issues=$((issues + 1))
fi

if [ "$max_cmd_size" != "N/A" ] && [ "$max_cmd_size" -gt 5 ]; then
    issues=$((issues + 1))
fi

if (( $(echo "$compliance < 100" | bc -l) )); then
    issues=$((issues + 1))
fi

echo "Total files:           $total_files"
echo "Total lines:           $total_lines"
echo "Total @ references:    $total_refs"
echo ""

if [ $issues -eq 0 ]; then
    echo -e "${GREEN}✓ All metrics within targets${NC}"
    echo ""
    echo "Project follows Gradient architecture excellently!"
    exit 0
elif [ $issues -le 2 ]; then
    echo -e "${YELLOW}⚠ $issues metric(s) need attention${NC}"
    echo ""
    echo "Project mostly follows Gradient architecture."
    echo "Review metrics above for improvement areas."
    exit 1
else
    echo -e "${RED}✗ $issues metric(s) failing${NC}"
    echo ""
    echo "Project needs significant Gradient compliance work."
    echo "Review metrics above and consult implementation-guide.md"
    exit 2
fi
