#!/bin/bash
# @file setup.sh
# @brief Setup script to generate all common language translators
# @description This script automatically generates translator functions for common languages

# Source the translator generator
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/createTranslator.sh"

# Common languages to create translators for
languages=(
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
echo "Creating translator functions..."
created=0
for lang in "${languages[@]}"; do
  createTranslator "$lang" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "  - Created translator for $lang"
    ((created++))
  fi
done

echo "Setup complete. Created $created translator functions."
echo "Use cwhSelector to select a translator."
