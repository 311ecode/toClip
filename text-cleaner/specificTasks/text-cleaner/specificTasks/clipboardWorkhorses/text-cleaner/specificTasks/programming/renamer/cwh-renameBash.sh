#!/bin/bash
# @file cwh-renameBash.sh
# @brief Workhorse for renaming variables and functions in Bash code
# @description This script analyzes Bash code from the clipboard,
#              improves variable and function names for better readability,
#              adds helpful comments where needed, and may restructure the code
#              slightly to improve readability while preserving functionality

cwh-renameBash() {
  echo "[INFO] Processing Bash code for improved readability" >&2
  
  # Get code from clipboard
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process Bash code
  local processedCode=$(universalCodeRenamer "Bash" "$clipboardContent")
  
  if [[ -z "$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedCode" "Bash code readability improved"
  notifyCompletion 0
  return 0
}
