#!/usr/bin/env bash
toClip_testPassthrough() {
    echo "🔄 Testing passthrough functionality"

    # Test 1: Basic passthrough with command (suppress debug output)
    local result=$(toClip -c 'echo "stdout"; echo "stderr" >&2' 2>/dev/null)
    # Use printf to interpret the escape sequences for comparison
    local expected=$(printf 'Executed: echo "stdout"; echo "stderr" >&2\nstdout\nstderr')
    
    if [ "$result" = "$expected" ]; then
        echo "✅ SUCCESS: Command passthrough works correctly"
    else
        echo "❌ ERROR: Command passthrough failed"
        echo "Expected: '$expected'"
        echo "Got: '$result'"
        return 1
    fi

    # Test 2: Passthrough with piped input
    local result=$(echo "piped content" | toClip)
    local expected="piped content"
    
    if [ "$result" = "$expected" ]; then
        echo "✅ SUCCESS: Pipe passthrough works correctly"
    else
        echo "❌ ERROR: Pipe passthrough failed"
        echo "Expected: '$expected'"
        echo "Got: '$result'"
        return 1
    fi

    # Test 3: Passthrough in pipeline chain
    local result=$(echo "hello" | toClip | tr 'a-z' 'A-Z')
    local expected="HELLO"
    
    if [ "$result" = "$expected" ]; then
        echo "✅ SUCCESS: Pipeline passthrough works correctly"
    else
        echo "❌ ERROR: Pipeline passthrough failed"
        echo "Expected: '$expected'"
        echo "Got: '$result'"
        return 1
    fi

    # Test 4: Verify clipboard still works alongside passthrough
    toClip_clear_clipboard
    local result=$(toClip -c "echo 'test output'" 2>/dev/null)
    local clipboard="$(toClip_get_clipboard)"
    
    if [ "$result" = "$clipboard" ]; then
        echo "✅ SUCCESS: Passthrough and clipboard content match"
    else
        echo "❌ ERROR: Passthrough and clipboard content differ"
        echo "Passthrough: '$result'"
        echo "Clipboard: '$clipboard'"
        return 1
    fi

    return 0
}