toClip() {
  local output
  local message
  
  # Help message
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    cat <<EOF
Usage: toClip [OPTIONS] [TEXT] [MESSAGE]

Copies text to the system clipboard. Can accept input via arguments or stdin.

Options:
  -h, --help    Show this help message and exit

Examples:
  # Copy argument text
  toClip "text to copy" "Copied successfully!"
  
  # Copy from a file
  toClip < input.txt
  
  # Copy command output
  ls -la | toClip
  
  # Copy with piped input and show message
  echo "Hello" | toClip "" "Greeting copied"
  
  # Copy without arguments (waits for stdin input, press Ctrl+D to finish)
  toClip

Note: If no clipboard utility is found, outputs to stdout as fallback.
EOF
    return 0
  fi

  # If arguments are provided, use them as output
  if [ $# -gt 0 ]; then
    output="$1"
    message="${2:-}"
  # Otherwise, read from stdin
  else
    output=$(cat)
    message=""
  fi

  if command -v pbcopy >/dev/null 2>&1; then
    echo "$output" | pbcopy
    [ -n "$message" ] && echo "$message" >&2
  elif command -v xclip >/dev/null 2>&1; then
    echo "$output" | xclip -selection clipboard
    [ -n "$message" ] && echo "$message" >&2
  else
    echo "No clipboard utility found (pbcopy/xclip)." >&2
    # Output to stdout as fallback
    echo "$output"
  fi
}