#!/bin/bash
# @file clipboardFunctionDispatcher.sh
# @brief Dispatch clipboard operations based on environment configuration
# @description This script acts as a dispatcher for clipboard operations,
#              checking for a defined command or defaulting to cleanClipboardText.

clipboardFunctionDispatcher() {
  # Log the dispatcher being called
  echo "[INFO $(date '+%H:%M:%S')] Clipboard Function Dispatcher called" >&2
  
  # Check if a custom command is defined
  if [[ -n "${CLIPBOARD_DISPATCHER_COMMAND}" ]]; then
    echo "[INFO] Using custom command: ${CLIPBOARD_DISPATCHER_COMMAND}" >&2
    # Execute the custom command
    eval "${CLIPBOARD_DISPATCHER_COMMAND}"
    return $?
  else
    # Default to cleanClipboardText if no custom command is defined
    echo "[INFO] No custom dispatcher command found, using default cleanClipboardText" >&2
    cwh-fixHungarianText #"$@"
    return $?
  fi
}
