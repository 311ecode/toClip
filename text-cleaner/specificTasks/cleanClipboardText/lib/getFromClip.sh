#!/bin/bash
getFromClip() {
  local clipboardContent=""
  
  if command -v pbpaste >/dev/null 2>&1; then
    # macOS
    clipboardContent=$(pbpaste)
  elif command -v xclip >/dev/null 2>&1; then
    # Linux with xclip
    clipboardContent=$(xclip -selection clipboard -o)
  else
    echo "No clipboard utility found (pbpaste/xclip)" >&2
    return 1
  fi
  
  echo "$clipboardContent"
}
