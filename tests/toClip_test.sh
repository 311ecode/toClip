#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

test_toClip() {
  if ! command -v xclip >/dev/null 2>&1; then
    echo "Error: xclip not found. Tests require xclip to verify clipboard contents."
    return 1
  fi

  local fail_count=0

  # Function to clear clipboard content
  clear_clipboard() {
    echo -n "" | xclip -selection clipboard
  }

  # Function to get clipboard content preserving trailing newlines
  get_clipboard() {
    temp=$(
      xclip -o -selection clipboard
      echo .
    )
    temp=${temp%.}
    printf "%s" "$temp"
  }

  # Test 1: Basic copy
  clear_clipboard
  toClip "test"
  expected="test"
  clipboard="$(get_clipboard)"
  echo "Debug Test 1: Expected '$expected'"
  echo "Debug Test 1: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Basic copy"
  else
    echo "Fail: Basic copy, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # Test 2: Append
  clear_clipboard
  toClip "initial"
  toClip -a " appended"
  expected="initial appended"
  clipboard="$(get_clipboard)"
  echo "Debug Test 2: Expected '$expected'"
  echo "Debug Test 2: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Append"
  else
    echo "Fail: Append, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # Test 3: Prepend
  clear_clipboard
  toClip "initial"
  toClip -p "prepended "
  expected="prepended initial"
  clipboard="$(get_clipboard)"
  echo "Debug Test 3: Expected '$expected'"
  echo "Debug Test 3: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Prepend"
  else
    echo "Fail: Prepend, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # Test 4: Command with stdout only
  clear_clipboard
  toClip -c 'printf "%s" "out"'
  expected="Executed: printf \"%s\" \"out\"\nout"
  clipboard="$(get_clipboard)"
  echo "Debug Test 4: Expected '$expected'"
  echo "Debug Test 4: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Command stdout only"
  else
    echo "Fail: Command stdout only, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # Test 5: Command with stderr only
  clear_clipboard
  toClip -c 'printf "%s" "err" >&2'
  expected="Executed: printf \"%s\" \"err\" >&2\nerr"
  clipboard="$(get_clipboard)"
  echo "Debug Test 5: Expected '$expected'"
  echo "Debug Test 5: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Command stderr only"
  else
    echo "Fail: Command stderr only, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # Test 6: Command with both stdout and stderr
  clear_clipboard
  toClip -c 'printf "%s" "out"; printf "%s" "err" >&2'
  expected="Executed: printf \"%s\" \"out\"; printf \"%s\" \"err\" >&2\nouterr"
  clipboard="$(get_clipboard)"
  echo "Debug Test 6: Expected '$expected'"
  echo "Debug Test 6: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Command with both"
  else
    echo "Fail: Command with both, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # # Test 7: Multiple commands - using literal newline format
  # clear_clipboard
  # toClip -c 'printf "%s" "cmd1"' -c 'printf "%s" "cmd2"'
  # expected=$'Executed: printf "%s" "cmd1"\ncmd1\nExecuted: printf "%s" "cmd2"\ncmd2'
  # clipboard="$(get_clipboard)"
  # echo "Debug Test 7: Expected '$expected'"
  # echo "Debug Test 7: Got '$clipboard'"
  # if [ "$clipboard" = "$expected" ]; then
  #   echo "Pass: Multiple commands"
  # else
  #   echo "Fail: Multiple commands, got '$clipboard' expected '$expected'"
  #   ((fail_count++))
  # fi

  # Test 8: Pipe input
  clear_clipboard
  printf "piped" | toClip
  expected="piped"
  clipboard="$(get_clipboard)"
  echo "Debug Test 8: Expected '$expected'"
  echo "Debug Test 8: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Pipe input"
  else
    echo "Fail: Pipe input, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # Test 9: Pipe with source
  clear_clipboard
  printf "piped" | toClip -s "echo piped"
  expected="Executed: echo piped\npiped"
  clipboard="$(get_clipboard)"
  echo "Debug Test 9: Expected '$expected'"
  echo "Debug Test 9: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Pipe with source"
  else
    echo "Fail: Pipe with source, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # Test 10: Text with source
  clear_clipboard
  toClip -s "manual input" "some text"
  expected="Executed: manual input\nsome text"
  clipboard="$(get_clipboard)"
  echo "Debug Test 10: Expected '$expected'"
  echo "Debug Test 10: Got '$clipboard'"
  if [ "$clipboard" = "$expected" ]; then
    echo "Pass: Text with source"
  else
    echo "Fail: Text with source, got '$clipboard' expected '$expected'"
    ((fail_count++))
  fi

  # Test 11: Error when using -s with -c
  clear_clipboard
  output=$(toClip -s "source" -c "echo test" 2>&1)
  echo "Debug Test 11: Output '$output'"
  if [[ $output == *"Error: Cannot use --source with --command"* ]]; then
    echo "Pass: Error -s with -c"
  else
    echo "Fail: Error -s with -c, got '$output'"
    ((fail_count++))
  fi

  # Test 12: Skip auto source test since it's environment dependent
  # The auto-source feature depends on process detection which varies by environment
  echo "Skip: Auto source test (environment dependent)"

  if [ $fail_count -gt 0 ]; then
    echo "Total failures: $fail_count"
    return 1
  else
    echo "All tests passed"
    return 0
  fi
}
