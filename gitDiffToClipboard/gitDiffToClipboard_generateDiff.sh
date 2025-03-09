
gitDiffToClipboard_generateDiff() {
  local cached=false
  local unified=false
  local unified_lines=5
  local paths=()

  # Process arguments to handle flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -c|--cached)
        cached=true
        shift
        ;;
      -u|--unf)
        unified=true
        shift
        # Check if next argument is a number (context lines)
        if [[ $1 =~ ^[0-9]+$ ]]; then
          unified_lines=$1
          shift
        fi
        ;;
      *)
        paths+=("$1")
        shift
        ;;
    esac
  done

  # If no paths specified, use current directory
  if [[ ${#paths[@]} -eq 0 ]]; then
    paths=(".")
  fi

  # Run git diff with appropriate flags
  local diff_cmd="git diff"

  # Add unified flag if specified
  if [[ "$unified" == true ]]; then
    diff_cmd="$diff_cmd -U$unified_lines"
  fi

  # Add cached flag if specified
  if [[ "$cached" == true ]]; then
    diff_cmd="$diff_cmd --cached"
  fi

  # Run the command with paths
  local diff_output
  diff_output=$(eval "$diff_cmd ${paths[*]}" 2>/dev/null)

  echo "$diff_output"
}

