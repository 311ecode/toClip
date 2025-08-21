#!/usr/bin/env bash
toClip_testAutoSourceSkip() {
    echo "🚫 Skip: Auto source test (environment dependent)"
    echo "The auto-source feature depends on process detection which varies by environment"
    return 0
  }
