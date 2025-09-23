#!/usr/bin/env bash
toClip_testExplicitCommand() {
    echo "Testing that explicit -c flag still works"

    toClip_clear_clipboard
    toClip -c 'echo "explicit"' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"Executed: echo \"explicit\""* ]] && [[ "$clipboard" == *"explicit"* ]]; then
      echo "SUCCESS: Explicit -c command works"
      return 0
    else
      echo "ERROR: Explicit -c command failed"
      echo "Got: '$clipboard'"
      return 1
    fi
  }