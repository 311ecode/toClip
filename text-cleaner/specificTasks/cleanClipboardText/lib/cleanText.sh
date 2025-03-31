#!/bin/bash

cleanText() {
  local textToClean="$1"
  local prompt="$2"
  local systemPrompt="$3"

  # Combine the prompt and text
  local fullPrompt="$prompt

Original text:
$textToClean

Please process the above text according to the provided instructions."

  # Process with AI
  universalAiProcess --system "$systemPrompt" --direct "$fullPrompt"
}
