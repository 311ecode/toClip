#!/bin/bash
# @file cwh-renameJava.sh
# @brief Workhorse for renaming variables and functions in Java code
cwh-renameTypescript() {
  echo "[INFO] Processing Java code for improved variable names" >&2
  
  # Get code from clipboard
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Process Java code
  local processedCode=$(universalCodeRenamer "Typescript" "$clipboardContent")
  
  if [[ -z "$processedCode" ]]; then
    echo "[ERROR] Failed to process code" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedCode" "Java code variable names improved"
  notifyCompletion 0
  return 0
}
