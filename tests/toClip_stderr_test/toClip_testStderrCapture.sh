#!/usr/bin/env bash
toClip_testStderrCapture() {
  export LC_NUMERIC=C  # 🔢 Ensures consistent numbers—must-have!

  # Helper functions for all tests 🛠️
  toClip_clear_clipboard() {
    echo -n "" | xclip -selection clipboard
  }

  toClip_get_clipboard() {
    local temp=$(
      xclip -o -selection clipboard
      echo .
    )
    temp=${temp%.}
    printf "%s" "$temp"
  }

  # Test: Basic stdout-only pipe functionality 🧪
  toClip_testStdoutOnlyPipe() {
    echo "🧪 Testing stdout-only pipe capture"
    
    toClip_clear_clipboard
    echo "stdout only" | toClip
    local expected="stdout only"
    local clipboard="$(toClip_get_clipboard)"
    
    if [ "$clipboard" = "$expected" ]; then
      echo "✅ SUCCESS: Stdout-only pipe captured correctly"
      return 0
    else
      echo "❌ ERROR: Expected '$expected', got '$clipboard'"
      return 1
    fi
  }

  # Test: Mixed stdout and stderr capture 🔄
  toClip_testMixedStreamsCapture() {
    echo "🔄 Testing mixed stdout and stderr capture"
    
    toClip_clear_clipboard
    
    # Create command that produces both streams and pipe to toClip
    sh -c 'echo "stdout content"; echo "stderr content" >&2' 2>&1 | toClip 2>/dev/null
    
    local clipboard="$(toClip_get_clipboard)"
    
    if [[ "$clipboard" == *"stdout content"* ]] && [[ "$clipboard" == *"stderr content"* ]]; then
      echo "✅ SUCCESS: Both stdout and stderr captured to clipboard"
      return 0
    else
      echo "❌ ERROR: Should capture both streams, got '$clipboard'"
      return 1
    fi
  }

  # Test: Stderr-only output capture 🚨
  toClip_testStderrOnlyCapture() {
    echo "🚨 Testing stderr-only output capture"
    
    toClip_clear_clipboard
    
    # Command that only produces stderr
    sh -c 'echo "only stderr" >&2' 2>&1 | toClip 2>/dev/null
    
    local clipboard="$(toClip_get_clipboard)"
    
    if [[ "$clipboard" == *"only stderr"* ]]; then
      echo "✅ SUCCESS: Stderr-only output captured correctly"
      return 0
    else
      echo "❌ ERROR: Should capture stderr-only output, got '$clipboard'"
      return 1
    fi
  }

  # Test: Append mode with stderr content ➕
  toClip_testAppendModeWithStderr() {
    echo "➕ Testing append mode with stderr content"
    
    toClip_clear_clipboard
    toClip "initial content"
    
    # The key is using 2>&1 to combine streams BEFORE piping to toClip
    sh -c 'echo "appended stdout"; echo "appended stderr" >&2' 2>&1 | toClip -a " + piped" 2>/dev/null
    
    local clipboard="$(toClip_get_clipboard)"
    
    # Should contain: initial content + piped + appended stdout + appended stderr
    if [[ "$clipboard" == *"initial content"* ]] && [[ "$clipboard" == *"appended stdout"* ]] && [[ "$clipboard" == *"appended stderr"* ]] && [[ "$clipboard" == *" + piped"* ]]; then
      echo "✅ SUCCESS: Append mode with stderr works correctly"
      return 0
    else
      echo "❌ ERROR: Append mode should include initial content, piped text, and both streams"
      echo "Got: '$clipboard'"
      return 1
    fi
  }

  # Test: Prepend mode with stderr content ⬅️
  toClip_testPrependModeWithStderr() {
    echo "⬅️ Testing prepend mode with stderr content"
    
    # Save original clipboard state 🔒
    local saved_clipboard=""
    if command -v xclip >/dev/null 2>&1; then
      saved_clipboard=$(xclip -selection clipboard -o 2>/dev/null || true)
    fi
    
    toClip_clear_clipboard
    toClip "final content"
    
    # Use 2>&1 to combine streams before piping
    sh -c 'echo "prepended stdout"; echo "prepended stderr" >&2' 2>&1 | toClip -p "START: " 2>/dev/null
    
    local clipboard="$(toClip_get_clipboard)"
    
    # Restore clipboard state ✨
    if [[ -n "$saved_clipboard" ]]; then
      printf "%s" "$saved_clipboard" | xclip -selection clipboard 2>/dev/null || true
    fi
    
    # Should contain: START: + prepended stdout + prepended stderr + final content
    if [[ "$clipboard" == *"START:"* ]] && [[ "$clipboard" == *"prepended stdout"* ]] && [[ "$clipboard" == *"prepended stderr"* ]] && [[ "$clipboard" == *"final content"* ]]; then
      echo "✅ SUCCESS: Prepend mode with stderr works correctly"
      return 0
    else
      echo "❌ ERROR: Prepend mode should include prefix, both streams, and original content"
      echo "Got: '$clipboard'"
      return 1
    fi
  }

  # Test: Consistency with command mode behavior 🔗
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

  # Test: Source option with stderr 📝
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

  # Test: Manual verification for stderr visibility 👁️
  toClip_testStderrVisibility() {
    echo "👁️ Manual verification test - stderr should be visible in terminal"
    echo "Running command that produces both stdout and stderr..."
    echo "You should see 'visible stderr' printed below:"
    
    toClip_clear_clipboard
    
    # Use 2>&1 to combine streams, but also tee stderr to terminal for visibility
    sh -c 'echo "visible stdout"; echo "visible stderr" >&2' 2>&1 | tee >(grep "visible stderr" >&2) | toClip "Both captured" 2>/dev/null
    
    local clipboard="$(toClip_get_clipboard)"
    
    if [[ "$clipboard" == *"visible stdout"* ]] && [[ "$clipboard" == *"visible stderr"* ]]; then
      echo "✅ SUCCESS: Manual verification - both streams captured"
      echo "📋 Clipboard contains: '$clipboard'"
      return 0
    else
      echo "❌ ERROR: Manual verification failed"
      echo "Expected both 'visible stdout' and 'visible stderr' in clipboard"
      echo "Got: '$clipboard'"
      return 1
    fi
  }

  # Test function registry 📋
  local test_functions=(
    "toClip_testStdoutOnlyPipe"
    "toClip_testMixedStreamsCapture"
    "toClip_testStderrOnlyCapture"
    "toClip_testAppendModeWithStderr"
    "toClip_testPrependModeWithStderr"
    "toClip_testCommandModeConsistency"
    "toClip_testSourceOptionWithStderr"
    "toClip_testStderrVisibility"
  )

  local ignored_tests=()  # 🚫 Add test names to skip if needed

  # Check for xclip dependency first 🔍
  if ! command -v xclip >/dev/null 2>&1; then
    echo "❌ ERROR: xclip not found. Tests require xclip to verify clipboard contents."
    return 1
  fi

  echo "🚀 Running toClip stderr capture tests..."
  
  bashTestRunner test_functions ignored_tests
  return $?  # 🎉 Done!
}