toClip() {
  local output
  local message
  local append=false
  local prepend=false

  # Help message
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    cat <<EOF
Usage: toClip [OPTIONS] [TEXT] [MESSAGE]

Copies text to the system clipboard, optionally appending or prepending.

Options:
  -h, --help    Show this help message and exit
  -a, --append  Append TEXT to the current clipboard content.
  -p, --prepend Prepend TEXT to the current clipboard content.

Examples:
  # Copy argument text
  toClip "text to copy" "Copied!"

  # Append text
  toClip -a " text to add" "Appended!"

  # Prepend text
  toClip -p "Important: " "Prepended!"

  # Copy from a file
  toClip < input.txt

  # Copy command output
  ls -la | toClip

  # Copy with piped input and show message
  echo "World" | toClip -p "Hello, " "Prepended greeting!"

  # Copy without arguments (waits for stdin input, press Ctrl+D to finish)
  toClip

Note: If no clipboard utility is found, outputs to stdout as fallback.
EOF
    return 0
  fi

  # Process options
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -a|--append)
        append=true
        shift
        ;;
      -p|--prepend)
        prepend=true
        shift
        ;;
      --) # End of options
        shift
        break
        ;;
      -*)
        echo "Error: Invalid option '$1'" >&2
        return 1
        ;;
      *)
        output="$1"
        shift
        message="${1:-}"
        shift
        break # Assume the rest are text and message
        ;;
    esac
  done

  # Read from stdin if no output from arguments
  if [ -z "$output" ]; then
    output=$(cat)
  fi

  clipboard_content=""
  if $append || $prepend; then
    if command -v pbpaste >/dev/null 2>&1; then
      clipboard_content=$(pbpaste)
    elif command -v xclip >/dev/null 2>&1; then
      clipboard_content=$(xclip -selection clipboard -o)
    fi
  fi

  final_output=""
  if $append; then
    final_output="$clipboard_content$output"
  elif $prepend; then
    final_output="$output$clipboard_content"
  else
    final_output="$output"
  fi

  if command -v pbcopy >/dev/null 2>&1; then
    echo "$final_output" | pbcopy
    [ -n "$message" ] && echo "$message" >&2
  elif command -v xclip >/dev/null 2>&1; then
    echo "$final_output" | xclip -selection clipboard
    [ -n "$message" ] && echo "$message" >&2
  else
    echo "No clipboard utility found (pbcopy/xclip)." >&2
    echo "$final_output"
  fi
}
