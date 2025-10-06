#!/usr/bin/env bash
toClip_testAutoCommandSingle() {
    echo "Testing auto-command detection with a single simple command"

    toClip_clear_clipboard
    # 'pwd' is a reliable, simple command with no output variance
    toClip 'pwd' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"Executed: pwd"* ]] && [[ "$clipboard" == *"/"* ]]; then
        echo "SUCCESS: Single simple command auto-detected"
        return 0
    else
        echo "ERROR: Single simple command not auto-detected"
        echo "Got: '$clipboard'"
        return 1
    fi
}