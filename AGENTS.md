# R & Posit DevOps Subagent Guide

System instructions for the subagents in this plugin (`r-test-engineer`, `brand-styling-expert`) operating within R or Posit projects.

## 1. Environment Synchronization

Before code analysis, editing, or testing, verify `renv.lock` exists in the workspace root and restore it. See [rules/r_posit_guidelines.md](rules/r_posit_guidelines.md) for the full dependency-management workflow.

## 2. Testing

For test authoring, refactoring, or suite verification, invoke [`r-test-engineer`](agents/r-test-engineer.md) — its own definition carries the full `testthat` workflow.

## 3. Formatting & Documentation

New or modified R files must conform to [rules/r_posit_guidelines.md](rules/r_posit_guidelines.md) (formatting, style, `renv`) and [rules/r_documentation.md](rules/r_documentation.md) (comments, roxygen2). The `format_r` and `check_roxygen` hooks apply formatting and re-document automatically after each edit — see [hooks/README.md](hooks/README.md).

## 4. Brand Styling

For branding, styling, themes, or UI layout on Shiny apps or Quarto docs, invoke [`brand-styling-expert`](agents/brand-styling-expert.md) — its own definition carries the full workflow and the `brand-yml`/`shiny-bslib` skills.

## 5. Azure DevOps & Work Item Tracking

When querying or updating work items, inspecting pull requests, or checking build pipelines in Azure DevOps, use the `@azure-devops/mcp` tools. Refer to [`skills/azure-devops-mcp`](skills/azure-devops-mcp/SKILL.md) for authentication prerequisites (`AZURE_DEVOPS_ORG`, base64-encoded `AZURE_DEVOPS_PAT`), work item mutation schemas, and troubleshooting guidelines.
