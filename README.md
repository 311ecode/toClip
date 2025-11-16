# toClip - Advanced Clipboard Management Tool

## Overview

`toClip` is a comprehensive Bash script toolkit for enhanced clipboard operations. It supports copying text, executing commands, appending/prepending content, and intelligent auto-detection of shell commands. The tool is designed for command-line users and developers who need flexible clipboard management.

## Quick Start

### Basic Usage

Copy text to clipboard:
```bash
toClip "Hello World"
```

Get help:
```bash
toClip -h
# or
toClip --help
```

### No Required Parameters

**No parameters are required** for basic usage. The tool will:
- Display help with `-h` or `--help`
- Accept piped input when no arguments provided
- Copy provided text directly when arguments given

## Core Commands

### Copy Text
```bash
toClip "sample text"
```

### Append to Clipboard
```bash
toClip -a " additional text"
```

### Prepend to Clipboard  
```bash
toClip -p "Important: "
```

### Execute Commands
```bash
toClip -c "ls -la"
```

### Auto-Command Detection
Automatically detects and executes likely shell commands:
```bash
toClip "pwd"           # Auto-detects as command
toClip "just text"     # Treated as plain text
```

## Convenience Wrappers

### appendClip
Simple wrapper for appending text:
```bash
appendClip " more content"
```

### prependClip  
Simple wrapper for prepending text:
```bash
prependClip "Note: "
```

### Aliases
- `tclp` - Alias for `toClip`
- `tclTree` - Copy tree output to clipboard
- `tclGmsgs` - Copy git messages to clipboard

## Advanced Features

### Source Tracking
Include source information with copied content:

```bash
# Manual source
ls | toClip -s "ls command"

# Auto-detect source
ls | toClip -S
```

### Command Execution with Error Capture
Commands capture both stdout and stderr:
```bash
toClip -c "ls /nonexistent"  # Captures error message
```

### Pipeline Support
Works seamlessly in pipelines:
```bash
echo "hello" | toClip | tr 'a-z' 'A-Z'
find . -name "*.txt" | toClip -p "Text files:
"
```

## Options Reference

| Option | Description |
|--------|-------------|
| `-h, --help` | Show comprehensive help |
| `-a, --append` | Append text to current clipboard |
| `-p, --prepend` | Prepend text to current clipboard |
| `-c, --command` | Execute command and copy output |
| `-s, --source` | Include source label with input |
| `-S, --auto-source` | Auto-detect pipeline source |

## Auto-Command Detection

The tool intelligently detects shell commands using heuristics:
- Environment variable assignments (`VAR=value cmd`)
- Shell syntax markers (`|`, `&&`, `;`, `<`, `>`)
- Valid commands in PATH, aliases, functions
- Command-like syntax patterns

## Dependencies

- **xclip**: Required for clipboard operations
- Standard Unix utilities: `cat`, `echo`, `ps`, etc.

## Testing

Run comprehensive test suite:
```bash
test_toClip
```

Test categories include:
- Basic copy operations
- Append/prepend functionality  
- Command execution with stdout/stderr
- Auto-command detection
- Pipeline behavior
- Source tracking

## File Structure

```
toClip/
├── toClip.sh              # Main script
├── appendClip.sh          # Append wrapper
├── prependClip.sh         # Prepend wrapper
├── applications.sh        # Aliases and functions
├── tests/                 # Comprehensive test suite
│   ├── toClip_test/       # Main functionality tests
│   ├── toClip_auto_command_test/ # Auto-detection tests
│   ├── toClip_stderr_test/ # Error capture tests
│   └── test_all/          # Complete test runner
└── README.md              # This documentation
```

## Examples

### Basic Workflow
```bash
# Copy current directory listing
toClip -c "ls -la"

# Append timestamp
toClip -a " $(date)"

# Prepend header
toClip -p "Project Files:
"
```

### Advanced Usage
```bash
# Auto-detect command in pipeline
find . -name "*.sh" | toClip -S

# Multiple commands
toClip -c "date" -c "whoami" -c "pwd"

# Complex pipeline with source tracking
git status | grep modified | toClip -s "git modified" -p "Changes:
"
```

## Notes

- All commands support `-h` or `--help` for immediate assistance
- When `xclip` is unavailable, output goes to stdout as fallback
- The tool maintains clipboard content between operations
- Error messages are captured and included in clipboard content
- Works in interactive and scripted environments

For detailed help on any command, use the `-h` flag:
```bash
toClip -h
appendClip -h
prependClip -h
```
