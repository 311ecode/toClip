#!/usr/bin/env bash
toClip_debug_pipe_behavior() {
    echo "🔍 Debug: Testing pipe behavior"

    toClip_clear_clipboard

    # Test 1: Direct echo
    echo "test1" | toClip
    echo "Test 1 (direct echo): '$(toClip_get_clipboard)'"

    toClip_clear_clipboard

    # Test 2: Combined streams in variable first
    combined=$(sh -c 'echo "stdout"; echo "stderr" >&2' 2>&1)
    echo "$combined" | toClip
    echo "Test 2 (combined in variable): '$(toClip_get_clipboard)'"

    toClip_clear_clipboard

    # Test 3: Direct pipe with 2>&1
    sh -c 'echo "stdout"; echo "stderr" >&2' 2>&1 | toClip
    echo "Test 3 (direct pipe with 2>&1): '$(toClip_get_clipboard)'"

    toClip_clear_clipboard

    # Test 4: Test append with simple content
    toClip "initial"
    echo "appended" | toClip -a " + "
    echo "Test 4 (simple append): '$(toClip_get_clipboard)'"
}
