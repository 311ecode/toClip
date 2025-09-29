#!/usr/bin/env bash
toClip_testMainFunctionality() {
  export LC_NUMERIC=C

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
    "toClip_testAutoCommandWithEnvVar"
    "toClip_testEnvVarWithCommand"
  )

  local ignored_tests=()

  bashTestRunner test_functions ignored_tests
}