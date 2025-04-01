#!/bin/bash
# @file setupRenamers.sh
# @brief Function to set up code variable renamers for all major languages
# @description This script provides a function that automatically generates
#              code variable/function renamer functions for all major programming languages

# Source the renamer generator
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/createRenamer.sh"

setupRenamers() {
  local quiet=${1:-false}
  
  # Common programming languages to create renamers for
  local createRenamerProgrammingLanguages=(
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

  # Create renamers for all languages
  [[ "$quiet" != "true" ]] && echo "Creating code variable renamer functions..."
  local created=0
  
  for lang in "${createRenamerProgrammingLanguages[@]}"; do
    createRenamer "$lang" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      [[ "$quiet" != "true" ]] && echo "  - Created variable renamer for $lang"
      ((created++))
    fi
  done

  [[ "$quiet" != "true" ]] && echo "Setup complete. Created $created code variable renamer functions."
  [[ "$quiet" != "true" ]] && echo "Use cwhSelector to select a renamer (e.g., cwhSelector renamePython)."
  
  return 0
}
