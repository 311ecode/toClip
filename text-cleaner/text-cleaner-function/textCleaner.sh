#!/bin/bash

textCleaner() {
  echo "textCleaner Called from: ${BASH_SOURCE[1]} at line ${BASH_LINENO[0]}"
  textCleaner_start_session > /dev/null

  local TMUX_SESSION_NAME="text-cleaner"
  local SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  local CMD="clean"  # Default command
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
      --prompt-file|-p)
        PROMPT_FILE="$2"
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
        echo "  --cmd COMMAND       Specify command (e.g., 'clean', 'view', 'stop', 'start')"
        echo "  --prompt-file, -p FILE   Use custom prompt file"
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
    clean)
      local CLEAN_CMD="cleanClipboardText"
      
      if [[ -n "$PROMPT_FILE" ]]; then
        CLEAN_CMD="$CLEAN_CMD --prompt-file \"${PROMPT_FILE}\""
      fi
      if [[ -n "$CUSTOM_TEXT" ]]; then
        local ESCAPED_TEXT=$(echo "$CUSTOM_TEXT" | sed 's/"/\"/g')
        textCleaner_send_keys "$TMUX_SESSION_NAME" "echo \"${ESCAPED_TEXT}\" | xclip -selection clipboard"
        sleep 0.5
        textCleanerDebug_log "Set custom text to clipboard: $CUSTOM_TEXT"
      fi
      
      textCleanerDebug_log "Checking notify-send availability"
      if command -v notify-send &> /dev/null; then
        textCleanerDebug_log "Sending initial notification" || textCleanerDebug_log "Initial notify-send failed"
      else
        textCleanerDebug_log "notify-send not found, using echo"
        echo "Cleaning text in progress..."
      fi
      
      textCleaner_send_keys "$TMUX_SESSION_NAME" "
      $CLEAN_CMD
      CLEAN_STATUS=\$?
      echo '[DEBUG] Clean command status: \$CLEAN_STATUS' >&2
      notifyCompletion \$CLEAN_STATUS
      if [[ \$CLEAN_STATUS -eq 0 ]]; then
        echo \"✅ Text cleaning completed at \$(date)\"
      else
        echo \"❌ Text cleaning failed at \$(date)\"
      fi
      "
      
      textCleanerDebug_log "Text cleaning command sent to tmux session"
      return 0
      ;;
    *)
      echo "Unknown command: '$CMD'. Use --help for usage information."
      return 1
      ;;
  esac
}

(textCleaner --cmd "start" > /dev/null 2>&1 &)
