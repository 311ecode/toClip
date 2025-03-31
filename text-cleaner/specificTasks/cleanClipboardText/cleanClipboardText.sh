#!/bin/bash

# Main function - generic clipboard text processor
cleanClipboardText() {
  local prompt="$1"
  local systemPrompt="$2"
  
  if [[ -z "$prompt" || -z "$systemPrompt" ]]; then
    echo "Error: Both prompt and system prompt are required" >&2
    echo "Usage: cleanClipboardText PROMPT SYSTEM_PROMPT" >&2
    return 1
  fi

  echo "Retrieving text from clipboard..." >&2
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "Error: Clipboard is empty" >&2
    notifyCompletion 1
    return 1
  fi

  echo "Sending text to AI for processing..." >&2
  local processedText=$(cleanText "$clipboardContent" "$prompt" "$systemPrompt")
  
  if [[ -z "$processedText" ]]; then
    echo "Error: Failed to get a response from AI" >&2
    notifyCompletion 1
    return 1
  fi

  echo "Processing complete. Copying result to clipboard..." >&2
  toClip "$processedText" "Processed text copied to clipboard."
  notifyCompletion 0
}
