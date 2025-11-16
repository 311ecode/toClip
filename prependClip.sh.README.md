# prependClip.sh README

## Overview

`prependClip.sh` is a Bash script designed to prepend text to the current clipboard content. It serves as a simple wrapper around the main `toClip.sh` script, utilizing its prepend functionality. This script is part of a collection of clipboard utilities aimed at enhancing clipboard operations for command-line users and developers.

## Usage

### Basic Prepend

Prepend text to the current clipboard content:

```bash
prependClip "Important: "
```

### Parameters

- `TEXT`: The text to prepend to the clipboard content.

### Options

- `-h, --help`: Show help message.

### Examples

```bash
# Prepend text to the clipboard
prependClip "Important: "

# Prepend with a message
prependClip "Note: " "Prepended note"
```

For detailed help, run the command with the `-h` option:

```bash
prependClip -h
```

## Dependencies

- `toClip.sh`: The main clipboard utility script.
- `xclip`: Required for clipboard operations.
- Standard Unix utilities (e.g., `cat`, `echo`).

## Advanced Usage

### Combining with Other Utilities

You can combine `prependClip.sh` with other clipboard utilities for more complex operations. For example, appending text after prepending:

```bash
prependClip "Important: "
appendClip " additional information"
```

### Using with Piped Input

You can use `prependClip.sh` with piped input to prepend text dynamically:

```bash
echo "Hello" | prependClip "Greeting: "
```

## Notes

- All commands support `-h` or `--help` for usage information.
- When no clipboard utility is found, outputs to stdout as fallback.
- For detailed help, run any command with the `-h` option.

## See Also

- `toClip.sh`: The main clipboard utility script.
- `appendClip.sh`: A wrapper for appending text to the clipboard.
- `applications.sh`: Convenience aliases and functions for clipboard operations.
