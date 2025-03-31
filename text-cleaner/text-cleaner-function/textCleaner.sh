#!/bin/bash
textCleaner() {
  echo "textCleaner Called from: ${BASH_SOURCE[1]} at line ${BASH_LINENO[0]}"
  textCleaner_start_session > /dev/null
  local TMUX_SESSION_NAME="text-cleaner"
  local SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  local PROMPT_FILE=""
  local CUSTOM_TEXT=""
  local NO_HISTORY=false
  
  textCleanerDebug_log "Starting textCleaner function"
  textCleanerDebug_log "DISPLAY=$DISPLAY"
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --cmd)
        CMD="$2"
        shift 2
        ;;
      --text|-t)
        CUSTOM_TEXT="$2"
        shift 2
        ;;
      help|--help|-h)
        echo "Usage: textCleaner [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --cmd COMMAND       Specify command (e.g., 'view', 'stop', 'start')"
        echo "  --text, -t TEXT          Clean specific text instead of clipboard"
        echo "  --help, -h               Show this help message"
        return 0
        ;;
      *)
        if [[ -z "$CUSTOM_TEXT" ]]; then
          CUSTOM_TEXT="$1"
        fi
        shift
        ;;
    esac
  done
  
  if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed. Please install it first."
    echo "Run: sudo apt install tmux"
    return 1
  fi
  
  # New function to handle tmux send-keys with leading space
  textCleaner_send_keys() {
    local session="$1"
    local command="$2"
    if [[ "$NO_HISTORY" == true ]]; then
      tmux send-keys -t "$session" " $command" C-m
    else
      tmux send-keys -t "$session" "$command" C-m
    fi
  }
  
  textCleaner_start_session() {
    if ! tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null; then
      textCleanerDebug_log "Creating new tmux session: $TMUX_SESSION_NAME"
      tmux new-session -d -s "$TMUX_SESSION_NAME"
      return 0
    else
      textCleanerDebug_log "Session exists, updating environment"
      textCleaner_send_keys "$TMUX_SESSION_NAME" "export DISPLAY=:1"
      textCleanerDebug_log "Text cleaner session already running"
      return 0
    fi
  }
  
  case "$CMD" in
    stop)
      if tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null; then
        tmux kill-session -t "$TMUX_SESSION_NAME"
        echo "Text cleaner session stopped."
      else
        echo "No active text cleaner session."
      fi
      return 0
      ;;
    view)
      tmux attach-session -t "$TMUX_SESSION_NAME"
      return 0
      ;;
    start)
      textCleaner_start_session
      echo "Text cleaner session started."
      return 0
      ;;
    *)
      echo "Unknown command: '$CMD'. Use --help for usage information."
      return 1
      ;;
  esac
}

(textCleaner --cmd "start" > /dev/null 2>&1 &)
