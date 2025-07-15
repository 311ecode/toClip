#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

test_toClip() {
  if ! command -v xclip >/dev/null 2>&1; then
    echo "Error: xclip not found. Tests require xclip to verify clipboard contents."
    return 1
  fi

  # Function to clear clipboard content
  clear_clipboard() {
    echo -n "" | xclip -selection clipboard
  }

  # Function to get clipboard content
  get_clipboard() {
    xclip -o -selection clipboard
  }

  # Test 1: Basic copy
  clear_clipboard
  toClip "test"
  if [ "$(get_clipboard)" = "test" ]; then
    echo "Pass: Basic copy"
  else
    echo "Fail: Basic copy, got '$(get_clipboard)'"
  fi

  # Test 2: Append
  clear_clipboard
  toClip "initial"
  toClip -a " appended"
  if [ "$(get_clipboard)" = "initial appended" ]; then
    echo "Pass: Append"
  else
    echo "Fail: Append, got '$(get_clipboard)'"
  fi

  # Test 3: Prepend
  clear_clipboard
  toClip "initial"
  toClip -p "prepended "
  if [ "$(get_clipboard)" = "prepended initial" ]; then
    echo "Pass: Prepend"
  else
    echo "Fail: Prepend, got '$(get_clipboard)'"
  fi

  # Test 4: Command with stdout only
  clear_clipboard
  toClip -c 'printf "%s" "out"'
  if [ "$(get_clipboard)" = $'out\n' ]; then
    echo "Pass: Command stdout only"
  else
    echo "Fail: Command stdout, got '$(get_clipboard)'"
  fi

  # Test 5: Command with stderr only
  clear_clipboard
  toClip -c 'printf "%s" "err" >&2'
  if [ "$(get_clipboard)" = $'err\n' ]; then
    echo "Pass: Command stderr only"
  else
    echo "Fail: Command stderr, got '$(get_clipboard)'"
  fi

  # Test 6: Command with both stdout and stderr
  clear_clipboard
  toClip -c 'printf "%s" "out"; printf "%s" "err" >&2'
  if [ "$(get_clipboard)" = $'outerr\n' ]; then
    echo "Pass: Command with both"
  else
    echo "Fail: Command with both, got '$(get_clipboard)'"
  fi

  # Test 7: Multiple commands
  clear_clipboard
  toClip -c 'printf "%s" "cmd1"' -c 'printf "%s" "cmd2"'
  if [ "$(get_clipboard)" = $'cmd1\ncmd2\n' ]; then
    echo "Pass: Multiple commands"
  else
    echo "Fail: Multiple commands, got '$(get_clipboard)'"
  fi

  # Test 8: Pipe input
  clear_clipboard
  echo "piped" | toClip
  if [ "$(get_clipboard)" = "piped" ]; then
    echo "Pass: Pipe input"
  else
    echo "Fail: Pipe input, got '$(get_clipboard)'"
  fi
}