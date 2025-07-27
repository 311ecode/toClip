#!/usr/bin/env bash
toClip_testAppendModeWithStderr() {
    echo "➕ Testing append mode with stderr content"
    
    toClip_clear_clipboard
    toClip "initial content"
    
    # Generate combined output and pipe it with additional text
    sh -c 'echo "appended stdout"; echo "appended stderr" >&2' 2>&1 | toClip -a " + piped" 2>/dev/null
    
    local clipboard="$(toClip_get_clipboard)"
    
    # Debug output to see what we actually got
    echo "DEBUG: Expected to contain: 'initial content', 'appended stdout', 'appended stderr', ' + piped'"
    echo "DEBUG: Actual clipboard content: '$clipboard'"
    
    # Check for all required components
    if [[ "$clipboard" == *"initial content"* ]] && 
       [[ "$clipboard" == *"appended stdout"* ]] && 
       [[ "$clipboard" == *"appended stderr"* ]] && 
       [[ "$clipboard" == *" + piped"* ]]; then
      echo "✅ SUCCESS: Append mode with stderr works correctly"
      return 0
    else
      echo "❌ ERROR: Append mode should include initial content, piped text, and both streams"
      echo "Got: '$clipboard'"
      return 1
    fi
}