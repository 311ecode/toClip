#!/bin/bash
# @file universalCodeObfuscator.sh
# @brief Function that uses AI to deliberately obfuscate code
# @description This script provides a function for making code harder to read by
#              shortening variable names, removing comments, and restructuring code
#              while preserving its exact functionality

universalCodeObfuscator() {
  local language="$1"
  local code="$2"
  local techniques="$3"  # Optional: comma-separated list of obfuscation techniques to apply
  
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
  
  # If no specific techniques are requested, enable all by default
  if [[ -z "$techniques" ]]; then
    techniques="rename,uncomment,restructure"
  fi
  
  # Parse the techniques string
  local do_rename=false
  local do_uncomment=false
  local do_restructure=false
  
  if [[ "$techniques" == "all" ]]; then
    do_rename=true
    do_uncomment=true
    do_restructure=true
  else
    if [[ "$techniques" == *"rename"* ]]; then do_rename=true; fi
    if [[ "$techniques" == *"uncomment"* ]]; then do_uncomment=true; fi
    if [[ "$techniques" == *"restructure"* ]]; then do_restructure=true; fi
  fi
  
  # Log what obfuscation techniques we're applying
  echo "[INFO] Code obfuscation techniques to apply:" >&2
  if [[ "$do_rename" == true ]]; then echo "[INFO] - Shortening variable and function names" >&2; fi
  if [[ "$do_uncomment" == true ]]; then echo "[INFO] - Removing comments" >&2; fi
  if [[ "$do_restructure" == true ]]; then echo "[INFO] - Restructuring code" >&2; fi
  
  # Create the appropriate system prompt for the AI based on requested techniques
  local systemPrompt="You are an expert code obfuscator. Your job is to make code harder to read and understand while preserving its exact functionality. EXTREMELY IMPORTANT RULES:
1. NEVER change the functionality or logic of the code
2. Preserve imports, library calls, and API references
3. Do not use advanced obfuscation techniques that require specialized tools
4. Make sure the code still runs correctly after obfuscation"

  # Add specific obfuscation instructions based on what's enabled
  if [[ "$do_rename" == true ]]; then
    systemPrompt+="
5. Rename variables, functions, methods, and other identifiers to be shorter and less descriptive
6. Use single letters (a, b, c, etc.) or short ambiguous names for variables
7. Use similar-looking names for different variables (e.g., l1, l, I, i, etc.)
8. Maintain the language's syntax requirements"
  fi
  
  if [[ "$do_uncomment" == true ]]; then
    systemPrompt+="
9. Remove all comments from the code
10. Remove documentation strings and other explanatory text"
  fi
  
  if [[ "$do_restructure" == true ]]; then
    systemPrompt+="
11. Restructure the code to be less readable - use longer lines, fewer line breaks
12. Combine multiple operations into single lines where possible
13. Use more complex expressions instead of simple ones
14. Replace clear control structures with equivalent but less obvious alternatives
15. Remove or reduce indentation while preserving functionality"
  fi
  
  systemPrompt+="
16. DO NOT use markdown formatting in your response (no triple backticks, no language tags)
17. Return ONLY the raw obfuscated code with no additional explanation"
  
  # Create the main prompt for the AI
  local prompt="Obfuscate the following code to make it harder to read and understand. "
  
  # Add specific techniques to the prompt
  local techniques_list=""
  if [[ "$do_rename" == true ]]; then techniques_list+="shorten variable and function names to be less descriptive, "; fi
  if [[ "$do_uncomment" == true ]]; then techniques_list+="remove all comments and documentation, "; fi
  if [[ "$do_restructure" == true ]]; then techniques_list+="restructure the code to be less readable, "; fi
  
  # Trim trailing comma and space, then add the techniques list to the prompt
  techniques_list="${techniques_list%, }"
  prompt+="Your task is to ${techniques_list} while preserving exact functionality.

Language: ${language}

Code to obfuscate:
${code}

CRITICAL: Return ONLY the raw obfuscated code with no additional explanation, no markdown formatting, no code block delimiters. The obfuscated code must function exactly the same as the original."
  
  # Process with AI
  echo "[INFO] Obfuscating code" >&2
  universalAiProcess --system "$systemPrompt" --direct "$prompt"
}
