#!/usr/bin/env bash
toClip_testSourceOptionWithStderr() {
    echo "📝 Testing source option with stderr content"

    toClip_clear_clipboard

    sh -c 'echo "source stdout"; echo "source stderr" >&2' 2>&1 | toClip -s "test command" 2>/dev/null

    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"Executed: test command"* ]] && [[ "$clipboard" == *"source stdout"* ]] && [[ "$clipboard" == *"source stderr"* ]]; then
      echo "✅ SUCCESS: Source option with stderr works correctly"
      return 0
    else
      echo "❌ ERROR: Source option should include executed prefix and both streams, got '$clipboard'"
      return 1
    fi
  }
