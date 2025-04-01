#!/bin/bash
# @file setupCommenters.sh
# @brief Function to set up code commenters for all major languages
# @description This script provides a function that automatically generates
#              code commenter functions for all major programming languages

# Source the commenter generator
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/createCommenter.sh"

setupCommenters() {
  local quiet=${1:-false}
  
  # Common programming languages to create commenters for
  local createCommenterProgrammingLanguages=(
    "Python"
    "JavaScript"
    "TypeScript"
    "Java"
    "CSharp"
    "CPlusPlus"
    "C"
    "Go"
    "Rust"
    "Swift"
    "Kotlin"
    "PHP"
    "Ruby"
    "Bash"
    "PowerShell"
    "SQL"
    "R"
    "Perl"
    "Scala"
    "Dart"
    "HTML"
    "CSS"
    "XML"
    "YAML"
    "Markdown"
  )

  # Create commenters for all languages
  [[ "$quiet" != "true" ]] && echo "Creating code commenter functions..."
  local created=0
  
  for lang in "${createCommenterProgrammingLanguages[@]}"; do
    createCommenter "$lang" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      [[ "$quiet" != "true" ]] && echo "  - Created commenter for $lang"
      ((created++))
    fi
  done

  [[ "$quiet" != "true" ]] && echo "Setup complete. Created $created code commenter functions."
  [[ "$quiet" != "true" ]] && echo "Use cwhSelector to select a commenter (e.g., cwhSelector commentPython)."
  
  return 0
}
