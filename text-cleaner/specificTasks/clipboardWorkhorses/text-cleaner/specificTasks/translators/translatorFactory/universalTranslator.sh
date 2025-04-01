#!/bin/bash
# @file universalTranslator.sh
# @brief Universal translator function that uses AI for detection and translation
# @description This script provides a function for detecting source language and
#              translating text to various target languages using AI, returning only the translated text

universalTranslator() {
  local targetLang="$1"
  local text="$2"
  
  # If no text is provided, get from clipboard
  if [[ -z "$text" ]]; then
    text=$(getFromClip)
    if [[ -z "$text" ]]; then
      echo "[ERROR] No text provided and clipboard is empty" >&2
      return 1
    fi
  fi
  
  # If no target language is specified, default to English
  if [[ -z "$targetLang" ]]; then
    targetLang="en"
    echo "[INFO] No target language specified, defaulting to English" >&2
  fi
  
  # Create the appropriate system prompt for the AI
  local systemPrompt="You are a professional translator. You will be given text in any language, and your task is to translate it accurately into ${targetLang}. Provide ONLY the translated text with no additional explanation, comments, or formatting. Maintain the original formatting of the source text in your translation."
  
  # Create the main prompt for the AI
  local prompt="Translate the following text into ${targetLang}. Return ONLY the translated text, with no explanations, commentary, or additional information:

${text}"
  
  # Process with AI
  echo "[INFO $(date '+%H:%M:%S')] Translating to ${targetLang}" >&2
  universalAiProcess --system "$systemPrompt" --direct "$prompt"
}
