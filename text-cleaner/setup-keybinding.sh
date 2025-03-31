#!/bin/bash
# Simple function to setup keyboard shortcut

setupTextCleanerShortcut() {
  local key_combo="${1:-<Control><Alt>z}"
  local command="bash -c 'tmux has-session -t text-cleaner 2>/dev/null && tmux send-keys -t text-cleaner \"cleanClipboardText\" C-m || (cd ~/bash.sh/development/clipboard-related-tools/toClip/text-cleaner && bash -c \"source ./text-cleaner-function.sh && textCleaner --start && textCleaner\")'"
  
  if ! command -v gsettings &> /dev/null; then
    echo "Error: gsettings not found. Cannot create keyboard shortcut." >&2
    return 1
  fi
  
  echo "Setting up keyboard shortcut ($key_combo) for text cleaner..."
  
  # Get the current custom shortcuts
  local current_shortcuts=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
  
  # Prepare the new shortcut path
  local shortcut_path='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/text-cleaner/'
  
  # Add our shortcut to the list
  local new_shortcuts
  if [[ "$current_shortcuts" == "@as []" ]]; then
    # No existing shortcuts
    new_shortcuts="['$shortcut_path']"
  else
    # Add to existing shortcuts
    new_shortcuts="${current_shortcuts%]}, '$shortcut_path']"
  fi
  
  # Update the list of custom keybindings
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$new_shortcuts"
  
  # Create our custom keybinding
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$shortcut_path name "Text Cleaner"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$shortcut_path command "$command"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$shortcut_path binding "$key_combo"
  
  echo "Shortcut setup complete. Use $key_combo to clean text from clipboard."
  return 0
}

# You can call the function directly like this:
# setupTextCleanerShortcut "<Control><Alt>c"
