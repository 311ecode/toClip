#!/bin/bash

# @file cwhSelector.sh
# @brief Function to select and set clipboard workhorses
# @description This script provides a function to select different clipboard workhorses
#              and set the CLIPBOARD_DISPATCHER_COMMAND environment variable accordingly

cwhSelector() {
  local selected_workhorse=""
  local tmux_session="text-cleaner"
  local available_workhorses=()
  
  # Log function call
  echo "[INFO $(date '+%H:%M:%S')] Clipboard Workhorse Selector called" >&2
  
  # Find all available clipboard workhorses (functions that start with cwh-)
  while IFS= read -r func; do
    if [[ "$func" =~ ^cwh- ]]; then
      available_workhorses+=("$func")
    fi
  done < <(declare -F | awk '{print $3}')
  
  # If no workhorses are available, display an error
  if [[ ${#available_workhorses[@]} -eq 0 ]]; then
    echo "[ERROR] No clipboard workhorses (cwh-*) found" >&2
    return 1
  fi
  
  # If a specific workhorse is provided as an argument
  if [[ -n "$1" ]]; then
    selected_workhorse="$1"
    
    # Verify that the provided workhorse exists
    if ! declare -F "$selected_workhorse" > /dev/null; then
      if ! declare -F "cwh-$selected_workhorse" > /dev/null; then
        echo "[ERROR] Workhorse '$selected_workhorse' not found" >&2
        echo "Available workhorses:" >&2
        for wh in "${available_workhorses[@]}"; do
          echo "  - $wh" >&2
        done
        return 1
      else
        selected_workhorse="cwh-$selected_workhorse"
      fi
    fi
  else
    # If no argument is provided, display available workhorses and prompt for selection
    echo "Available clipboard workhorses:" >&2
    for i in "${!available_workhorses[@]}"; do
      echo "  $((i+1)). ${available_workhorses[$i]}" >&2
    done
    
    echo -n "Select a workhorse (1-${#available_workhorses[@]}): " >&2
    read -r selection
    
    # Validate selection
    if [[ ! "$selection" =~ ^[0-9]+$ ]] || [[ "$selection" -lt 1 ]] || [[ "$selection" -gt "${#available_workhorses[@]}" ]]; then
      echo "[ERROR] Invalid selection" >&2
      return 1
    fi
    
    selected_workhorse="${available_workhorses[$((selection-1))]}"
  fi
  
  # Set the environment variable in the current shell
  export CLIPBOARD_DISPATCHER_COMMAND="$selected_workhorse"
  
  # Also set it in the tmux session if it exists
  if tmux has-session -t "$tmux_session" 2>/dev/null; then
    tmux send-keys -t "$tmux_session" " export CLIPBOARD_DISPATCHER_COMMAND=\"$selected_workhorse\"" C-m
    tmux send-keys -t "$tmux_session" " echo \"[INFO] Clipboard workhorse set to: $selected_workhorse\"" C-m
  fi
  
  echo "[INFO] Clipboard workhorse set to: $selected_workhorse" >&2
  
  return 0
}

# Add completion for cwhSelector
_cwhSelector_complete() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # Get all cwh- functions
  local workhorses=()
  while IFS= read -r func; do
    if [[ "$func" =~ ^cwh- ]]; then
      workhorses+=("$func")
      # Also add the version without the cwh- prefix
      workhorses+=("${func#cwh-}")
    fi
  done < <(declare -F | awk '{print $3}')
  
  COMPREPLY=( $(compgen -W "${workhorses[*]}" -- "$cur") )
  return 0
}

complete -F _cwhSelector_complete cwhSelector
