#!/usr/bin/env bash
toClip_testAutoCommandPlainText() {
    echo "Testing that plain text is NOT auto-detected as command"

    toClip_clear_clipboard
    toClip 'just some plain text' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == "just some plain text" ]]; then
      echo "SUCCESS: Plain text not auto-detected as command"
      return 0
    else
      echo "ERROR: Plain text was incorrectly auto-detected as command"
      echo "Got: '$clipboard'"
      return 1
    fi
  }