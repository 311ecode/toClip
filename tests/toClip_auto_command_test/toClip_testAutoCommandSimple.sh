#!/usr/bin/env bash
toClip_testAutoCommandSimple() {
    echo "Testing auto-command detection with simple command"

    toClip_clear_clipboard
    toClip 'echo "simple"' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"Executed: echo \"simple\""* ]] && [[ "$clipboard" == *"simple"* ]]; then
      echo "SUCCESS: Simple command auto-detected"
      return 0
    else
      echo "ERROR: Simple command not auto-detected"
      echo "Got: '$clipboard'"
      return 1
    fi
  }