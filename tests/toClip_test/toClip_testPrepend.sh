#!/usr/bin/env bash
toClip_testPrepend() {
    echo "⬅️ Testing prepend functionality"

    toClip_clear_clipboard
    toClip "initial"
    toClip -p "prepended "
    local expected="prepended initial"
    local clipboard="$(toClip_get_clipboard)"

    echo "Debug Test 3: Expected '$expected'"
    echo "Debug Test 3: Got '$clipboard'"

    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Prepend"
      return 0
    else
      echo "❌ ERROR: Prepend, got '$clipboard' expected '$expected'"
      return 1
    fi
  }
