#!/usr/bin/env bash
toClip_testCommandStderrOnly() {
    echo "📥 Testing command with stderr only"

    toClip_clear_clipboard
    toClip -c 'printf "%s" "err" >&2'
    local expected="Executed: printf \"%s\" \"err\" >&2\nerr"
    local clipboard="$(toClip_get_clipboard)"

    echo "Debug Test 5: Expected '$expected'"
    echo "Debug Test 5: Got '$clipboard'"

    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Command stderr only"
      return 0
    else
      echo "❌ ERROR: Command stderr only, got '$clipboard' expected '$expected'"
      return 1
    fi
  }
