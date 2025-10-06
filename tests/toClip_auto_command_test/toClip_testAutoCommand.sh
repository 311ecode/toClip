#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

toClip_testAutoCommand() {
  export LC_NUMERIC=C


  # Test function registry
  local test_functions=(
    "toClip_testAutoCommandEnvVar"
    "toClip_testAutoCommandMixedCaseEnvVar"
    "toClip_testAutoCommandSimple"
    "toClip_testAutoCommandPlainText"
    "toClip_testExplicitCommand"
    "toClip_testAutoCommandPipeline"
  )

  local ignored_tests=()

  # Check for xclip dependency
  if ! command -v xclip >/dev/null 2>&1; then
    echo "ERROR: xclip not found. Tests require xclip to verify clipboard contents."
    return 1
  fi

  echo "Running toClip auto-command detection tests..."

  bashTestRunner test_functions ignored_tests
  return $?
}