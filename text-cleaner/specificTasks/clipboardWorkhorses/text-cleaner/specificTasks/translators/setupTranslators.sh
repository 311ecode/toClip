#!/bin/bash
# @file setupTranslators.sh
# @brief Function to set up translator functions for all common languages
# @description This script provides a function that automatically generates
#              translator functions for all common languages

setupTranslators() {
  local quiet=${1:-false}
  
  # Get the directory where this script resides
  local script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

  # Source the translator generator using a relative path
  source "$script_dir/createTranslator.sh"

  # Common languages to create translators for
  local createTranslatorLanguages=(
    "English"
    "Dutch"
    "Russian"
    "German"
    "French"
    "Spanish"
    "Italian"
    "Portuguese"
    "Chinese"
    "Japanese"
    "Korean"
    "Arabic"
    "Hindi"
    "Swedish"
    "Norwegian"
    "Danish"
    "Finnish"
    "Polish"
    "Czech"
    "Hungarian"
    "Greek"
    "Turkish"
    "Hebrew"
    "Thai"
    "Vietnamese"
  )

  # Create translators for all languages
  [[ "$quiet" != "true" ]] && echo "Creating translator functions..."
  local created=0
  for lang in "${createTranslatorLanguages[@]}"; do
    if [[ "$quiet" == "true" ]]; then
      createTranslator "$lang" > /dev/null 2>&1
    else
      createTranslator "$lang" > /dev/null 2>&1
      if [ $? -eq 0 ]; then
        echo "  - Created translator for $lang"
      fi
    fi
    
    # Count created translators
    if [ $? -eq 0 ]; then
      ((created++))
    fi
  done

  [[ "$quiet" != "true" ]] && echo "Setup complete. Created $created translator functions."
  [[ "$quiet" != "true" ]] && echo "Use cwhSelector to select a translator."
  
  return 0
}

# If this script is executed directly, run the setupTranslators function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setupTranslators "$@"
fi
