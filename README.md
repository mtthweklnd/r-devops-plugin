# R & Posit DevOps Plugin

A Claude Code plugin that turns Claude into an R/Posit-aware collaborator — it enforces house style automatically, hands off testing and branding work to specialist subagents, and equips Claude with deep reference knowledge of the Posit ecosystem (Shiny, Quarto, bslib, brand.yml).

## Features

### Subagents
Delegate focused work to purpose-built agents:

- **[`r-test-engineer`](agents/r-test-engineer.md)** — Designs, writes, refactors, and debugs `testthat` 3 suites: fixtures, `withr`-based cleanup, mocking, snapshot testing, and `covr` coverage analysis.
- **[`brand-styling-expert`](agents/brand-styling-expert.md)** — Creates and validates `_brand.yml` files, `bslib` Bootstrap 5 themes, and Quarto theming for consistent corporate styling across Shiny apps and documents.

### Automated formatting & documentation (hooks)
Two `PostToolUse` hooks fire automatically on every `Edit`/`Write`, so style and docs never drift:

- **`format_r`** — Runs Posit's [`air`](https://posit-dev.github.io/air/cli.html) formatter on any touched `.R`, `.r`, or `.qmd` file.
- **`check_roxygen`** — Detects roxygen blocks (`#' @`), locates the package root via `DESCRIPTION`, and runs `devtools::document()` to keep `NAMESPACE` and `man/*.Rd` in sync with the code.

Hooks are wired via Bash scripts (`.sh`). Standalone PowerShell (`.ps1`) variants are also included in [`hooks/`](hooks/README.md) for manual execution or custom Windows setups.

### Coding standard rules
Path-scoped rules Claude applies automatically when it touches matching files:

- **[`rules/r_posit_guidelines.md`](rules/r_posit_guidelines.md)** — `air` formatting, `renv` dependency management, base pipe (`|>`) and `\() ` lambda conventions, snake_case naming.
- **[`rules/r_documentation.md`](rules/r_documentation.md)** — Inline comment conventions, complete roxygen2 headers for exported functions, internal helper documentation, and `devtools::document()` synchronization.

### Reference skills
Bundled skills give Claude detailed, on-demand knowledge of the Posit toolchain:

| Skill | Covers |
|---|---|
| [`r-package-development`](skills/r-package-development/SKILL.md) | `devtools`, `testthat`, `roxygen2` package workflows |
| [`testing-r-packages`](skills/testing-r-packages/SKILL.md) | testthat 3 structure, fixtures, mocking, snapshots |
| [`shiny-bslib`](skills/shiny-bslib/SKILL.md) | Modern Shiny UI with bslib (layouts, cards, value boxes, theming, inputs) |
| [`brand-yml`](skills/brand-yml/SKILL.md) | `_brand.yml` authoring for Shiny (R/Python) and Quarto |
| [`quarto-authoring`](skills/quarto-authoring/SKILL.md) | Quarto docs, sites, and books; migration from R Markdown/bookdown/blogdown/xaringan/distill/Jupyter |
| [`azure-devops-mcp`](skills/azure-devops-mcp/SKILL.md) | Azure DevOps MCP setup, PAT base64 encoding, work item CRUD, repos, and pipelines |

### MCP integration
Bundled via [`.mcp.json`](.mcp.json) (see [`skills/azure-devops-mcp`](skills/azure-devops-mcp/SKILL.md) for complete operation schemas, field references, and troubleshooting):

- **`azure-devops`** — Wraps the official [`@azure-devops/mcp`](https://www.npmjs.com/package/@azure-devops/mcp) server (stdio) so Claude can read/write work items, browse repos, and inspect pipelines directly in Azure DevOps. Tools surface as `mcp__plugin_r-posit-devops-plugin_azure-devops__*`; run `/mcp` to confirm the server connected.

  Required environment variables:

  | Variable | Description |
  |---|---|
  | `AZURE_DEVOPS_ORG` | Short org name, e.g. `my-org` for `https://dev.azure.com/my-org` |
  | `AZURE_DEVOPS_PAT` | A Personal Access Token, **base64-encoded** as `{email}:{raw_token}` before being set. In PowerShell: `[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$email`:$rawPat"))`. In bash: `printf '%s:%s' "$EMAIL" "$RAW_PAT" \| base64` |

  Recommended PAT scopes: Work Items (Read & Write), Code (Read & Write) if using repo tools, Build (Read & Execute) if triggering pipelines.

## Installation

Add this repository as a plugin marketplace source and install it in Claude Code:

```
/plugin marketplace add mtthweklnd/r-devops-plugin
/plugin install r-posit-devops-plugin
```

Or, if you manage plugins locally, clone the repo into your Claude Code plugins directory.

## Use Cases

- **Building or maintaining an R package** — Claude documents functions with roxygen2, keeps `NAMESPACE`/`man/` in sync, and hands test authoring to `r-test-engineer` on request.
- **Writing `testthat` suites** — ask Claude to add coverage for a function or fix a failing test; `r-test-engineer` designs isolated, self-contained tests with proper fixtures and mocking.
- **Building a Shiny dashboard** — the `shiny-bslib` skill guides modern `bslib` layouts, and `brand-styling-expert` applies a consistent `_brand.yml` theme.
- **Authoring or migrating Quarto documents** — the `quarto-authoring` skill covers callouts, cross-references, citations, and step-by-step migration from R Markdown, bookdown, blogdown, xaringan, or distill.
- **Tracking work items and pipelines in Azure DevOps** — query assigned tasks, create user stories with markdown acceptance criteria, and inspect PRs and build runs via the `azure-devops-mcp` skill and `@azure-devops/mcp` tools.
- **Keeping a codebase clean without manual effort** — every edit to `.R`/`.qmd` files is auto-formatted with `air` and re-documented with `devtools::document()`, so style and doc drift never accumulate.
- **Managing dependencies** — Claude follows `renv`-based workflows (`renv::restore()`, `renv::install()`, `renv::snapshot()`) automatically per [`rules/r_posit_guidelines.md`](rules/r_posit_guidelines.md).

## Repository Structure

```
.claude-plugin/  Plugin manifest (plugin.json) and marketplace catalog (marketplace.json)
.mcp.json        Bundled MCP servers (azure-devops)
agents/          Subagent definitions (r-test-engineer, brand-styling-expert)
hooks/           PostToolUse automation (format_r, check_roxygen) + hooks.json
rules/           Path-scoped coding and documentation standards
skills/          Reference knowledge for r-package-development, testing, shiny-bslib,
                 brand-yml, quarto-authoring, and azure-devops-mcp
AGENTS.md        System instructions tying the above together for subagents
```
