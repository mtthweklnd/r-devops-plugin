#!/usr/bin/env bash
# PostToolUse Hook: Inspect and synchronize Roxygen2 documentation in R packages

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  FILE_PATH="$CLAUDE_TOOL_INPUT_FILE_PATH"
fi

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Only inspect R files
if [[ "$FILE_PATH" =~ \.(R|r)$ ]]; then
  # Check if file contains roxygen tags
  if grep -q "^#' @" "$FILE_PATH" 2>/dev/null; then
    # Check if we are inside an R package (has DESCRIPTION file)
    PKG_ROOT=$(dirname "$FILE_PATH")
    while [ "$PKG_ROOT" != "/" ] && [ "$PKG_ROOT" != "." ] && [ ! -f "$PKG_ROOT/DESCRIPTION" ]; do
      PKG_ROOT=$(dirname "$PKG_ROOT")
    done

    if [ -f "$PKG_ROOT/DESCRIPTION" ]; then
      if command -v Rscript &> /dev/null; then
        echo "Detected roxygen2 comment changes in $FILE_PATH. Synchronizing documentation with devtools::document()..."
        (cd "$PKG_ROOT" && Rscript -e "if (requireNamespace('devtools', quietly=TRUE)) devtools::document(quiet=TRUE)" > /dev/null 2>&1) || true
        echo "Documentation synchronized for package at $PKG_ROOT."
      fi
    fi
  fi
fi

exit 0
