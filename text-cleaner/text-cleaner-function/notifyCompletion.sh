function notifyCompletion() {
    local status=$1
    if command -v notify-send &> /dev/null; then
        if [[ "$status" == "0" ]]; then
            notify-send -u critical "Text Cleaner" "Text cleaned successfully and copied to clipboard!" || echo '[DEBUG] notify-send failed in tmux' >&2
        else
            notify-send -u critical "Text Cleaner" "Error: Text cleaning process failed!" || echo '[DEBUG] notify-send failed in tmux' >&2
        fi
    else
        if [[ "$status" == "0" ]]; then
            echo "Text cleaned successfully and copied to clipboard!"
        else
            echo "Error: Text cleaning process failed!"
        fi
    fi
}
