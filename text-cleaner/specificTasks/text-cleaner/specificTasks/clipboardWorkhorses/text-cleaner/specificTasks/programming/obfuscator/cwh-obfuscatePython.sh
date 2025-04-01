#!/bin/bash
# @file cwh-obfuscatePython.sh
# @brief Workhorse for deliberately obfuscating Python code
# @description This script takes Python code from the clipboard and
#              makes it harder to read by shortening variable names,
#              removing comments, and restructuring code while preserving functionality

cwh-obfuscatePython() {
  local techniques="all"
  
  # Check if specific techniques are requested
  if [[ -n "$1" ]]; then
    techniques="$1"
  fi
  
  echo "[INFO] Processing Python code for obfuscation" >&2
  
  # Get code from clipboard
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process Python code
  local processedCode=$(universalCodeObfuscator "Python" "$clipboardContent" "$techniques")
  
  if [[ -z "$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedCode" "Python code obfuscated"
  notifyCompletion 0
  return 0
}

# Function to provide bash completion for cwh-obfuscatePython
_cwh_obfuscatePython_complete() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # Define obfuscation options
  opts="all rename uncomment restructure rename,uncomment rename,restructure uncomment,restructure"
  
  COMPREPLY=( $(compgen -W "${opts}" -- "$cur") )
  return 0
}

complete -F _cwh_obfuscatePython_complete cwh-obfuscatePython
