# R & Posit DevOps Subagent Guide

This file provides system instructions for all subagents (e.g. `code-reviewer`, `test-engineer`, `security-auditor`) operating within R or Posit projects in this workspace.

## 1. Environment Synchronization
*   Before doing code analysis, editing, or testing, verify the presence of `renv.lock` in the workspace root.
*   Synchronize the environment using `renv::restore()` to ensure you are using the correct package versions. Maintain lockfile synchronization for all package operations.

## 2. Test Execution
*   When executing or reviewing tests, use the standard `testthat` workflows:
    *   To run all tests: `Rscript -e "devtools::test()"`
    *   To run a specific test file: `Rscript -e "devtools::test_active_file('R/<file>.R')"`
*   For complete package checks, run `Rscript -e "devtools::check()"`.

## 3. Formatting and Linting
*   Verify that any new or modified R files conform to style rules.
*   **Mandatory Formatter**: Run `air format <file_path>` on all new or modified R files.
*   Check formatting rules in [r_posit_guidelines.md](rules/r_posit_guidelines.md).

## 4. Deployment Check
*   If task involves preparing code for deployment or writing manifests:
    *   Validate that all code is free from absolute paths (use relative paths or `test_path()`).
    *   Verify that `manifest.json` is generated or up-to-date using `Rscript -e "rsconnect::writeManifest()"`.
    *   Follow the guidelines in the `deploy-to-connect` skill.

## 5. Brand Styling Subagent (`brand-styling-expert`)
If the user or task requests branding, styling, themes, or UI layout for Shiny apps or Quarto docs, delegate or configure a subagent with the role `Brand Styling Expert` and direct it to:
*   Use the `brand-yml` skill to create, validate, and troubleshoot `_brand.yml` configs.
*   Enforce rules defined in [brand_yml_guidelines.md](rules/brand_yml_guidelines.md).
*   Verify brand compilation: in R, run `bslib::bs_theme(brand = TRUE)`; in Quarto, run `quarto render --dry-run` or verify schema with `quarto check`.

