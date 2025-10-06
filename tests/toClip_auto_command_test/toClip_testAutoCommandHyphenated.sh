#!/usr/bin/env bash
toClip_testAutoCommandHyphenated() {
    echo "Testing auto-command detection with hyphenated command"

    # Create a dummy command with a hyphen for the test
    local SCRIPT_PATH
    SCRIPT_PATH="$(pwd)/dummy-script"
    echo '#!/bin/bash' > "$SCRIPT_PATH"
    echo 'echo "hyphenated"' >> "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"
    
    # Add dummy script's dir to PATH for this test
    local OLD_PATH="$PATH"
    export PATH="$(pwd):$PATH"

    toClip_clear_clipboard
    toClip 'dummy-script' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    # Restore PATH and clean up
    export PATH="$OLD_PATH"
    rm "$SCRIPT_PATH"

    if [[ "$clipboard" == *"Executed: dummy-script"* ]] && [[ "$clipboard" == *"hyphenated"* ]]; then
        echo "SUCCESS: Hyphenated command auto-detected"
        return 0
    else
        echo "ERROR: Hyphenated command not auto-detected"
        echo "Got: '$clipboard'"
        return 1
    fi
}