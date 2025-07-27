#!/usr/bin/env bash
toClip_testTextWithSource() {
    echo "📄 Testing text with source"
    
    toClip_clear_clipboard
    toClip -s "manual input" "some text"
    local expected="Executed: manual input\nsome text"
    local clipboard="$(toClip_get_clipboard)"
    
    echo "Debug Test 10: Expected '$expected'"
    echo "Debug Test 10: Got '$clipboard'"
    
    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Text with source"
      return 0
    else
      echo "❌ ERROR: Text with source, got '$clipboard' expected '$expected'"
      return 1
    fi
  }