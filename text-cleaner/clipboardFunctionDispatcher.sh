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
    
    # Ensure the command starts with cwh-
    if [[ "${CLIPBOARD_DISPATCHER_COMMAND}" != cwh-* ]] && declare -F "cwh-${CLIPBOARD_DISPATCHER_COMMAND}" > /dev/null; then
      echo "[INFO] Converting to proper cwh- prefix format" >&2
      CLIPBOARD_DISPATCHER_COMMAND="cwh-${CLIPBOARD_DISPATCHER_COMMAND}"
    fi
    
    # Verify that the command exists
    if ! declare -F "${CLIPBOARD_DISPATCHER_COMMAND}" > /dev/null; then
      echo "[ERROR] Command '${CLIPBOARD_DISPATCHER_COMMAND}' not found, using default" >&2
      cwh-fixHungarianText
      return $?
    fi
    
    # Execute the custom command
    ${CLIPBOARD_DISPATCHER_COMMAND}
    return $?
  else
    # Default to cwh-fixHungarianText if no custom command is defined
    echo "[INFO] No custom dispatcher command found, using default cwh-fixHungarianText" >&2
    cwh-fixHungarianText
    return $?
  fi
}
