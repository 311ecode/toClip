#!/bin/bash
setupKeyboardShortcut() {
    local name="$1"          # Shortcut name
    local command="$2"       # Command to execute
    local key_combo="${3:-<Control><Alt>z}"  # Default key combo if not specified
    local overwrite=false    # Overwrite flag
    
    # Parse options
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --overwrite) overwrite=true; shift ;;
            *) shift ;;
        esac
    done
    
    if ! command -v gsettings &> /dev/null; then
        echo "Error: gsettings not found. Cannot create keyboard shortcut." >&2
        return 1
    fi
    
    echo "Setting up keyboard shortcut '$name' ($key_combo)..."
    
    # Prepare the shortcut path using sanitized name
    local sanitized_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]-')
    local shortcut_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$sanitized_name/"
    
    # Get current custom shortcuts
    local current_shortcuts=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
    
    # Check if shortcut already exists
    if [[ "$current_shortcuts" =~ $shortcut_path ]] && [ "$overwrite" = false ]; then
        echo "Warning: Shortcut '$name' already exists. Use --overwrite to replace it." >&2
        return 2
    fi
    
    # Prepare new shortcuts list
    local new_shortcuts
    if [[ "$current_shortcuts" == "@as []" ]]; then
        new_shortcuts="['$shortcut_path']"
    elif [[ "$current_shortcuts" =~ $shortcut_path ]]; then
        new_shortcuts="$current_shortcuts"
    else
        new_shortcuts="${current_shortcuts%]}, '$shortcut_path']"
    fi
    
    # Update the list of custom keybindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$new_shortcuts"
    
    # Set up the custom keybinding
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$shortcut_path name "$name"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$shortcut_path command "$command"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$shortcut_path binding "$key_combo"
    
    echo "Shortcut '$name' setup complete. Use $key_combo to execute."
    return 0
}

