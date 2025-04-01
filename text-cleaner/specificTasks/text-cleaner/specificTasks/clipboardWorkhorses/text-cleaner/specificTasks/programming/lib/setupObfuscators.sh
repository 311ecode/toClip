#!/bin/bash
# @file setupObfuscators.sh
# @brief Function to set up code obfuscators for all major languages
# @description This script provides a function that automatically generates
#              code obfuscator functions for all major programming languages

# Source the obfuscator generator
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/createObfuscator.sh"

setupObfuscators() {
  local quiet=${1:-false}
  
  # Common programming languages to create obfuscators for
  local createObfuscatorProgrammingLanguages=(
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

  # Create obfuscators for all languages
  [[ "$quiet" != "true" ]] && echo "Creating code obfuscator functions..."
  local created=0
  
  for lang in "${createObfuscatorProgrammingLanguages[@]}"; do
    createObfuscator "$lang" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      [[ "$quiet" != "true" ]] && echo "  - Created code obfuscator for $lang"
      ((created++))
    fi
  done

  [[ "$quiet" != "true" ]] && echo "Setup complete. Created $created code obfuscator functions."
  [[ "$quiet" != "true" ]] && echo "Use cwhSelector to select an obfuscator (e.g., cwhSelector obfuscatePython)."
  [[ "$quiet" != "true" ]] && echo "You can also specify obfuscation techniques: cwhSelector; obfuscateJavaScript rename,uncomment"
  
  return 0
}
