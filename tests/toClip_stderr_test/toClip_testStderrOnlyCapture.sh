#!/usr/bin/env bash
toClip_testStderrOnlyCapture() {
    echo "🚨 Testing stderr-only output capture"
    
    toClip_clear_clipboard
    
    # Command that only produces stderr
    sh -c 'echo "only stderr" >&2' 2>&1 | toClip 2>/dev/null
    
    local clipboard="$(toClip_get_clipboard)"
    
    if [[ "$clipboard" == *"only stderr"* ]]; then
      echo "✅ SUCCESS: Stderr-only output captured correctly"
      return 0
    else
      echo "❌ ERROR: Should capture stderr-only output, got '$clipboard'"
      return 1
    fi
  }