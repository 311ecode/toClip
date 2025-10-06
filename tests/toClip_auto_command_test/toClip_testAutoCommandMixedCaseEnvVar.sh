#!/usr/bin/env bash
toClip_testAutoCommandMixedCaseEnvVar() {
    echo "Testing auto-command detection with mixed-case environment variable"

    toClip_clear_clipboard
    toClip 'Debug=1 echo "test"' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"Executed: Debug=1 echo \"test\""* ]] && [[ "$clipboard" == *"test"* ]]; then
        echo "SUCCESS: Mixed-case environment variable command auto-detected"
        return 0
    else
        echo "ERROR: Mixed-case environment variable command not auto-detected"
        echo "Got: '$clipboard'"
        return 1
    fi
}