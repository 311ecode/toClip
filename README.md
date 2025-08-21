# Clipboard Utilities

A collection of Bash scripts for enhanced clipboard operations with support for appending, prepending, and command execution.

## Scripts Overview

1. **toClip.sh** - Main clipboard utility with advanced features
2. **appendClip.sh** - Wrapper for appending to clipboard
3. **prependClip.sh** - Wrapper for prepending to clipboard
4. **applications.sh** - Convenience aliases and functions
5. **tests/toClip_test.sh** - Test functions for toClip functionality

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
- `-s, --source` - For piped input or text, prepend "Executed: SOURCE\n" to the content
- `-S, --auto-source` - Automatically detect and prepend the source command for piped input

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

# Pipe with source
ls | toClip -s "ls" "Directory listing copied"

# Pipe with auto source
ls | toClip -S "Directory listing copied"
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
- For detailed help, run any command with -h option
- When executing commands with -c, the clipboard content includes "Executed: <command>\n" followed by both stdout and stderr.
- When using -s with piped input or text, includes "Executed: <source>\n" before the content.
- When using -S with piped input, automatically detects the previous command(s) in the pipe and prepends "Executed: <cmd1> | <cmd2> | ...\n".

## Advanced Usage

### Combining Commands

```bash
# Multiple commands concatenated
toClip -c "date" -c "pwd" "System info copied"

# Chaining with pipes with auto source
ls | grep ".txt" | toClip -S -p "Text files: " "Text files list copied"
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

## Tests

To run the tests, ensure `xclip` is installed, source the necessary scripts (including toClip.sh and tests/toClip_test.sh), and run:

```bash
test_toClip
```

The test function verifies basic functionality, append/prepend, command execution including stderr, source option, and auto source.
