#!/bin/bash
# @file cwh-obfuscateJavaScript.sh
# @brief Workhorse for deliberately obfuscating JavaScript code
# @description This script takes JavaScript code from the clipboard and
#              makes it harder to read by shortening variable names,
#              removing comments, and restructuring code while preserving functionality

cwh-obfuscateJavaScript() {
  local techniques="all"
  
  # Check if specific techniques are requested
  if [[ -n "$1" ]]; then
    techniques="$1"
  fi
  
  echo "[INFO] Processing JavaScript code for obfuscation" >&2
  
  # Get code from clipboard
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process JavaScript code
  local processedCode=$(universalCodeObfuscator "JavaScript" "$clipboardContent" "$techniques")
  
  if [[ -z "$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedCode" "JavaScript code obfuscated"
  notifyCompletion 0
  return 0
}

# Function to provide bash completion for cwh-obfuscateJavaScript
_cwh_obfuscateJavaScript_complete() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # Define obfuscation options
  opts="all rename uncomment restructure rename,uncomment rename,restructure uncomment,restructure"
  
  COMPREPLY=( $(compgen -W "${opts}" -- "$cur") )
  return 0
}

complete -F _cwh_obfuscateJavaScript_complete cwh-obfuscateJavaScript
