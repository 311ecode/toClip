
notifyCompletion() {
    local status=$1
    if [[ "$status" == "0" ]]; then
        sendNotification "Text cleaned successfully and copied to clipboard!" -t "Text Cleaner"
    else
        sendNotification "Error: Text cleaning process failed!" -t "Text Cleaner" -u "critical"
    fi
}
