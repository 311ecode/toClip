# appendClip.sh README

## Overview

`appendClip.sh` is a Bash script designed to append text to the current clipboard content. It serves as a simple wrapper around the main `toClip.sh` script, utilizing its append functionality. This script is part of a collection of clipboard utilities aimed at enhancing clipboard operations for command-line users and developers.

## Usage

### Basic Append

Append text to the current clipboard content:

```bash
appendClip " additional text"
```

### Parameters

- `TEXT`: The text to append to the clipboard content.

### Options

- `-h, --help`: Show help message.

### Examples

```bash
# Append text to the clipboard
appendClip " additional text"

# Append with a message
appendClip " appended note" "Appended note"
```

For detailed help, run the command with the `-h` option:

```bash
appendClip -h
```

## Dependencies

- `toClip.sh`: The main clipboard utility script.
- `xclip`: Required for clipboard operations.
- Standard Unix utilities (e.g., `cat`, `echo`).

## Advanced Usage

### Combining with Other Utilities

You can combine `appendClip.sh` with other clipboard utilities for more complex operations. For example, prepending text before appending:

```bash
prependClip "Important: "
appendClip " additional information"
```

### Using with Piped Input

You can use `appendClip.sh` with piped input to append text dynamically:

```bash
echo "Hello" | appendClip " additional text"
```

## Notes

- All commands support `-h` or `--help` for usage information.
- When no clipboard utility is found, outputs to stdout as fallback.
- For detailed help, run any command with the `-h` option.

## See Also

- `toClip.sh`: The main clipboard utility script.
- `prependClip.sh`: A wrapper for prepending text to the clipboard.
- `applications.sh`: Convenience aliases and functions for clipboard operations.
