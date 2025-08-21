#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

# @file toClip_stderr_test.sh
# @brief Test suite for toClip stderr capture functionality
# @description Comprehensive tests for the new stderr capture feature in piped input using bashTestRunner framework

# Main test suite function with nested structure 🎯
toClip_testStderrCapture() {
  export LC_NUMERIC=C  # 🔢 Ensures consistent numbers—must-have!

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

# Execute if run directly 🚀
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  toClip_testStderrCapture
fi
