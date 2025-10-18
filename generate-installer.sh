#!/bin/bash
set -euo pipefail

# ============================================================================
# Installer Generator
# Generates install.sh from install.sh.template for any project
# ============================================================================

# --- Constants ---
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly TEMPLATE_FILE="$SCRIPT_DIR/install.sh.template"
readonly OUTPUT_FILENAME="install.sh"

# ============================================================================
# Helper Functions
# ============================================================================

print_usage() {
  cat << EOF
Usage: $(basename "$0") PROJECT_NAME [OUTPUT_DIR]

Generate install.sh from template by replacing placeholders.

Arguments:
  PROJECT_NAME    Name of your project (lowercase, e.g., code-zen)
  OUTPUT_DIR      Directory to create install.sh (default: current directory)

Examples:
  $(basename "$0") code-zen
  $(basename "$0") code-zen /path/to/code-zen
  $(basename "$0") semantic-docstrings ~/projects/semantic-docstrings

EOF
}

validate_arguments() {
  if [ $# -eq 0 ]; then
    printf "%b\n" "${RED}Error: Missing project name${NC}"
    print_usage
    exit 1
  fi

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_usage
    exit 0
  fi
}

validate_project_name() {
  local project="$1"

  # Check for uppercase letters
  if [[ "$project" =~ [A-Z] ]]; then
    printf "%b\n" "${RED}Error: Project name must be lowercase${NC}"
    printf "%s\n" "Got: $project"
    printf "%s\n" "Try: $(echo "$project" | tr '[:upper:]' '[:lower:]')"
    exit 1
  fi

  # Check for spaces
  if [[ "$project" =~ [[:space:]] ]]; then
    printf "%b\n" "${RED}Error: Project name cannot contain spaces${NC}"
    printf "%s\n" "Got: $project"
    printf "%s\n" "Try: $(echo "$project" | tr ' ' '-')"
    exit 1
  fi

  # Check for invalid characters
  if [[ ! "$project" =~ ^[a-z0-9._-]+$ ]]; then
    printf "%b\n" "${RED}Error: Invalid characters in project name${NC}"
    printf "%s\n" "Allowed: lowercase letters, numbers, dots, hyphens, underscores"
    exit 1
  fi
}

capitalize_first_letter() {
  local str="$1"
  # POSIX-compatible: capitalize first letter
  local first="${str:0:1}"
  local rest="${str:1}"
  echo "$(echo "$first" | tr '[:lower:]' '[:upper:]')$rest"
}

validate_output_dir() {
  local output_dir="$1"

  if [ ! -d "$output_dir" ]; then
    printf "%b\n" "${RED}Error: Output directory does not exist${NC}"
    printf "%s\n" "Directory: $output_dir"
    exit 1
  fi

  if [ ! -w "$output_dir" ]; then
    printf "%b\n" "${RED}Error: Output directory is not writable${NC}"
    printf "%s\n" "Directory: $output_dir"
    exit 1
  fi
}

check_template_exists() {
  if [ ! -f "$TEMPLATE_FILE" ]; then
    printf "%b\n" "${RED}Error: Template file not found${NC}"
    printf "%s\n" "Expected: $TEMPLATE_FILE"
    exit 1
  fi
}

confirm_overwrite() {
  local output_file="$1"

  if [ -f "$output_file" ]; then
    printf "%b\n" "${YELLOW}File $output_file already exists${NC}"
    read -p "Overwrite? (y/n) " -n 1 -r
    printf "\n"

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      printf "%b\n" "${YELLOW}Generation cancelled.${NC}"
      exit 0
    fi
  fi
}

generate_installer() {
  local project_lower="$1"
  local project_cap="$2"
  local output_file="$3"

  printf "%b\n" "${BLUE}Generating installer for: $project_lower${NC}"
  printf "%b\n" "${BLUE}Output: $output_file${NC}"

  # Use sed to:
  # 1. Remove TEMPLATE USAGE section (lines 4-22)
  # 2. Replace placeholders
  sed \
    -e '4,22d' \
    -e "s/{{project}}/$project_lower/g" \
    -e "s/{{Project}}/$project_cap/g" \
    "$TEMPLATE_FILE" > "$output_file"

  # Make executable
  chmod +x "$output_file"

  printf "%b\n\n" "${GREEN}✓ Generated $output_file successfully!${NC}"
}

print_next_steps() {
  local project="$1"
  local output_file="$2"

  printf "%b\n" "${GREEN}Next steps:${NC}"
  printf "%s\n" "1. Review the generated $output_file"
  printf "%s\n" "2. Test: $output_file"
  printf "%s\n" "3. Commit to your $project repository"
}

# ============================================================================
# Main
# ============================================================================

main() {
  validate_arguments "$@"

  local project_lower="$1"
  local output_dir="${2:-.}"  # Default to current directory

  validate_project_name "$project_lower"
  validate_output_dir "$output_dir"

  # Resolve to absolute path
  output_dir="$(cd "$output_dir" && pwd)"

  local output_file="$output_dir/$OUTPUT_FILENAME"
  local project_cap
  project_cap=$(capitalize_first_letter "$project_lower")

  check_template_exists
  confirm_overwrite "$output_file"
  generate_installer "$project_lower" "$project_cap" "$output_file"
  print_next_steps "$project_lower" "$output_file"
}

# Entry point
main "$@"
