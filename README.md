# Clipboard Utilities

A collection of Bash scripts for enhanced clipboard operations with support for appending, prepending, and command execution.

## Scripts Overview

1. **toClip.sh** - Main clipboard utility with advanced features
2. **appendClip.sh** - Wrapper for appending to clipboard
3. **prependClip.sh** - Wrapper for prepending to clipboard
4. **applications.sh** - Convenience aliases and functions

## Main Features

### toClip.sh

The primary clipboard utility with multiple operation modes.

#### Usage:
```bash
toClip [OPTIONS] [TEXT] [MESSAGE]
```

#### Options:
- `-h, --help` - Show help message
- `-a, --append` - Append text to current clipboard content
- `-p, --prepend` - Prepend text to current clipboard content
- `-c, --command` - Execute shell command and copy its output (stdout and stderr)

#### Examples:
```bash
# Basic copy
toClip "sample text" "Copied!"

# Append to clipboard
toClip -a " additional text" "Appended!"

# Prepend to clipboard
toClip -p "Important: " "Prepended!"

# Execute command and copy output
toClip -c "ls -la" "Directory listing copied"

# Pipe input
echo "Hello" | toClip -p "Greeting: " "Prepended greeting"
```

### appendClip.sh

Simple wrapper for appending to clipboard.

#### Usage:
```bash
appendClip [TEXT] [MESSAGE]
```

No parameters required - uses same parameters as toClip's append mode.

### prependClip.sh

Simple wrapper for prepending to clipboard.

#### Usage:
```bash
prependClip [TEXT] [MESSAGE]
```

No parameters required - uses same parameters as toClip's prepend mode.

### applications.sh

Provides convenient aliases and functions:

#### Aliases:
- `tclp` - Shortcut for `toClip`
- `tclTree` - Copies directory tree structure to clipboard

#### Functions:
- `tclGmsgs` - Copies git commit messages to clipboard

## Installation

1. Place all `.sh` files in your preferred scripts directory
2. Ensure they are executable:
   ```bash
   chmod +x *.sh
   ```
3. Source them in your shell configuration:
   ```bash
   source /path/to/scripts/applications.sh
   ```

## Dependencies

- `xclip` (Linux)
- Standard Unix utilities (cat, echo, etc.)

## Notes

- All commands support `-h` or `--help` for usage information
- When no clipboard utility is found, outputs to stdout as fallback
- For detailed help, run any command with `-h` option
- When executing commands with -c, both stdout and stderr are included in the clipboard content

## Advanced Usage

### Combining Commands

```bash
# Multiple commands concatenated
toClip -c "date" -c "pwd" "System info copied"

# Chaining with pipes
ls | grep ".txt" | toClip -p "Text files: " "Text files list copied"
```

### Error Handling

- Command errors are displayed to stderr
- Clipboard operations fail gracefully if no clipboard utility is available

### Input Methods

Supports multiple input methods:
- Direct arguments
- Piped input
- Command output
- Interactive input (when no arguments provided)