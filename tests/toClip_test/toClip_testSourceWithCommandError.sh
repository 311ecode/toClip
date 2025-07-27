#!/usr/bin/env bash
toClip_testSourceWithCommandError() {
    echo "⚠️ Testing error when using -s with -c"
    
    toClip_clear_clipboard
    local output=$(toClip -s "source" -c "echo test" 2>&1)
    
    echo "Debug Test 11: Output '$output'"
    
    if [[ $output == *"Error: Cannot use --source with --command"* ]]; then
      echo "✅ SUCCESS: Error -s with -c"
      return 0
    else
      echo "❌ ERROR: Error -s with -c, got '$output'"
      return 1
    fi
  }