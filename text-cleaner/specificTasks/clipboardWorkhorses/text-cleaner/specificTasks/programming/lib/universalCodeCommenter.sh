#!/bin/bash
# @file universalCodeCommenter.sh
# @brief Function that uses AI to intelligently comment complex code
# @description This script provides a function for adding insightful comments
#              to code, focusing only on complex or tricky parts

universalCodeCommenter() {
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
  local systemPrompt="You are an expert code commenter. Your job is to add helpful inline comments to code that explain complex or tricky parts. EXTREMELY IMPORTANT RULES:
1. ONLY comment parts that are non-obvious or require special attention
2. DO NOT comment trivial or self-explanatory code
3. PRESERVE EXACTLY ALL whitespace, indentation, line breaks, and empty lines - both at the beginning, middle, and end of the file
4. If the code is already well-commented or trivial, return it EXACTLY as-is, byte for byte
5. Focus comments on 'why' rather than 'what' the code does
6. Keep comments concise and valuable for experienced developers
7. Use the appropriate comment syntax for the language
8. NEVER modify the actual code logic, only add comments
9. DO NOT use markdown formatting in your response (no triple backticks, no language tags)
10. The output MUST have exactly the same line count as the input (including any empty lines at beginning or end)
11. Return ONLY the raw code with your added comments"
  
  # Create the main prompt for the AI
  local prompt="Add helpful inline comments to the following code, focusing ONLY on complex or tricky parts. The commented code will be pasted directly back to replace the original, so it MUST maintain EXACT formatting.

Language: ${language}

Code to comment (preserve ALL formatting, whitespace, and empty lines):
${code}

CRITICAL: Return ONLY the raw commented code with no additional explanation, no markdown formatting, no code block delimiters, and PRESERVING EXACTLY all whitespace including leading and trailing empty lines. The commented code should fit perfectly in place of the original when pasted back."
  
  # Process with AI
  echo "[INFO] Analyzing code for complex sections" >&2
  universalAiProcess --system "$systemPrompt" --direct "$prompt"
}
