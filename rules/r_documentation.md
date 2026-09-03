---
paths:
  - "R/**/*.R"
  - "R/**/*.r"
  - "man/**/*.Rd"
  - "vignettes/**/*"
  - "DESCRIPTION"
---

# R Documentation and Commenting Standards

This rule sheet defines standards for inline code comments, roxygen2 documentation, and package metadata.

## 1. Inline Code Comments
*   **Explain "Why", Not "What"**: Do not restate basic syntax (e.g., `# filter rows where x > 5`). Use inline comments to explain algorithmic decisions, mathematical rationales, API limitations, or defensive workarounds (e.g., `# Handle edge case where dplyr::coalesce drops factor levels`).
*   **Section Dividers**: Organize complex files using standard RStudio section dividers: `# Section Name ----` (ending with at least 4 hyphens or equals signs).
*   **Line Wrapping**: Wrap inline comments at 80 characters. Keep comment blocks above the code line rather than end-of-line where possible.

## 2. Roxygen2 Header Standards (Exported Functions)
*   Every exported function **must** include a complete roxygen block:
    *   `@title`: Concise one-line title in sentence case (without a trailing period).
    *   `@description`: 1-2 paragraphs detailing the function's purpose, preconditions, and high-level behavior.
    *   `@param <arg>`: Description for every argument, explicitly detailing accepted types, classes, expected dimensions, and default behavior if omitted.
    *   `@return`: Explicitly document return type, S3/S4 class, and structure (e.g., `A tibble with columns 'id' (<character>) and 'score' (<numeric>)`).
    *   `@examples`: Self-contained runnable examples. Use `\dontrun{}` only for examples requiring interactive sessions or external credentials.
    *   `@export`: Must be present for public API functions.
    *   `@seealso`: Link to related functions or external documentation where applicable.

## 3. Internal Functions and Helpers
*   Document non-exported functions using either:
    *   `#' @noRd` with complete roxygen blocks for complex internal functions.
    *   Standard `#` comment blocks detailing the function's internal invariants and expected inputs.

## 4. Documentation Synchronization
*   Whenever a roxygen2 header or tag (`@export`, `@importFrom`, etc.) is added or modified, synchronize the documentation:
    ```r
    devtools::document()
    ```
*   Verify that `man/*.Rd` files and `NAMESPACE` update cleanly without warnings.
