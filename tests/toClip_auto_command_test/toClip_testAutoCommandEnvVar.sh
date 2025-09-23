#!/usr/bin/env bash
toClip_testAutoCommandEnvVar() {
    echo "Testing auto-command detection with environment variable"

    toClip_clear_clipboard
    toClip 'DEBUG=1 echo "test"' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"Executed: DEBUG=1 echo \"test\""* ]] && [[ "$clipboard" == *"test"* ]]; then
      echo "SUCCESS: Environment variable command auto-detected"
      return 0
    else
      echo "ERROR: Environment variable command not auto-detected"
      echo "Got: '$clipboard'"
      return 1
    fi
  }