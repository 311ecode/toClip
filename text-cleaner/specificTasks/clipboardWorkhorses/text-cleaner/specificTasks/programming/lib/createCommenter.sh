#!/bin/bash
# @file createCommenter.sh
# @brief Function to create new code commenter functions
# @description This script provides a function that generates code commenter
#              functions for additional programming languages

createCommenter() {
  local language="$1"
  
  # Get the directory where this script resides
  local script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  
  # Create path relative to this script's location
  local fileName="${script_dir}/../clipboardWorkhorses/cwh-comment${language}.sh"
  
  # Ensure language name is provided
  if [[ -z "$language" ]]; then
    echo "Usage: createCommenter LanguageName"
    echo "Example: createCommenter Rust"
    return 1
  fi
  
  # Capitalize first letter
  language="${language^}"
  
  # Check if file already exists
  if [[ -f "$fileName" ]]; then
    echo "Commenter for $language already exists: $fileName"
    return 1
  fi
  
  # Create the commenter file
  cat > "$fileName" << EOF
#!/bin/bash
# @file cwh-comment${language}.sh
# @brief Workhorse for commenting ${language} code
cwh-comment${language}() {
  echo "[INFO] Processing ${language} code" >&2
  
  # Get code from clipboard
  local clipboardContent=\$(getFromClip)
  
  if [[ -z "\$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process ${language} code
  local processedCode=\$(universalCodeCommenter "${language}" "\$clipboardContent")
  
  if [[ -z "\$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "\$processedCode" "${language} code commented"
  notifyCompletion 0
  return 0
}
EOF
  
  # Make it executable
  chmod +x "$fileName"
  
  echo "Created commenter function for ${language} code at: $fileName"
  echo "You can now use it with: cwhSelector comment${language}"
  
  return 0
}
