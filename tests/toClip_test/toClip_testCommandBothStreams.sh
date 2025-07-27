#!/usr/bin/env bash
toClip_testCommandBothStreams() {
    echo "🔄 Testing command with both stdout and stderr"
    
    toClip_clear_clipboard
    toClip -c 'printf "%s" "out"; printf "%s" "err" >&2'
    local expected="Executed: printf \"%s\" \"out\"; printf \"%s\" \"err\" >&2\nouterr"
    local clipboard="$(toClip_get_clipboard)"
    
    echo "Debug Test 6: Expected '$expected'"
    echo "Debug Test 6: Got '$clipboard'"
    
    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Command with both streams"
      return 0
    else
      echo "❌ ERROR: Command with both, got '$clipboard' expected '$expected'"
      return 1
    fi
  }