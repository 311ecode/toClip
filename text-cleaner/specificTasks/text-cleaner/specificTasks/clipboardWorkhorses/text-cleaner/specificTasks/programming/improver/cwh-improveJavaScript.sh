#!/bin/bash
# @file cwh-improveJavaScript.sh
# @brief Workhorse for comprehensively improving JavaScript code readability
# @description This script analyzes JavaScript code from the clipboard and
#              improves it by renaming variables/functions, adding helpful comments,
#              and applying light refactoring to enhance readability

cwh-improveJavaScript() {
  local improvements="all"
  
  # Check if specific improvements are requested
  if [[ -n "$1" ]]; then
    improvements="$1"
  fi
  
  echo "[INFO] Processing JavaScript code for comprehensive improvements" >&2
  
  # Get code from clipboard
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process JavaScript code
  local processedCode=$(universalCodeImprover "JavaScript" "$clipboardContent" "$improvements")
  
  if [[ -z "$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedCode" "JavaScript code improved"
  notifyCompletion 0
  return 0
}

# Function to provide bash completion for cwh-improveJavaScript
_cwh_improveJavaScript_complete() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # Define improvement options
  opts="all rename comment refactor rename,comment rename,refactor comment,refactor"
  
  COMPREPLY=( $(compgen -W "${opts}" -- "$cur") )
  return 0
}

complete -F _cwh_improveJavaScript_complete cwh-improveJavaScript
