#!/usr/bin/env bash
toClip_testPrependModeWithStderr() {
    echo "⬅️ Testing prepend mode with stderr content"

    toClip_clear_clipboard
    toClip "final content"

    # Generate combined output and pipe with prefix
    sh -c 'echo "prepended stdout"; echo "prepended stderr" >&2' 2>&1 | toClip -p "START: " 2>/dev/null

    local clipboard="$(toClip_get_clipboard)"

    # Debug output
    echo "DEBUG: Expected to contain: 'START:', 'prepended stdout', 'prepended stderr', 'final content'"
    echo "DEBUG: Actual clipboard content: '$clipboard'"

    # Check for all required components
    if [[ "$clipboard" == *"START:"* ]] &&
       [[ "$clipboard" == *"prepended stdout"* ]] &&
       [[ "$clipboard" == *"prepended stderr"* ]] &&
       [[ "$clipboard" == *"final content"* ]]; then
      echo "✅ SUCCESS: Prepend mode with stderr works correctly"
      return 0
    else
      echo "❌ ERROR: Prepend mode should include prefix, both streams, and original content"
      echo "Got: '$clipboard'"
      return 1
    fi
}
