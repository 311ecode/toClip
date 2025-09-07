#!/usr/bin/env bash
toClip_testMainFunctionality() {
  export LC_NUMERIC=C  # 🔢 Ensures consistent numbers—must-have!

  # Test function registry 📋
  local test_functions=(
    "toClip_testBasicCopy"
    "toClip_testAppend"
    "toClip_testPrepend"
    "toClip_testCommandStdoutOnly"
    "toClip_testCommandStderrOnly"
    "toClip_testCommandBothStreams"
    "toClip_testPipeInput"
    "toClip_testPipeWithSource"
    "toClip_testTextWithSource"
    "toClip_testSourceWithCommandError"
    "toClip_testAutoSourceSkip"
  )
    # "toClip_testPassthrough"  # Added passthrough test

  local ignored_tests=()  # 🚫 Add test names to skip if needed


  bashTestRunner test_functions ignored_tests
}