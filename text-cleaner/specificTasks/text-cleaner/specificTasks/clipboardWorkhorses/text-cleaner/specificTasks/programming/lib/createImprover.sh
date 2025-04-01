#!/bin/bash
# @file createImprover.sh
# @brief Function to create new comprehensive code improver functions
# @description This script provides a function that generates code improver
#              functions for additional programming languages

createImprover() {
  local language="$1"
  
  # Get the directory where this script resides
  local script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  
  # Create path relative to this script's location
  local fileName="${script_dir}/../improver/cwh-improve${language}.sh"
  
  # Ensure language name is provided
  if [[ -z "$language" ]]; then
    echo "Usage: createImprover LanguageName"
    echo "Example: createImprover Rust"
    return 1
  fi
  
  # Capitalize first letter
  language="${language^}"
  
  # Check if file already exists
  if [[ -f "$fileName" ]]; then
    echo "Improver for $language already exists: $fileName"
    return 1
  fi
  
  # Create the improver file
  cat > "$fileName" << EOF
#!/bin/bash
# @file cwh-improve${language}.sh
# @brief Workhorse for comprehensively improving ${language} code readability
# @description This script analyzes ${language} code from the clipboard and
#              improves it by renaming variables/functions, adding helpful comments,
#              and applying light refactoring to enhance readability

cwh-improve${language}() {
  local improvements="all"
  
  # Check if specific improvements are requested
  if [[ -n "\$1" ]]; then
    improvements="\$1"
  fi
  
  echo "[INFO] Processing ${language} code for comprehensive improvements" >&2
  
  # Get code from clipboard
  local clipboardContent=\$(getFromClip)
  
  if [[ -z "\$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process ${language} code
  local processedCode=\$(universalCodeImprover "${language}" "\$clipboardContent" "\$improvements")
  
  if [[ -z "\$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "\$processedCode" "${language} code improved"
  notifyCompletion 0
  return 0
}

# Function to provide bash completion for cwh-improve${language}
_cwh_improve${language}_complete() {
  local cur prev opts
  COMPREPLY=()
  cur="\${COMP_WORDS[COMP_CWORD]}"
  prev="\${COMP_WORDS[COMP_CWORD-1]}"
  
  # Define improvement options
  opts="all rename comment refactor rename,comment rename,refactor comment,refactor"
  
  COMPREPLY=( \$(compgen -W "\${opts}" -- "\$cur") )
  return 0
}

complete -F _cwh_improve${language}_complete cwh-improve${language}
EOF
  
  # Make it executable
  chmod +x "$fileName"
  
  echo "Created improver function for ${language} code at: $fileName"
  echo "You can now use it with: cwhSelector improve${language}"
  
  return 0
}
