#!/usr/bin/env bash
toClip_testStdoutOnlyPipe() {
    echo "🧪 Testing stdout-only pipe capture"
    
    toClip_clear_clipboard
    echo "stdout only" | toClip
    local expected="stdout only"
    local clipboard="$(toClip_get_clipboard)"
    
    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Stdout-only pipe captured correctly"
      return 0
    else
      echo "❌ ERROR: Expected '$expected', got '$clipboard'"
      return 1
    fi
  }