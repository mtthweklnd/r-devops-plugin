---
name: r-posit-devops
description: >-
  Automate the R/Posit development and DevOps lifecycle: restoring environments,
  testing, formatting with air, and deploying to Posit Connect. Use when preparing,
  validating, or deploying R apps (Shiny), APIs (Plumber), or reports (Quarto/R Markdown).
---

# R & Posit DevOps Workflow

This skill outlines the standard DevOps pipeline for validating and deploying R applications, APIs, or reports to Posit Connect.

## Core Lifecycle Stages

### Stage 1: Environment Sync (`renv`)
Ensure all dependencies are synchronized with `renv.lock`:
```bash
Rscript -e "renv::restore()"
```

### Stage 2: Code Formatting (`air`)
Format all R code prior to check-in or deployment:
```bash
air format .
```

### Stage 3: Testing (`testthat`)
Run the test suite to verify functionality:
```bash
Rscript -e "devtools::test()"
```

### Stage 4: Manifest Generation (`rsconnect`)
Generate `manifest.json` for environment image building on Posit Connect:
```bash
Rscript -e "rsconnect::writeManifest()"
```

### Stage 5: Pre-Flight Validation
Ensure the manifest exists, dependencies are recorded, and no absolute paths are hardcoded:
*   [validate_deployment.R](./scripts/validate_deployment.R): `Rscript scripts/validate_deployment.R`

### Stage 6: Publish (`rsconnect`)
Deploy the application, API, or document following the credential policies in `deploy-to-connect`:
*   [deploy_connect.R](./scripts/deploy_connect.R): `Rscript scripts/deploy_connect.R`
*   For advanced deployment options, consult the `deploy-to-connect` skill.
