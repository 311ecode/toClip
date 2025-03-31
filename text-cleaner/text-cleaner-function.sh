#!/bin/bash
# Text cleaner function with tmux session management and completion notification

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
  textCleaner_start_session() {
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
    textCleaner_start_session
    return 0
  fi
  
  # Ensure tmux session exists for other commands
  textCleaner_start_session > /dev/null
  
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
      local ESCAPED_TEXT=$(echo "$CUSTOM_TEXT" | sed 's/"/\"/g')
      tmux send-keys -t "$TMUX_SESSION_NAME" "echo \"${ESCAPED_TEXT}\" | xclip -selection clipboard" C-m
      sleep 0.5 # Give a moment for clipboard to update
    fi
    
    # Send a notification at the beginning of the process
    if command -v notify-send &> /dev/null; then
      notify-send -u normal -t 5000 "Text Cleaner" "Cleaning text in progress..."
    elif command -v zenity &> /dev/null; then
      zenity --notification --text="Text Cleaner: Cleaning in progress..." &
    elif command -v osascript &> /dev/null; then
      osascript -e 'display notification "Cleaning in progress..." with title "Text Cleaner"'
    else
      echo "Cleaning text in progress..."
    fi
    
    # Create notification functions in the tmux session
    tmux send-keys -t "$TMUX_SESSION_NAME" "
    # Function to send completion notification that ensures visibility
    function notifyCompletion() {
      local status=\$1
      
      # Try multiple notification methods to ensure something shows up
      if command -v notify-send &> /dev/null; then
        # Linux notification (ensure it stays visible longer with -t 10000 = 10 seconds)
        if [[ \"\$status\" == \"0\" ]]; then
          notify-send -u critical -t 10000 \"Text Cleaner\" \"✅ Text cleaned successfully and copied to clipboard!\"
        else
          notify-send -u critical -t 10000 \"Text Cleaner\" \"❌ Error: Text cleaning process failed!\"
        fi
      elif command -v zenity &> /dev/null; then
        # Alternative Linux notification using zenity
        if [[ \"\$status\" == \"0\" ]]; then
          zenity --info --title=\"Text Cleaner\" --text=\"✅ Text cleaned successfully and copied to clipboard!\" &
        else
          zenity --error --title=\"Text Cleaner\" --text=\"❌ Error: Text cleaning process failed!\" &
        fi
      elif command -v osascript &> /dev/null; then
        # macOS notification
        if [[ \"\$status\" == \"0\" ]]; then
          osascript -e 'display dialog \"✅ Text cleaned successfully and copied to clipboard!\" with title \"Text Cleaner\" buttons {\"OK\"} default button \"OK\"'
        else
          osascript -e 'display dialog \"❌ Error: Text cleaning process failed!\" with title \"Text Cleaner\" buttons {\"OK\"} default button \"OK\"'
        fi
      else
        # Fallback to terminal output
        if [[ \"\$status\" == \"0\" ]]; then
          echo \"✅ Text cleaned successfully and copied to clipboard!\"
        else
          echo \"❌ Error: Text cleaning process failed!\"
        fi
      fi
    }
    " C-m
    
    # Run the cleaning command in tmux and add notification for completion
    tmux send-keys -t "$TMUX_SESSION_NAME" "
    # Run the text cleaning command and capture its exit status
    $CLEAN_CMD
    CLEAN_STATUS=\$?
    
    # Send notification based on completion status
    notifyCompletion \$CLEAN_STATUS
    
    # Display extra information in the tmux session
    if [[ \$CLEAN_STATUS -eq 0 ]]; then
      echo \"✅ Text cleaning completed at \$(date)\"
      
      # Additional guaranteed popup methods for Linux/macOS/Windows
      if command -v xmessage &> /dev/null; then
        # Very basic X11 popup that will definitely show
        xmessage -center \"Text Cleaner: Process Complete\" &
      elif command -v zenity &> /dev/null; then
        # Force a dialog box instead of just a notification
        zenity --info --title=\"Text Cleaner\" --text=\"Process Complete\" --timeout=5 &
      elif command -v kdialog &> /dev/null; then
        # KDE dialog
        kdialog --title \"Text Cleaner\" --passivepopup \"Process Complete\" 5 &
      fi
    else
      echo \"❌ Text cleaning failed at \$(date)\"
    fi
    " C-m
    
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
