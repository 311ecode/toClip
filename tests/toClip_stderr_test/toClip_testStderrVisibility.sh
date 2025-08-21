#!/usr/bin/env bash
toClip_testStderrVisibility() {
    echo "👁️ Testing stderr capture with simple approach"

    toClip_clear_clipboard

    # Simpler test - generate combined output then pipe it
    combined_output=$(sh -c 'echo "visible stdout"; echo "visible stderr" >&2' 2>&1)
    echo "$combined_output" | toClip 2>/dev/null

    local clipboard="$(toClip_get_clipboard)"

    echo "DEBUG: Expected to contain: 'visible stdout', 'visible stderr'"
    echo "DEBUG: Actual clipboard content: '$clipboard'"

    if [[ "$clipboard" == *"visible stdout"* ]] && [[ "$clipboard" == *"visible stderr"* ]]; then
      echo "✅ SUCCESS: Both streams captured correctly"
      echo "📋 Clipboard contains: '$clipboard'"
      return 0
    else
      echo "❌ ERROR: Should capture both streams"
      echo "Expected both 'visible stdout' and 'visible stderr' in clipboard"
      echo "Got: '$clipboard'"
      return 1
    fi
}
