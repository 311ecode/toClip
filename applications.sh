#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

alias tclp='toClip'
alias tclTree='toClip "$(tree "$@")"'

# Function to copy gitMessages output to clipboard
tclGmsgs() {
  cls
  gitMessages "$@" | xclip -selection clipboard
}