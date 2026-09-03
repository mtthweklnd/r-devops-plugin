---
paths:
  - "**/*.R"
  - "**/*.r"
  - "DESCRIPTION"
  - "NAMESPACE"
---

# R & Posit Code Quality and Formatting Guidelines

This rule sheet defines coding standards and guidelines for R and Posit projects in this workspace.

## 1. Code Formatting & Linting (`air` CLI)

Posit `air` (https://posit-dev.github.io/air/cli.html) is the standard linter and formatter for this codebase.
*   **Format on Edit**: Run `air format .` (or `air format <file>`) after writing or modifying R code.
*   **Format Check in CI**: Automated build checks require clean `air` formatting before merging.

## 2. Dependency Management (`renv`)

*   **Lockfile Declarative Management**: Manage all package dependencies through `renv` and `renv.lock`.
*   **Restoring**: Use `renv::restore()` to synchronize the local library environment with `renv.lock` before executing tasks or tests.
*   **Adding Packages**: Add new packages via `renv::install("<package>")` followed by `renv::snapshot()` to record the dependency in the lockfile.

## 3. R Coding Style Conventions

*   **Base Pipe Operator**: Use the native base pipe operator (`|>`) for pipeline chaining.
*   **Anonymous Functions**: Use the shorthand `\() ...` syntax for single-line anonymous functions. Use `function() { ... }` for multi-line functions.
*   **Variable Names**: Use snake_case for all variable, function, and file names (e.g., `my_function_name`, `data_source.R`).

## 4. Documentation

*   **roxygen2**: Document all exported user-facing functions with roxygen2 headers.
*   **Line Length**: Wrap roxygen comment blocks at 80 characters.
*   **Internal Helpers**: Document internal (non-exported) functions using standard R comments (`#`).
*   **Re-document**: Run `devtools::document()` after creating or editing roxygen2 headers.
