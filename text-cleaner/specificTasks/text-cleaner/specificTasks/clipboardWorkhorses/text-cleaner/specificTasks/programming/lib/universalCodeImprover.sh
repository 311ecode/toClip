#!/bin/bash
# @file universalCodeImprover.sh
# @brief Function that uses AI to comprehensively improve code readability
# @description This script provides a function for improving code readability through
#              a combination of better variable/function naming, adding helpful comments,
#              and light refactoring while preserving functionality

universalCodeImprover() {
  local language="$1"
  local code="$2"
  local improvements="$3"  # Optional: comma-separated list of improvement types to apply
  
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
  
  # If no specific improvements are requested, enable all by default
  if [[ -z "$improvements" ]]; then
    improvements="rename,comment,refactor"
  fi
  
  # Parse the improvements string
  local do_rename=false
  local do_comment=false
  local do_refactor=false
  
  if [[ "$improvements" == "all" ]]; then
    do_rename=true
    do_comment=true
    do_refactor=true
  else
    if [[ "$improvements" == *"rename"* ]]; then do_rename=true; fi
    if [[ "$improvements" == *"comment"* ]]; then do_comment=true; fi
    if [[ "$improvements" == *"refactor"* ]]; then do_refactor=true; fi
  fi
  
  # Log what improvements we're making
  echo "[INFO] Code improvements to apply:" >&2
  if [[ "$do_rename" == true ]]; then echo "[INFO] - Renaming variables and functions" >&2; fi
  if [[ "$do_comment" == true ]]; then echo "[INFO] - Adding helpful comments" >&2; fi
  if [[ "$do_refactor" == true ]]; then echo "[INFO] - Light refactoring" >&2; fi
  
  # Create the appropriate system prompt for the AI based on requested improvements
  local systemPrompt="You are an expert code improver. Your job is to make code more readable and maintainable while preserving its exact functionality. EXTREMELY IMPORTANT RULES:
1. NEVER change the functionality or logic of the code
2. Preserve imports, library calls, and API references unless you're 100% certain"

  # Add specific improvement instructions based on what's enabled
  if [[ "$do_rename" == true ]]; then
    systemPrompt+="
3. Rename variables, functions, methods, and other identifiers to be more descriptive
4. Make variable names clear about their purpose and prefer descriptive names over abbreviations
5. Maintain the language's naming conventions (camelCase, snake_case, etc.)"
  fi
  
  if [[ "$do_comment" == true ]]; then
    systemPrompt+="
6. Add helpful comments to explain complex logic, unusual patterns, or the 'why' behind the code
7. Focus on commenting non-obvious parts of the code that require explanation
8. Use the appropriate comment syntax for the language"
  fi
  
  if [[ "$do_refactor" == true ]]; then
    systemPrompt+="
9. Apply light refactoring where it clearly improves readability
10. You may restructure code slightly, extract repetitive patterns, or simplify expressions
11. You may add new lines or adjust spacing to improve code organization
12. Never change parameter counts, orders, or return values"
  fi
  
  systemPrompt+="
13. DO NOT use markdown formatting in your response (no triple backticks, no language tags)
14. Return ONLY the raw improved code with no additional explanation"
  
  # Create the main prompt for the AI
  local prompt="Improve the following code to make it more readable and maintainable. "
  
  # Add specific improvement instructions to the prompt
  local improvements_list=""
  if [[ "$do_rename" == true ]]; then improvements_list+="rename variables and functions to be more descriptive, "; fi
  if [[ "$do_comment" == true ]]; then improvements_list+="add helpful comments to explain complex parts, "; fi
  if [[ "$do_refactor" == true ]]; then improvements_list+="apply light refactoring to improve structure, "; fi
  
  # Trim trailing comma and space, then add the improvements list to the prompt
  improvements_list="${improvements_list%, }"
  prompt+="Your task is to ${improvements_list} while preserving exact functionality.

Language: ${language}

Code to improve:
${code}

CRITICAL: Return ONLY the raw improved code with no additional explanation, no markdown formatting, no code block delimiters. The improved code must function exactly the same as the original."
  
  # Process with AI
  echo "[INFO] Analyzing and improving code" >&2
  universalAiProcess --system "$systemPrompt" --direct "$prompt"
}
