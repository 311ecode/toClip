
gitDiffToClipboard() {
  local to_clip=true
  local output_message=""

  # Check for --no-clip flag
  while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--no-clip" ]]; then
      to_clip=false
      shift
    else
      break
    fi
  done

  local diff_output=$(gitDiffToClipboard_generateDiff "$@")

  if [[ -n "$diff_output" ]]; then
    if [[ "$to_clip" == true ]]; then
      if [[ "$1" == "-c" || "$2" == "-c" || "$1" == "--cached" || "$2" == "--cached" ]]; then
        output_message="Staged changes copied to clipboard."
      else
        output_message="Unstaged changes copied to clipboard."
      fi
      toClip "$diff_output" "$output_message"
    else
        echo "$diff_output"
    fi
  else
    if [[ "$1" == "-c" || "$2" == "-c" || "$1" == "--cached" || "$2" == "--cached" ]]; then
      echo "No staged changes to copy." >&2
    else
      echo "No unstaged changes to copy." >&2
    fi
  fi
}

