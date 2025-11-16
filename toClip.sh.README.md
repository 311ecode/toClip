# toClip.sh README

## Overview

`toClip.sh` is a Bash script designed to enhance clipboard operations. It supports appending, prepending, and executing shell commands, capturing their output (both stdout and stderr) to the clipboard. This script aims to provide a flexible and powerful way to manage clipboard content, especially useful for command-line users and developers.

## Usage

### Basic Copy

Copy plain text to the clipboard:

```bash
toClip "sample text" "Copied!"
```

### Append to Clipboard

Append text to the current clipboard content:

```bash
toClip -a " additional text" "Appended!"
```

### Prepend to Clipboard

Prepend text to the current clipboard content:

```bash
toClip -p "Important: " "Prepended!"
```

### Execute Command and Copy Output

Execute a command and copy its output to the clipboard:

```bash
toClip -c "ls -la" "Directory listing copied"
```

### Pipe Input

Pipe input to the clipboard, optionally prepending a source label:

```bash
echo "Hello" | toClip -p "Greeting: " "Prepended greeting"
```

### Auto-Detect Commands

Auto-detect and execute commands from plain text input:

```bash
toClip "ls -la"  # Auto-detects as a command and executes it
```

### Source Option

Include a source label with piped input or text:

```bash
ls | toClip -s "ls" "Directory listing copied"
```

### Auto-Source Option

Automatically detect and prepend the source command for piped input:

```bash
ls | toClip -S "Directory listing copied"
```

## Options

- `-h, --help`: Show help message.
- `-a, --append`: Append text to the current clipboard content.
- `-p, --prepend`: Prepend text to the current clipboard content.
- `-c, --command`: Execute a shell command and copy its output to the clipboard.
- `-s, --source`: Include a source label with piped input or text.
- `-S, --auto-source`: Automatically detect and prepend the source command for piped input.

## Dependencies

- `xclip`: Required for clipboard operations.
- Standard Unix utilities (e.g., `cat`, `echo`, `ps`).


## Advanced Usage

### Combining Commands

Execute multiple commands and capture their output:

```bash
toClip -c "date" -c "pwd" "System info copied"
```

Chain commands with pipes and auto-source:

```bash
ls | grep ".txt" | toClip -S -p "Text files: " "Text files list copied"
```

### Error Handling

Commands that produce errors will display the error message and still capture the output. If no clipboard utility is available, the output will be sent to stdout.

### Input Methods

Supports various input methods:

- Direct arguments.
- Piped input.
- Command output.
- Interactive input (when no arguments are provided).

## Tests

To run the tests, ensure `xclip` is installed, source the necessary scripts, and run:

```bash
test_toClip
```

The test suite verifies basic functionality, append/prepend operations, command execution including stderr, source option, and auto-source detection.
