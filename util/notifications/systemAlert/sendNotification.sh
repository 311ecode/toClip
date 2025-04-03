
sendNotification() {
    local message=$1
    local title=${2:-"Notification"}
    local urgency="normal"
    
    # Parse flags if any
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -u|--urgency)
                urgency="$2"
                shift 2
                ;;
            -t|--title)
                title="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    if command -v notify-send &> /dev/null; then
        notify-send --expire-time=5000 --urgency="$urgency" "$title" "$message" || 
            echo "[DEBUG] notify-send failed in tmux" >&2
    else
        echo "[$urgency] $title: $message"
    fi
}
