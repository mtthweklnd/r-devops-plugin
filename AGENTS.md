# R & Posit DevOps Subagent Guide

This file provides system instructions for all subagents (e.g. `r-test-engineer`, `brand-styling-expert`, `code-reviewer`, `security-auditor`) operating within R or Posit projects in this workspace.

## 1. Environment Synchronization
*   Before doing code analysis, editing, or testing, verify the presence of `renv.lock` in the workspace root.
*   Synchronize the environment using `renv::restore()` to ensure you are using the correct package versions. Maintain lockfile synchronization for all package operations.

## 2. Test Execution & QA Subagent (`r-test-engineer`)
*   For dedicated test authoring, refactoring, and test suite verification, invoke or configure the `r-test-engineer` subagent defined in [agents/r-test-engineer.md](agents/r-test-engineer.md).
*   Follow standard `testthat` workflows:
    *   To run all tests: `Rscript -e "devtools::test()"`
    *   To run a specific test file: `Rscript -e "devtools::test_active_file('tests/testthat/test-<name>.R')"`
    *   To check coverage: `Rscript -e "covr::package_coverage()"`
*   For complete package checks, run `Rscript -e "devtools::check()"`.

## 3. Formatting, Linting & Documentation
*   Verify that any new or modified R files conform to style rules in [rules/r_posit_guidelines.md](rules/r_posit_guidelines.md).
*   **Mandatory Formatter**: Run `air format <file_path>` on all new or modified R files.
*   Follow code commenting and roxygen2 guidelines in [rules/r_documentation.md](rules/r_documentation.md).
*   Sync documentation after roxygen updates using `Rscript -e "devtools::document()"`.

## 4. Deployment Check
*   If task involves preparing code for deployment or writing manifests:
    *   Validate that all code is free from absolute paths (use relative paths or `test_path()`).
    *   Verify that `manifest.json` is generated or up-to-date using `Rscript -e "rsconnect::writeManifest()"`.
    *   Follow the guidelines in the `deploy-to-connect` skill.

## 5. Brand Styling Subagent (`brand-styling-expert`)
If the user or task requests branding, styling, themes, or UI layout for Shiny apps or Quarto docs, delegate or configure the `brand-styling-expert` subagent defined in [agents/brand-styling-expert.md](agents/brand-styling-expert.md) and direct it to:
*   Use the `brand-yml` skill to create, validate, and troubleshoot `_brand.yml` configs.
*   Enforce rules defined in [rules/brand_yml_guidelines.md](rules/brand_yml_guidelines.md).
*   Verify brand compilation: in R, run `bslib::bs_theme(brand = TRUE)`; in Quarto, run `quarto render --dry-run` or verify schema with `quarto check`.
