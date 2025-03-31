#!/bin/bash
setupTextCleanerShortcut() {
    local key_combo="${1:-<Control><Alt>z}"
    local command="bash -c 'tmux has-session -t text-cleaner 2>/dev/null && tmux send-keys -t text-cleaner \" cleanClipboardText\" C-m'"
    
    # Pass through any additional arguments (like --overwrite)
    setupKeyboardShortcut "Text Cleaner" "$command" "$key_combo" "$@"
}

