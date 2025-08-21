#!/usr/bin/env bash
toClip_testMixedStreamsCapture() {
    echo "🔄 Testing mixed stdout and stderr capture"

    toClip_clear_clipboard

    # Create command that produces both streams and pipe to toClip
    sh -c 'echo "stdout content"; echo "stderr content" >&2' 2>&1 | toClip 2>/dev/null

    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"stdout content"* ]] && [[ "$clipboard" == *"stderr content"* ]]; then
      echo "✅ SUCCESS: Both stdout and stderr captured to clipboard"
      return 0
    else
      echo "❌ ERROR: Should capture both streams, got '$clipboard'"
      return 1
    fi
  }
