#!/bin/bash

alias tclp='toClip'
alias tclTree='toClip "$(tree "$@")"'

# Function to copy gitMessages output to clipboard
tclGmsgs() {
    cls; gitMessages "$@" | xclip -selection clipboard
}

