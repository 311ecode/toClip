#!/usr/bin/env bash
toClip_testEnvVarWithCommand() {
    echo "Testing environment variable with command (DEBUG=1 ls)"

    toClip_clear_clipboard
    
    # Create a test function that uses the env var
    test_env_command() {
        echo "TEST_VAR=$TEST_VAR"
    }
    
    # Test auto-detection with env var + function
    toClip 'TEST_VAR=hello test_env_command' 2>/dev/null
    local clipboard="$(toClip_get_clipboard)"

    if [[ "$clipboard" == *"Executed: TEST_VAR=hello test_env_command"* ]] && \
       [[ "$clipboard" == *"TEST_VAR=hello"* ]]; then
      echo "SUCCESS: Environment variable with command auto-detected and executed"
      return 0
    else
      echo "ERROR: Environment variable with command not properly handled"
      echo "Got: '$clipboard'"
      return 1
    fi
}