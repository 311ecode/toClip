#!/usr/bin/env bash
toClip_clear_clipboard() {
    echo -n "" | xclip -selection clipboard
  }