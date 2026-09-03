---
name: r-package-development
description: R package development with devtools, testthat, and roxygen2. Use when the user is working on an R package, running tests, writing documentation, or building package infrastructure.
metadata:
  author: Simon P. Couch (@simonpcouch)
  version: "1.2"
---

# R package development

## Key commands

```
# Run code in the package
Rscript -e "devtools::load_all(); code"

# Run all tests
Rscript -e "devtools::test()"

# Run all tests for files starting with {name}
Rscript -e "devtools::test(filter = '^{name}')"

# Run all tests for R/{name}.R
Rscript -e "devtools::test_active_file('R/{name}.R')"

# Run a single test "blah" for R/{name}.R
Rscript -e "devtools::test_active_file('R/{name}.R', desc = 'blah')"

# Redocument the package
Rscript -e "devtools::document()"

# Check pkgdown documentation
Rscript -e "pkgdown::check_pkgdown()"

# Check the package with R CMD check
Rscript -e "devtools::check()"

# Format code
air format .
```

## Testing

- Tests for `R/{name}.R` go in `tests/testthat/test-{name}.R`.
- All new code should have an accompanying test.
- If there are existing tests, place new tests next to similar existing tests.
- Use specific expectations (`expect_equal()`, `expect_identical()`, `expect_named()`, `expect_type()`) over generic `expect_true()` / `expect_false()` for actionable failure diagnostics.
- Test structured conditions with `expect_error(..., class = "...")` or `expect_warning()`. Use snapshot tests (`expect_snapshot(error = TRUE)`) when validating multi-line formatting, CLI outputs, or full user-facing message text.
- Consult the `testing-r-packages` skill for comprehensive testing workflows, fixtures, mocking, and snapshot management.

## Package Documentation & pkgdown

- Follow base formatting/style rules in [r_posit_guidelines.md](../../rules/r_posit_guidelines.md) and commenting/roxygen2 rules in [r_documentation.md](../../rules/r_documentation.md).
- Whenever you add a new exported function topic, register the topic in `_pkgdown.yml`.
- Verify documentation references using `pkgdown::check_pkgdown()`.

## `NEWS.md`

- Every user-facing change should be given a bullet in `NEWS.md`. Do not add bullets for small documentation changes or internal refactorings.
- Each bullet should briefly describe the change to the end user.
- If the change is related to a function, put the name of the function early in the bullet.
- If the bullet is related to a GitHub issue or pull request, reference it by number in parentheses before the final period: `(#123).`.
- Order bullets alphabetically by function name. Put all bullets that don't mention function names at the beginning.
