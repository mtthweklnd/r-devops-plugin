# Plugin Lifecycle Hooks

This directory contains automated lifecycle hooks that enforce code style and keep package documentation synchronized.

## Hooks Included

### 1. `format_r` (`PostToolUse`)
* **Trigger**: Any `Edit` or `Write` on `.R`, `.r`, or `.qmd` files.
* **Action**: Runs Posit `air format <file>` on the touched file if `air` is installed in PATH.
* **Benefits**: Guarantees consistent 2-space indentation, tidy pipe syntax (`|>`), and clean line wrapping for comments and code without consuming LLM context tokens.

### 2. `check_roxygen` (`PostToolUse`)
* **Trigger**: Any `Edit` or `Write` on `.R` files containing roxygen blocks (`#' @`).
* **Action**: Locates the root package directory (via `DESCRIPTION`) and executes `Rscript -e "devtools::document(quiet=TRUE)"`.
* **Benefits**: Guarantees that `NAMESPACE` exports and `man/*.Rd` help files stay synchronized whenever function signatures, parameters, or export tags are modified.

## Platform Support
Hooks in `hooks.json` are configured to execute the Bash (`.sh`) scripts. Standalone PowerShell (`.ps1`) variants are also provided in this directory for manual execution or custom PowerShell setups on Windows.
