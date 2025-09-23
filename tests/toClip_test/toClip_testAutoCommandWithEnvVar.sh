#!/usr/bin/env bash

# Helper function used only for this test
toClip_testAutoCommandWithEnvVar_fn() {
  echo "TCLIP_AUTOCMD_FLAG=$TCLIP_AUTOCMD_FLAG"
}

toClip_testAutoCommandWithEnvVar() {
  echo "🧪 Testing auto-command with custom env var + function"

  toClip_clear_clipboard
  # This should be auto-detected as a command: env var + function
  toClip 'TCLIP_AUTOCMD_FLAG=42 toClip_testAutoCommandWithEnvVar_fn' 2>/dev/null
  local clipboard="$(toClip_get_clipboard)"

  local expected_prefix="Executed: TCLIP_AUTOCMD_FLAG=42 toClip_testAutoCommandWithEnvVar_fn"
  local expected_value="TCLIP_AUTOCMD_FLAG=42"

  echo "Debug ENV: Expect prefix '$expected_prefix'"
  echo "Debug ENV: Got '$clipboard'"

  if [[ "$clipboard" == *"$expected_prefix"* ]] && \
     [[ "$clipboard" == *"$expected_value"* ]]; then
    echo "✅ SUCCESS: Auto-command with env var + function works"
    return 0
  else
    echo "❌ ERROR: Auto-command with env var + function failed"
    echo "Got: '$clipboard'"
    return 1
  fi
}