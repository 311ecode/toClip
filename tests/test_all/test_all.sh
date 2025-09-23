#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

# @file test_all.sh
# @brief Main test suite for toClip clipboard utilities
# @description Comprehensive test suite that runs all toClip tests using bashTestRunner framework

# Main test suite function with nested structure 🎯
toClip_testAllSuites() {
  export LC_NUMERIC=C  # 🔢 Ensures consistent numbers—must-have!

  echo "🚀 Starting comprehensive toClip test suite..."
  echo "════════════════════════════════════════════════"


  # Test function registry 📋
  local test_functions=(
    "toClip_testStderrCapture"
    "toClip_testMainFunctionality"
    "toClip_testAutoCommand"
  )

  local ignored_tests=()  # 🚫 Add test names to skip if needed


  bashTestRunner test_functions ignored_tests
  local exit_code=$?


}
