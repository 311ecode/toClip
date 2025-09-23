#!/usr/bin/env bash
# Copyright © 2025 Imre Toth
# <tothimre@gmail.com> - Proprietary Software.
# See LICENSE file for terms.

toClip() {
  local output
  local message
  local append=false
  local prepend=false
  local commands=()
  local source=""
  local auto_source=false
  local auto_command=false
  local debug_mode=false

  toClip_debug() {
    if $debug_mode; then
      echo "DEBUG toClip: $*" >&2
    fi
  }

  toClip_debug "Start args: $*"

  if [[ $1 == "-h" || $1 == "--help" ]]; then
    cat <<'EOF'
Usage:
  toClip [OPTIONS] [TEXT|COMMAND] [MESSAGE]

Copies text to the clipboard, optionally appending,
prepending, or executing commands. Also prints to stdout.

Auto-Command Detection (plain TEXT only):
  Detects likely shell commands and executes them.

Options:
  -h, --help        Show help and exit
  -a, --append      Append TEXT to clipboard
  -p, --prepend     Prepend TEXT to clipboard
  -c, --command "CMD"
                    Execute command(s) and copy output
                    (stdout+stderr). Can be repeated.
  -s, --source "SRC"
                    With piped input or TEXT (not -c), add
                    "Executed: SRC\n" before the content
  -S, --auto-source
                    Detect pipeline source (not with -c/-s)
                    and add "Executed: <detected>\n"
Notes:
  - If no clipboard utility is found, output goes to
    stdout.
  - Executed command copies include "Executed: <cmd>\n".
EOF
    return 0
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -a|--append)
        append=true; shift ;;
      -p|--prepend)
        prepend=true; shift ;;
      -c|--command)
        if [[ -n $2 ]]; then
          commands+=("$2"); shift 2
        else
          echo "Error: '$1' requires an argument." >&2
          return 1
        fi
        ;;
      -s|--source)
        if [[ -n $2 ]]; then
          source="$2"; shift 2
        else
          echo "Error: '$1' requires an argument." >&2
          return 1
        fi
        ;;
      -S|--auto-source)
        auto_source=true; shift ;;
      --)
        shift; break ;;
      -*)
        echo "Error: Invalid option '$1'" >&2
        return 1
        ;;
      *)
        output="$1"; shift
        if [[ $# -gt 0 ]]; then
          message="$1"; shift
        fi
        while [[ $# -gt 0 ]]; do
          output="$output $1"; shift
        done
        toClip_debug "Parsed output='$output' msg='$message'"
        break
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

  toClip_is_likely_command() {
    local text="$1"
    toClip_debug "Heuristic on: '$text'"

    if [[ ${#text} -lt 2 ]]; then
      return 1
    fi

    # Env assign followed by space: VAR=... <space>
    if [[ "$text" =~ ^[A-Z_][A-Z0-9_]*=\
[^[:space:]]*[[:space:]] ]]; then
      return 0
    fi

    # Obvious shell syntax markers
    if [[ "$text" =~ (\|\|)|(\&\&)|[\|\;\<\>] ]]; then
      return 0
    fi

    # If there is at least one space, allow a safer
    # whitelist on the first token to avoid false
    # positives like "some text".
    if [[ "$text" =~ [[:space:]] ]]; then
      local first="${text%% *}"
      case "$first" in
        ls|cat|grep|find|awk|sed|sort|uniq|head|tail|wc|cut|\
tr|date|ps|kill|chmod|chown|mkdir|rmdir|cp|mv|rm|ln|pwd|\
echo|printf|which|type|alias|history|jobs|fg|bg|timeout|\
xargs|parallel|npm|yarn|pip|brew|apt|yum|pacman|cargo|go|\
mvn|gradle|git|docker|kubectl|make|cmake|node|python|\
python3|ruby|java|javac|gcc|clang|rustc)
          return 0 ;;
      esac
      # Paths like ./tool or /usr/bin/tool with args
      if [[ "$first" == ./* || "$first" == /* ]]; then
        return 0
      fi
      # Command-with-flags shape: cmd -x ...
      if [[ "$text" =~ ^[a-zA-Z0-9_./-]+[[:space:]]+-[A-Za-z] ]]
      then
        return 0
      fi
    fi

    return 1
  }

  toClip_debug "Auto-detect precheck: cmds=${#commands[@]} "\
"append=$append prepend=$prepend out='${output}'"

  if [[ ${#commands[@]} -eq 0 ]] && ! $append && \
     ! $prepend && [ -n "$output" ]; then
    toClip_debug "Run auto-detection"
    if toClip_is_likely_command "$output"; then
      commands=("$output"); auto_command=true
      echo "Auto-detected as command: $output" >&2
    fi
  fi

  local command_output=""
  if [[ ${#commands[@]} -gt 0 ]]; then
    for cmd in "${commands[@]}"; do
      echo "Command executed: $cmd" >&2
      local combined
      combined=$(eval "$cmd" 2>&1)
      if [[ -n "$combined" ]]; then
        echo "output:" >&2
        echo "$combined" >&2
      fi
      command_output+="Executed: $cmd\n$combined"
      if [[ ${#commands[@]} -gt 1 ]]; then
        command_output+=$'\n'
      fi
    done
    output="$command_output"
  fi

  local piped_input=""
  if [ ! -t 0 ]; then
    piped_input=$(cat)
  fi

  if [[ ${#commands[@]} -gt 0 ]]; then
    :
  elif [ -n "$piped_input" ] && [ -n "$output" ]; then
    if $append || $prepend; then
      output="$piped_input$output"
    else
      output="$output$piped_input"
    fi
  elif [ -n "$piped_input" ]; then
    output="$piped_input"
  elif [ -z "$output" ] && [[ -t 0 ]]; then
    :
  fi

  if [ -n "$source" ] && [[ ${#commands[@]} -eq 0 ]]; then
    output="Executed: $source\n$output"
  fi

  if $auto_source && [[ ${#commands[@]} -eq 0 ]] && \
     [ ! -t 0 ]; then
    local previous_pids previous_cmds cmd
    previous_pids=$(ps -o pid --no-headers --ppid $PPID | \
      awk -v me=$$ '$1 != me' | sort -n)
    previous_cmds=""
    for pid in $previous_pids; do
      cmd=$(ps -o command --no-headers -p "$pid" | \
        sed 's/^\s*//; s/\s*$//')
      previous_cmds+="$cmd | "
    done
    previous_cmds=${previous_cmds% | }
    if [ -n "$previous_cmds" ]; then
      output="Executed: $previous_cmds\n$output"
    fi
  fi

  local clipboard_content=""
  if $append || $prepend; then
    if command -v xclip >/dev/null 2>&1; then
      clipboard_content=$(xclip -selection clipboard -o)
    fi
  fi

  local final_output=""
  if $append; then
    final_output="$clipboard_content$output"
  elif $prepend; then
    final_output="$output$clipboard_content"
  else
    final_output="$output"
  fi

  printf "%s" "$final_output"

  if command -v xclip >/dev/null 2>&1; then
    printf "%s" "$final_output" | xclip -selection clipboard
    [ -n "$message" ] && echo "$message" >&2
  else
    echo "No clipboard utility found (xclip). Output only." \
      >&2
  fi
}
# end of toClip