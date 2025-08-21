#!/usr/bin/env bash
toClip_get_clipboard() {
    local temp=$(
      xclip -o -selection clipboard
      echo .
    )
    temp=${temp%.}
    printf "%s" "$temp"
  }
