#!/bin/bash
# @file translatorCommon.sh
# @brief Common function for all translator workhorses
# @description This script provides a shared function to handle the common
#              operations of all translator workhorses to reduce code duplication

# Function to handle common translator workhorse operations
cwhTranslate() {
  local targetLang="$1"
  
  # Minimal logging - just the target language
  echo "[INFO] Translating to $targetLang" >&2
  
  # Get text from clipboard
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "[ERROR] Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Let AI handle both detection and translation
  local processedText=$(universalTranslator "$targetLang" "$clipboardContent")
  
  if [[ -z "$processedText" ]]; then
    echo "[ERROR] Failed to translate" >&2
    notifyCompletion 1
    return 1
  fi
  
  # Copy result back to clipboard
  toClip "$processedText" "Translated to $targetLang"
  notifyCompletion 0
  return 0
}
