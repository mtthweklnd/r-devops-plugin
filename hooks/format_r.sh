#!/usr/bin/env bash
# PostToolUse Hook: Automatically format R and Quarto files using Posit `air`

# Read tool input JSON from stdin if piped
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  FILE_PATH="$CLAUDE_TOOL_INPUT_FILE_PATH"
fi

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Check if file has an R or Quarto extension
if [[ "$FILE_PATH" =~ \.(R|r|qmd|Qmd)$ ]]; then
  if command -v air &> /dev/null; then
    if [ -f "$FILE_PATH" ]; then
      air format "$FILE_PATH" > /dev/null 2>&1 || true
      echo "Formatted $FILE_PATH with air"
    fi
  fi
fi

exit 0
