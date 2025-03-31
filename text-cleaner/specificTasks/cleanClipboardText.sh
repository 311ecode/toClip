#!/bin/bash
# @file cleanClipboardText.sh
# @brief Clean clipboard text using AI processing
# @description This script takes text from the clipboard, sends it to AI for cleanup
#              with proper Hungarian formatting, and returns the cleaned text to the clipboard.

# Function to get text from clipboard
getFromClip() {
  local clipboardContent=""
  
  if command -v pbpaste >/dev/null 2>&1; then
    # macOS
    clipboardContent=$(pbpaste)
  elif command -v xclip >/dev/null 2>&1; then
    # Linux with xclip
    clipboardContent=$(xclip -selection clipboard -o)
  else
    echo "No clipboard utility found (pbpaste/xclip)" >&2
    return 1
  fi
  
  echo "$clipboardContent"
}

# Function to clean text using AI
cleanText() {
  local textToClean="$1"
  local prompt="$2"

  # Combine the prompt and text
  local fullPrompt="$prompt

Az eredeti szöveg:
$textToClean

Kérlek, tisztítsd meg a fenti szöveget a megadott instrukciók szerint."

  # Process with AI
  universalAiProcess --system "You are a helpful text formatting assistant specialized in proper Hungarian grammar and formatting. Format text according to exact specifications while preserving content, word order and meaning." --direct "$fullPrompt"
}

# Main function
cleanClipboardText() {
  # Default prompt for Hungarian text cleaning
  local defaultPrompt="A most következő szövegeket le kell tisztítanod, a sorrendet meg kell tartanod, de az ékezeteket ki kell tenned. A szavakat, amiket egybe kell írni, egybe írd, amit külön, azt külön. A mondat elejét nagy betűvel kell kezdened és azokat a szavakat, amiknek amúgy is nagy betűvel kell kezdődnie, mint a tulajdonnevek. A csupa nagybetűvel írt szavakat hagyd meg csupa nagybetűsnek az átdolgozás után is. Távolítsd el a felesleges szóközöket, írásjeleket és speciális karaktereket. Törekedj a helyes magyar helyesírásra, különös tekintettel az egybe- és különírás szabályaira. A központozásra különösen figyelj oda: használj megfelelő vessződet, pontot, kettőspontot, pontosvessződet ahol szükséges, és a mondatok végén mindig legyen írásjel. Az ezer alatti számokat betűvel írd, kivéve a dátumokat és a mértékegységgel ellátott számokat. A rövidítéseket egységesen kezeld: a pont nélküli rövidítéseket hagyd pont nélkül, a ponttal használtakat ponttal. Az idegen szavakat a magyar helyesírás szabályai szerint írd át, ha azok már meghonosodtak a magyar nyelvben. Az idézeteket megfelelő idézőjelbe tedd, és az idézeten belüli idézethez használj belső idézőjelet. Ha a szöveg verses vagy versszerű formátumú (tehát a normál prózához képest többszörös sortöréseket tartalmaz), akkor ezt a szerkezetet feltétlenül meg kell tartani, nem szabad folyószöveggé alakítani."
  
  # Allow custom prompt file
  local prompt="$defaultPrompt"
  local promptFile=""

  # Parse options
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --prompt-file|-f)
        promptFile="$2"
        shift 2
        ;;
      --help|-h)
        echo "Usage: cleanClipboardText [OPTIONS]"
        echo "Clean text from clipboard using AI and Hungarian grammar rules"
        echo ""
        echo "Options:"
        echo "  --prompt-file, -f FILE   Use custom prompt from FILE"
        echo "  --help, -h               Show this help message"
        return 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        return 1
        ;;
    esac
  done

  # Use custom prompt if provided
  if [[ -n "$promptFile" && -f "$promptFile" ]]; then
    prompt=$(<"$promptFile")
  fi

  echo "Retrieving text from clipboard..." >&2
  local clipboardContent=$(getFromClip)
  
  if [[ -z "$clipboardContent" ]]; then
    echo "Error: Clipboard is empty" >&2
    return 1
  fi

  echo "Sending text to AI for cleaning..." >&2
  local cleanedText=$(cleanText "$clipboardContent" "$prompt")
  
  if [[ -z "$cleanedText" ]]; then
    echo "Error: Failed to get a response from AI" >&2
    return 1
  fi

  echo "Cleaning complete. Copying result to clipboard..." >&2
  toClip "$cleanedText" "Cleaned text copied to clipboard."
}

