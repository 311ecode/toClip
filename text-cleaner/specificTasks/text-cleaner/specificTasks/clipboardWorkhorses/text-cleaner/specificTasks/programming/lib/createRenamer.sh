#!/bin/bash
# @file createRenamer.sh
# @brief Function to create new code variable/function renamer functions
# @description This script provides a function that generates code renamer
#              functions for additional programming languages

createRenamer() {
  local language="$1"
  
  # Get the directory where this script resides
  local script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  
  # Create path relative to this script's location
  local fileName="${script_dir}/../renamer/cwh-rename${language}.sh"
  
  # Ensure language name is provided
  if [[ -z "$language" ]]; then
    echo "Usage: createRenamer LanguageName"
    echo "Example: createRenamer Rust"
    return 1
  fi
  
  # Capitalize first letter
  language="${language^}"
  
  # Check if file already exists
  if [[ -f "$fileName" ]]; then
    echo "Renamer for $language already exists: $fileName"
    return 1
  fi
  
  # Create the renamer file
  cat > "$fileName" << EOF
#!/bin/bash
# @file cwh-rename${language}.sh
# @brief Workhorse for renaming variables and functions in ${language} code
# @description This script analyzes ${language} code from the clipboard,
#              improves variable and function names for better readability,
#              adds helpful comments where needed, and may restructure the code
#              slightly to improve readability while preserving functionality

cwh-rename${language}() {
  echo "[INFO] Processing ${language} code for improved readability" >&2
  
  # Get code from clipboard
  local clipboardContent=\$(getFromClip)
  
  if [[ -z "\$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process ${language} code
  local processedCode=\$(universalCodeRenamer "${language}" "\$clipboardContent")
  
  if [[ -z "\$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "\$processedCode" "${language} code readability improved"
  notifyCompletion 0
  return 0
}
EOF
  
  # Make it executable
  chmod +x "$fileName"
  
  echo "Created renamer function for ${language} code at: $fileName"
  echo "You can now use it with: cwhSelector rename${language}"
  
  return 0
}
