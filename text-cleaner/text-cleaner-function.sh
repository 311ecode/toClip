#!/bin/bash
# Text cleaner function with tmux session management

# Function to manage the text cleaner tmux session and operations
textCleaner() {
  local TMUX_SESSION_NAME="text-cleaner"
  local SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  
  # Command options
  local CMD="clean"
  local PROMPT_FILE=""
  local CUSTOM_TEXT=""
  
  # Parse options
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
        echo "  --help, -h               Show this help message"
        return 0
        ;;
      *)
        # If no recognized command/option, assume it's text to clean
        if [[ -z "$CUSTOM_TEXT" ]]; then
          CUSTOM_TEXT="$1"
        fi
        shift
        ;;
    esac
  done
  
  # Check if tmux is installed
  if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed. Please install it first."
    echo "Run: sudo apt install tmux"
    return 1
  fi
  
  # Stop command - kill the session
  if [[ "$CMD" == "stop" ]]; then
    if tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null; then
      tmux kill-session -t "$TMUX_SESSION_NAME"
      echo "Text cleaner session stopped."
    else
      echo "No active text cleaner session."
    fi
    return 0
  fi
  
  # Function to start tmux session
  start_session() {
    if ! tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null; then
      echo "Creating new tmux session: $TMUX_SESSION_NAME"
      
      # Create a new detached session
      tmux new-session -d -s "$TMUX_SESSION_NAME"
      
      # Load necessary environment and source files
      tmux send-keys -t "$TMUX_SESSION_NAME" "cd $SCRIPT_DIR" C-m
      tmux send-keys -t "$TMUX_SESSION_NAME" "source ./cleanClipboardText.sh" C-m
      tmux send-keys -t "$TMUX_SESSION_NAME" "echo 'Text cleaner session initialized and ready'" C-m
      
      # Wait for initialization
      sleep 1
      echo "Text cleaner session started and ready."
      return 0
    else
      # Session exists, make sure we're in the right directory (in case it changed)
      tmux send-keys -t "$TMUX_SESSION_NAME" "cd $SCRIPT_DIR" C-m
      echo "Text cleaner session already running."
      return 0
    fi
  }

  # Start command - just start the session
  if [[ "$CMD" == "start" ]]; then
    start_session
    return 0
  fi
  
  # Ensure tmux session exists for other commands
  start_session > /dev/null
  
  # View command - attach to the session
  if [[ "$CMD" == "view" ]]; then
    tmux attach-session -t "$TMUX_SESSION_NAME"
    return 0
  fi
  
  # Clean command - process text
  if [[ "$CMD" == "clean" ]]; then
    # Prepare the cleaning command
    local CLEAN_CMD="cleanClipboardText"
    
    # Add prompt file if specified
    if [[ -n "$PROMPT_FILE" ]]; then
      CLEAN_CMD="${CLEAN_CMD} --prompt-file \"${PROMPT_FILE}\""
    fi
    
    # If custom text is provided, put it in clipboard first
    if [[ -n "$CUSTOM_TEXT" ]]; then
      # We need to escape quotes in the text
      local ESCAPED_TEXT=$(echo "$CUSTOM_TEXT" | sed 's/"/\\"/g')
      tmux send-keys -t "$TMUX_SESSION_NAME" "echo \"${ESCAPED_TEXT}\" | xclip -selection clipboard" C-m
      sleep 0.5 # Give a moment for clipboard to update
    fi
    
    # Create a notify command that will run after cleaning
    local NOTIFY_CMD='if command -v notify-send &> /dev/null; then notify-send "Text Cleaner" "Text cleaned and copied to clipboard!"; else echo "Text cleaned and copied to clipboard!"; fi'
    
    # Run the cleaning command in tmux and add notification
    tmux send-keys -t "$TMUX_SESSION_NAME" "$CLEAN_CMD && $NOTIFY_CMD" C-m
    
    # Show initial notification
    if command -v notify-send &> /dev/null; then
      notify-send "Text Cleaner" "Cleaning text in progress..."
    else
      echo "Cleaning text in progress..."
    fi
    
    echo "Text cleaning command sent to tmux session."
    return 0
  fi
  
  # If we got here, something went wrong
  echo "Unknown command or error. Use --help for usage information."
  return 1
}

# Create aliases for easier use
alias tc="textCleaner"
alias text-clean="textCleaner"
alias hunspell="textCleaner"

# Auto-create the session on sourcing this file
(textCleaner --start > /dev/null 2>&1 &)
