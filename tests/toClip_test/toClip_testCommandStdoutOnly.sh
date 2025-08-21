#!/usr/bin/env bash
toClip_testCommandStdoutOnly() {
    echo "📤 Testing command with stdout only"

    toClip_clear_clipboard
    toClip -c 'printf "%s" "out"'
    local expected="Executed: printf \"%s\" \"out\"\nout"
    local clipboard="$(toClip_get_clipboard)"

    echo "Debug Test 4: Expected '$expected'"
    echo "Debug Test 4: Got '$clipboard'"

    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Command stdout only"
      return 0
    else
      echo "❌ ERROR: Command stdout only, got '$clipboard' expected '$expected'"
      return 1
    fi
  }
