#!/usr/bin/env bash
toClip_testPipeWithSource() {
    echo "📝 Testing pipe with source"

    toClip_clear_clipboard
    printf "piped" | toClip -s "echo piped"
    local expected="Executed: echo piped\npiped"
    local clipboard="$(toClip_get_clipboard)"

    echo "Debug Test 9: Expected '$expected'"
    echo "Debug Test 9: Got '$clipboard'"

    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Pipe with source"
      return 0
    else
      echo "❌ ERROR: Pipe with source, got '$clipboard' expected '$expected'"
      return 1
    fi
  }
