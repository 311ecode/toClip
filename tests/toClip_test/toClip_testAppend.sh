#!/usr/bin/env bash
toClip_testAppend() {
    echo "➕ Testing append functionality"
    
    toClip_clear_clipboard
    toClip "initial"
    toClip -a " appended"
    local expected="initial appended"
    local clipboard="$(toClip_get_clipboard)"
    
    echo "Debug Test 2: Expected '$expected'"
    echo "Debug Test 2: Got '$clipboard'"
    
    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Append"
      return 0
    else
      echo "❌ ERROR: Append, got '$clipboard' expected '$expected'"
      return 1
    fi
  }