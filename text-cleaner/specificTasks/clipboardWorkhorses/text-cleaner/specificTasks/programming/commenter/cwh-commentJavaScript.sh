#!/bin/bash
# @file cwh-commentJavaScript.sh
# @brief Workhorse for commenting JavaScript code
cwh-commentJavaScript() {
  echo "[INFO] Processing JavaScript code" >&2
  
  # Get code from clipboard
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process JavaScript code
  local processedCode=$(universalCodeCommenter "JavaScript" "$clipboardContent")
  
  if [[ -z "$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedCode" "JavaScript code commented"
  notifyCompletion 0
  return 0
}
