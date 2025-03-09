#!/bin/bash

toClip() {
  local output="$1"
  shift

  if command -v pbcopy >/dev/null 2>&1; then
    echo "$output" | pbcopy
    if [[ -n "$2" ]]; then
      echo "$2" >&2
    fi
  elif command -v xclip >/dev/null 2>&1; then
    echo "$output" | xclip -selection clipboard
    if [[ -n "$2" ]]; then
      echo "$2" >&2
    fi
  else
    echo "No clipboard utility found (pbcopy/xclip)." >&2
    # Output to stdout as fallback
    echo "$output"
  fi
}
