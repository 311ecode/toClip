#!/usr/bin/env bash
toClip_testBasicCopy() {
    echo "🧪 Testing basic copy"
    
    toClip_clear_clipboard
    toClip "test"
    local expected="test"
    local clipboard="$(toClip_get_clipboard)"
    
    echo "Debug Test 1: Expected '$expected'"
    echo "Debug Test 1: Got '$clipboard'"
    
    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Basic copy"
      return 0
    else
      echo "❌ ERROR: Basic copy, got '$clipboard' expected '$expected'"
      return 1
    fi
  }