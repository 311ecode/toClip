#!/usr/bin/env bash
toClip_testCommandModeConsistency() {
    echo "🔗 Testing consistency with -c command mode"

    toClip_clear_clipboard
    toClip -c 'echo "cmd stdout"; echo "cmd stderr" >&2'
    local command_clipboard="$(toClip_get_clipboard)"

    toClip_clear_clipboard
    sh -c 'echo "cmd stdout"; echo "cmd stderr" >&2' 2>&1 | toClip 2>/dev/null
    local pipe_clipboard="$(toClip_get_clipboard)"

    # Both should contain the same stdout/stderr content (though command mode has "Executed:" prefix)
    if [[ "$command_clipboard" == *"cmd stdout"* ]] && [[ "$command_clipboard" == *"cmd stderr"* ]] &&
       [[ "$pipe_clipboard" == *"cmd stdout"* ]] && [[ "$pipe_clipboard" == *"cmd stderr"* ]]; then
      echo "✅ SUCCESS: Both command and pipe modes capture stdout and stderr"
      return 0
    else
      echo "❌ ERROR: Both modes should capture stdout and stderr consistently"
      echo "Command mode: '$command_clipboard'"
      echo "Pipe mode: '$pipe_clipboard'"
      return 1
    fi
  }
