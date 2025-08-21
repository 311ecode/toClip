#!/usr/bin/env bash
toClip_testPipeInput() {
    echo "🚰 Testing pipe input"

    toClip_clear_clipboard
    printf "piped" | toClip
    local expected="piped"
    local clipboard="$(toClip_get_clipboard)"

    echo "Debug Test 8: Expected '$expected'"
    echo "Debug Test 8: Got '$clipboard'"

    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Pipe input"
      return 0
    else
      echo "❌ ERROR: Pipe input, got '$clipboard' expected '$expected'"
      return 1
    fi
  }
