#!/bin/bash
# @file createTranslator.sh
# @brief Function to create new translator functions
# @description This script provides a function that generates new translator
#              functions for additional languages

createTranslator() {
  local language="$1"
  local fileName="translators/cwh-translateTo${language}.sh"
  
  # Ensure language name is provided
  if [[ -z "$language" ]]; then
    echo "Usage: createTranslator LanguageName"
    return 1
  fi
  
  # Capitalize first letter
  language="${language^}"
  
  # Check if file already exists
  if [[ -f "$fileName" ]]; then
    echo "Translator for $language already exists: $fileName"
    return 1
  fi
  
  # Create the translator file
  cat > "$fileName" << EOF
#!/bin/bash
# @file cwh-translateTo${language}.sh
cwh-translateTo${language}() {
  cwhTranslate "${language}"
}
EOF
  
  # Make it executable
  chmod +x "$fileName"
  
  echo "Created translator for ${language}"
  
  return 0
}
