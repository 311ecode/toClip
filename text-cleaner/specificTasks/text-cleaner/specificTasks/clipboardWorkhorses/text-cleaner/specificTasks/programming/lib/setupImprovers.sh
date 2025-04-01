#!/bin/bash
# @file setupImprovers.sh
# @brief Function to set up comprehensive code improvers for all major languages
# @description This script provides a function that automatically generates
#              code improver functions for all major programming languages

# Source the improver generator
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/createImprover.sh"

setupImprovers() {
  local quiet=${1:-false}
  
  # Common programming languages to create improvers for
  local createImproverProgrammingLanguages=(
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

  # Create improvers for all languages
  [[ "$quiet" != "true" ]] && echo "Creating comprehensive code improver functions..."
  local created=0
  
  for lang in "${createImproverProgrammingLanguages[@]}"; do
    createImprover "$lang" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      [[ "$quiet" != "true" ]] && echo "  - Created code improver for $lang"
      ((created++))
    fi
  done

  [[ "$quiet" != "true" ]] && echo "Setup complete. Created $created comprehensive code improver functions."
  [[ "$quiet" != "true" ]] && echo "Use cwhSelector to select an improver (e.g., cwhSelector improvePython)."
  [[ "$quiet" != "true" ]] && echo "You can also specify improvement types: cwhSelector; improveJavaScript rename,comment"
  
  return 0
}
