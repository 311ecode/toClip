#!/bin/bash
# @file cwh-commentBash.sh
# @brief Workhorse for commenting Bash code
cwh-commentBash() {
  echo "[INFO] Processing Bash code" >&2
  
  # Get code from clipboard
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process Bash code
  local processedCode=$(universalCodeCommenter "Bash" "$clipboardContent")
  
  if [[ -z "$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedCode" "Bash code commented"
  notifyCompletion 0
  return 0
}
