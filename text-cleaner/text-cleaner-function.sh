#!/bin/bash
# Text cleaner function with tmux session management and completion notification
# Debug mode enabled

# Set DISPLAY explicitly to match your environment
export DISPLAY=:1

# Function to log debug messages
debug_log() {
  echo "[DEBUG $(date '+%H:%M:%S')] $1" >&2
}

textCleaner() {
  local TMUX_SESSION_NAME="text-cleaner"
  local SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  
  local CMD="clean"
  local PROMPT_FILE=""
  local CUSTOM_TEXT=""
  local NO_HISTORY=false
  
  debug_log "Starting textCleaner function"
  debug_log "DISPLAY=$DISPLAY"
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      clean|--clean|-c)
        CMD="clean"
        shift
        ;;
      view|--view|-v)
        CMD="view"
        shift
        ;;
      stop|--stop|-s)
        CMD="stop"
        shift
        ;;
      start|--start)
        CMD="start"
        shift
        ;;
      prompt|--prompt-file|-p)
        PROMPT_FILE="$2"
        shift 2
        ;;
      text|--text|-t)
        CUSTOM_TEXT="$2"
        shift 2
        ;;
      no-history|--no-history|-n)
        NO_HISTORY=true
        shift
        ;;
      help|--help|-h)
        echo "Usage: textCleaner [COMMAND] [OPTIONS]"
        echo ""
        echo "Commands:"
        echo "  clean (default)  Clean text from clipboard"
        echo "  view             Attach to tmux session for debugging"
        echo "  stop             Stop the tmux session"
        echo "  start            Start the tmux session without cleaning text"
        echo ""
        echo "Options:"
        echo "  --prompt-file, -p FILE   Use custom prompt file"
        echo "  --text, -t TEXT          Clean specific text instead of clipboard"
        echo "  --no-history, -n         Prevent commands from being saved in bash history"
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
  
  if [[ "$CMD" == "stop" ]]; then
    if tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null; then
      tmux kill-session -t "$TMUX_SESSION_NAME"
      echo "Text cleaner session stopped."
    else
      echo "No active text cleaner session."
    fi
    return 0
  fi
  
  textCleaner_start_session() {
    if ! tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null; then
      debug_log "Creating new tmux session: $TMUX_SESSION_NAME"
      tmux new-session -d -s "$TMUX_SESSION_NAME"
      tmux send-keys -t "$TMUX_SESSION_NAME" "export DISPLAY=:1" C-m
      
      # Set history control if requested
      if [[ "$NO_HISTORY" == true ]]; then
        tmux send-keys -t "$TMUX_SESSION_NAME" "export HISTCONTROL=ignorespace ignoredups" C-m
        tmux send-keys -t "$TMUX_SESSION_NAME" "export HISTIGNORE='cleanClipboardText*:textCleaner*'" C-m
      fi
      
      tmux send-keys -t "$TMUX_SESSION_NAME" "cd $SCRIPT_DIR" C-m
      tmux send-keys -t "$TMUX_SESSION_NAME" "source ./cleanClipboardText.sh" C-m
      tmux send-keys -t "$TMUX_SESSION_NAME" "echo 'Text cleaner session initialized and ready'" C-m
      sleep 1
      debug_log "Text cleaner session started and ready"
      return 0
    else
      debug_log "Session exists, updating environment"
      tmux send-keys -t "$TMUX_SESSION_NAME" "export DISPLAY=:1" C-m
      
      # Set history control if requested
      if [[ "$NO_HISTORY" == true ]]; then
        tmux send-keys -t "$TMUX_SESSION_NAME" "export HISTCONTROL=ignorespace ignoredups" C-m
        tmux send-keys -t "$TMUX_SESSION_NAME" "export HISTIGNORE='cleanClipboardText*:textCleaner*'" C-m
      fi
      
      tmux send-keys -t "$TMUX_SESSION_NAME" "cd $SCRIPT_DIR" C-m
      debug_log "Text cleaner session already running"
      return 0
    fi
  }

  if [[ "$CMD" == "start" ]]; then
    textCleaner_start_session
    return 0
  fi
  
  textCleaner_start_session > /dev/null
  
  if [[ "$CMD" == "view" ]]; then
    tmux attach-session -t "$TMUX_SESSION_NAME"
    return 0
  fi
  
  if [[ "$CMD" == "clean" ]]; then
    local CLEAN_CMD=""
    
    # Prefix with space if no-history is enabled (HISTCONTROL=ignorespace)
    if [[ "$NO_HISTORY" == true ]]; then
      CLEAN_CMD=" cleanClipboardText"
    else
      CLEAN_CMD="cleanClipboardText"
    fi
    
    if [[ -n "$PROMPT_FILE" ]]; then
      CLEAN_CMD="${CLEAN_CMD} --prompt-file \"${PROMPT_FILE}\""
    fi
    if [[ -n "$CUSTOM_TEXT" ]]; then
      local ESCAPED_TEXT=$(echo "$CUSTOM_TEXT" | sed 's/"/\"/g')
      tmux send-keys -t "$TMUX_SESSION_NAME" "echo \"${ESCAPED_TEXT}\" | xclip -selection clipboard" C-m
      sleep 0.5
      debug_log "Set custom text to clipboard: $CUSTOM_TEXT"
    fi
    
    debug_log "Checking notify-send availability"
    if command -v notify-send &> /dev/null; then
      debug_log "Sending initial notification"
       || debug_log "Initial notify-send failed"
    else
      debug_log "notify-send not found, using echo"
      echo "Cleaning text in progress..."
    fi
    
    tmux send-keys -t "$TMUX_SESSION_NAME" "
    function notifyCompletion() {
      local status=\$1
      if command -v notify-send &> /dev/null; then
        if [[ \"\$status\" == \"0\" ]]; then
          notify-send -u critical \"Text Cleaner\" \"Text cleaned successfully and copied to clipboard!\" || echo '[DEBUG] notify-send failed in tmux' >&2
        else
          notify-send -u critical \"Text Cleaner\" \"Error: Text cleaning process failed!\" || echo '[DEBUG] notify-send failed in tmux' >&2
        fi
      else
        if [[ \"\$status\" == \"0\" ]]; then
          echo \"Text cleaned successfully and copied to clipboard!\"
        else
          echo \"Error: Text cleaning process failed!\"
        fi
      fi
    }
    " C-m
    
    tmux send-keys -t "$TMUX_SESSION_NAME" "
    $CLEAN_CMD
    CLEAN_STATUS=\$?
    echo '[DEBUG] Clean command status: \$CLEAN_STATUS' >&2
    notifyCompletion \$CLEAN_STATUS
    if [[ \$CLEAN_STATUS -eq 0 ]]; then
      echo \"✅ Text cleaning completed at \$(date)\"
    else
      echo \"❌ Text cleaning failed at \$(date)\"
    fi
    " C-m
    
    debug_log "Text cleaning command sent to tmux session"
    return 0
  fi
  
  echo "Unknown command or error. Use --help for usage information."
  return 1
}

alias tc="textCleaner"
alias text-clean="textCleaner"
alias hunspell="textCleaner"

# Start with no-history option by default
(textCleaner --start --no-history > /dev/null 2>&1 &)
