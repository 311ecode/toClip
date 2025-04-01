#!/bin/bash
# @file createObfuscator.sh
# @brief Function to create new code obfuscator functions
# @description This script provides a function that generates code obfuscator
#              functions for additional programming languages

createObfuscator() {
  local language="$1"
  
  # Get the directory where this script resides
  local script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  
  # Create path relative to this script's location
  local fileName="${script_dir}/../obfuscator/cwh-obfuscate${language}.sh"
  
  # Ensure language name is provided
  if [[ -z "$language" ]]; then
    echo "Usage: createObfuscator LanguageName"
    echo "Example: createObfuscator Rust"
    return 1
  fi
  
  # Capitalize first letter
  language="${language^}"
  
  # Check if file already exists
  if [[ -f "$fileName" ]]; then
    echo "Obfuscator for $language already exists: $fileName"
    return 1
  fi
  
  # Create the obfuscator file
  cat > "$fileName" << EOF
#!/bin/bash
# @file cwh-obfuscate${language}.sh
# @brief Workhorse for deliberately obfuscating ${language} code
# @description This script takes ${language} code from the clipboard and
#              makes it harder to read by shortening variable names,
#              removing comments, and restructuring code while preserving functionality

cwh-obfuscate${language}() {
  local techniques="all"
  
  # Check if specific techniques are requested
  if [[ -n "\$1" ]]; then
    techniques="\$1"
  fi
  
  echo "[INFO] Processing ${language} code for obfuscation" >&2
  
  # Get code from clipboard
  local clipboardContent=\$(getFromClip)
  
  if [[ -z "\$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process ${language} code
  local processedCode=\$(universalCodeObfuscator "${language}" "\$clipboardContent" "\$techniques")
  
  if [[ -z "\$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "\$processedCode" "${language} code obfuscated"
  notifyCompletion 0
  return 0
}

# Function to provide bash completion for cwh-obfuscate${language}
_cwh_obfuscate${language}_complete() {
  local cur prev opts
  COMPREPLY=()
  cur="\${COMP_WORDS[COMP_CWORD]}"
  prev="\${COMP_WORDS[COMP_CWORD-1]}"
  
  # Define obfuscation options
  opts="all rename uncomment restructure rename,uncomment rename,restructure uncomment,restructure"
  
  COMPREPLY=( \$(compgen -W "\${opts}" -- "\$cur") )
  return 0
}

complete -F _cwh_obfuscate${language}_complete cwh-obfuscate${language}
EOF
  
  # Make it executable
  chmod +x "$fileName"
  
  echo "Created obfuscator function for ${language} code at: $fileName"
  echo "You can now use it with: cwhSelector obfuscate${language}"
  
  return 0
}
