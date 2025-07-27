#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

toClip() {
  local output
  local message
  local append=false
  local prepend=false
  local commands=()
  local source=""
  local auto_source=false

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
                Execute the shell command and copy its output (stdout and stderr). Can be used multiple times.
  -s, --source "SOURCE"
                When using piped input or text (not with -c), prepend "Executed: SOURCE\n" to the content.
  -S, --auto-source
                Automatically detect the source command for piped input (not with -c or -s) and prepend "Executed: <detected>\n".

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

  # Copy piped with source
  ls | toClip -s "ls" "Directory listing copied!"

  # Copy piped with auto source
  ls | toClip -S "Directory listing copied!"

  # Copy without arguments (waits for stdin input, press Ctrl+D to finish)
  toClip

Note: If no clipboard utility is found, outputs to stdout as fallback.
When using -c, the copied content includes "Executed: <command>\n" before each command's output (stdout and stderr combined).
When using -s, prepends "Executed: <source>\n" to the text or piped input.
When using -S, detects previous commands in pipe and prepends "Executed: <cmd1> | <cmd2> | ...\n".
Cannot use -s with -c, or -S with -c or -s.
For piped input, both stdout and stderr are captured to clipboard while stderr still flows to terminal.
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
    -s | --source)
      if [[ -n $2 ]]; then
        source="$2"
        shift 2
      else
        echo "Error: Option '$1' requires an argument." >&2
        return 1
      fi
      ;;
    -S | --auto-source)
      auto_source=true
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

  if [ -n "$source" ] && [[ ${#commands[@]} -gt 0 ]]; then
    echo "Error: Cannot use --source with --command" >&2
    return 1
  fi

  if $auto_source && [[ ${#commands[@]} -gt 0 ]]; then
    echo "Error: Cannot use --auto-source with --command" >&2
    return 1
  fi

  if $auto_source && [ -n "$source" ]; then
    echo "Error: Cannot use --auto-source with --source" >&2
    return 1
  fi

  command_output=""
  if [[ ${#commands[@]} -gt 0 ]]; then
    for cmd in "${commands[@]}"; do
      echo "Command executed: $cmd" >&2
      local combined_output=$(eval "$cmd" 2>&1)
      if [[ -n "$combined_output" ]]; then
        echo "output:" >&2
        echo "$combined_output" >&2
      fi
      command_output+="Executed: $cmd\n$combined_output"
      command_output+=$'\n'
    done
    output="$command_output"
  fi

  # Handle piped input
  local piped_input=""
  if [ ! -t 0 ]; then # Check if stdin is not a terminal (i.e., there's piped input)
    piped_input=$(cat)
  fi

  # Combine output sources based on what we have
  if [[ ${#commands[@]} -gt 0 ]]; then
    # Command output takes precedence, already set above
    :
  elif [ -n "$piped_input" ] && [ -n "$output" ]; then
    # Both piped input and argument text - combine them
    # For append/prepend modes, the piped input should be the main content
    if $append || $prepend; then
      output="$piped_input$output"
    else
      output="$output$piped_input"
    fi
  elif [ -n "$piped_input" ]; then
    # Only piped input
    output="$piped_input"
  elif [ -z "$output" ] && [[ -t 0 ]]; then
    # No output from any source and stdin is terminal - keep output empty
    :
  fi

  # Add source prefix if provided and not using commands
  if [ -n "$source" ] && [[ ${#commands[@]} -eq 0 ]]; then
    output="Executed: $source\n$output"
  fi

  # Auto source for piped input
  if $auto_source && [[ ${#commands[@]} -eq 0 ]] && [ ! -t 0 ]; then
    previous_pids=$(ps -o pid --no-headers --ppid $PPID | awk -v me=$$ '$1 != me' | sort -n)
    previous_cmds=""
    for pid in $previous_pids; do
      cmd=$(ps -o command --no-headers -p $pid | sed 's/^\s*//; s/\s*$//')
      previous_cmds+="$cmd | "
    done
    previous_cmds=${previous_cmds% | }
    if [ -n "$previous_cmds" ]; then
      output="Executed: $previous_cmds\n$output"
    fi
  fi

  clipboard_content=""
  if $append || $prepend; then
    if command -v xclip >/dev/null 2>&1; then
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

  if command -v xclip >/dev/null 2>&1; then
    printf "%s" "$final_output" | xclip -selection clipboard
    [ -n "$message" ] && echo "$message" >&2
  else
    echo "No clipboard utility found (xclip)." >&2
    printf "%s" "$final_output"
  fi
}