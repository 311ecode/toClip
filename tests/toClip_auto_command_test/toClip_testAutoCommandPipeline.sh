#!/usr/bin/env bash
toClip_testAutoCommandPipeline() {
    echo "Testing auto-command detection with pipeline"

    toClip_clear_clipboard
    toClip 'echo "test" | cat' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"Executed: echo \"test\" | cat"* ]] && [[ "$clipboard" == *"test"* ]]; then
      echo "SUCCESS: Pipeline command auto-detected"
      return 0
    else
      echo "ERROR: Pipeline command not auto-detected"
      echo "Got: '$clipboard'"
      return 1
    fi
  }