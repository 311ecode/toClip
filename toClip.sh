toClip() {
  local output
  local message
  local append=false
  local prepend=false
  local commands=()

  # Help message
  if [[ $1 == "-h" || $1 == "--help" ]]; then
    cat <<EOF
Usage: toClip [OPTIONS] [TEXT] [MESSAGE]

Copies text to the system clipboard, optionally appending, prepending, or executing commands.

Options:
  -h, --help    Show this help message and exit
  -a, --append  Append TEXT to the current clipboard content.
  -p, --prepend Prepend TEXT to the current clipboard content.
  -c, --command "SHELL COMMAND"
                Execute the shell command and copy its stdout. Can be used multiple times.

Examples:
  # Copy argument text
  toClip "text to copy" "Copied!"

  # Append text
  toClip -a " text to add" "Appended!"

  # Prepend text
  toClip -p "Important: " "Prepended!"

  # Execute a command and copy its output
  toClip -c "ls -la" "Output of ls copied!"

  # Execute multiple commands (output will be concatenated)
  toClip -c "pwd" -c "whoami" "Multiple command outputs copied!"

  # Copy from piped input and prepend
  echo "World" | toClip -p "Hello, " "Prepended greeting!"

  # Copy from a file
  toClip < input.txt

  # Copy command output and append
  ls -la | toClip -a " (from ls)" "ls output appended!"

  # Copy without arguments (waits for stdin input, press Ctrl+D to finish)
  toClip

Note: If no clipboard utility is found, outputs to stdout as fallback.
EOF
    return 0
  fi

  # Process options
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -a | --append)
      append=true
      shift
      ;;
    -p | --prepend)
      prepend=true
      shift
      ;;
    -c | --command)
      if [[ -n $2 ]]; then
        commands+=("$2")
        shift 2
      else
        echo "Error: Option '$1' requires an argument." >&2
        return 1
      fi
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

  command_output=""
  if [[ ${#commands[@]} -gt 0 ]]; then
    for cmd in "${commands[@]}"; do
      echo "Command executed: $cmd" >&2
      local stdout=$(eval "$cmd")
      local stderr_output=$(eval "$cmd" 2>&1 >/dev/null) # Capture stderr
      if [[ -n $stdout ]]; then
        echo "stdout:" >&2
        echo "$stdout" >&2
        command_output+="$stdout"
      fi
      if [[ -n $stderr_output ]]; then
        echo "stderr:" >&2
        echo "$stderr_output" >&2
      fi
      command_output+=$'\n' # Add a newline between command outputs
    done
    output="$command_output"
  fi

  # Read from stdin if no explicit output was provided via arguments or commands
  if [ -z "$output" ] && [[ -t 0 ]]; then # Check if stdin is a terminal
    # Only read from stdin if it's not a pipe
    : # Do nothing, output remains empty, and we won't copy anything unless there was a command
  elif [ -z "$output" ]; then
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
