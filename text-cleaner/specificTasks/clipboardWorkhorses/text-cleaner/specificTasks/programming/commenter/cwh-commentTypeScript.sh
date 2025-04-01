#!/bin/bash
# @file cwh-commentTypeScript.sh
# @brief Workhorse for commenting TypeScript code
cwh-commentTypeScript() {
  echo "[INFO] Processing TypeScript code" >&2
  
  # Get code from clipboard
  local clipboardContent="$(getFromClip)"
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process TypeScript code
  local processedCode=$(universalCodeCommenter "TypeScript" "$clipboardContent")
  
  if [[ -z "$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedCode" "TypeScript code commented"
  notifyCompletion 0
  return 0
}
