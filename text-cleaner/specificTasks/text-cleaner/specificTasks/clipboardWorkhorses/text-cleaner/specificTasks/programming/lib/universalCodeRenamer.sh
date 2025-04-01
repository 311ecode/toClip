#!/bin/bash
# @file universalCodeRenamer.sh
# @brief Function that uses AI to intelligently rename variables and functions in code
# @description This script provides a function for improving variable and function names
#              to make code more readable while preserving functionality and adding
#              explanatory comments if necessary

universalCodeRenamer() {
  local language="$1"
  local code="$2"
  
  # If no code is provided, get from clipboard
  if [[ -z "$code" ]]; then
    code=$(getFromClip)
    if [[ -z "$code" ]]; then
      echo "[ERROR] No code provided and clipboard is empty" >&2
      return 1
    fi
  fi
  
  # If no language is specified, try to detect it or use a default
  if [[ -z "$language" ]]; then
    # Default to generic mode
    language="auto-detect"
  fi
  
  # Create the appropriate system prompt for the AI
  local systemPrompt="You are an expert code readability improver. Your job is to rename variables, functions, and other identifiers to make code more readable. EXTREMELY IMPORTANT RULES:
1. NEVER change the functionality or logic of the code
2. Rename variables, functions, methods, and other identifiers to be more descriptive
3. Make variable names more descriptive and clear about their purpose
4. DO prefer longer, more descriptive names over short abbreviations
5. DO maintain the language's naming conventions (camelCase, snake_case, etc.)
6. You MAY add or modify comments to explain complex logic or the purpose of renamed variables
7. You MAY add new lines or restructure code slightly if it improves readability
8. DO NOT modify import statements, library calls, or API references unless you're 100% certain
9. DO NOT change the number of parameters or their order in function/method signatures
10. DO NOT use markdown formatting in your response (no triple backticks, no language tags)
11. If the code is already well-named and commented, return it as-is
12. Return ONLY the raw code with your improved variable and function names"
  
  # Create the main prompt for the AI
  local prompt="Improve the readability of the following code by renaming variables, functions, and other identifiers to be more descriptive and clear. You may add comments and restructure the code slightly if it improves readability, but maintain exact functionality.

Language: ${language}

Code to improve (preserve functionality):
${code}

CRITICAL: Return ONLY the raw renamed code with no additional explanation, no markdown formatting, no code block delimiters. The improved code must function exactly the same as the original."
  
  # Process with AI
  echo "[INFO] Analyzing code for identifier improvements and readability" >&2
  universalAiProcess --system "$systemPrompt" --direct "$prompt"
}
