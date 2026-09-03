# R Script to validate package structure and assets before deployment

message("Running pre-flight checks...")

errors_found <- FALSE

# Check 1: Verify manifest exists
if (!file.exists("manifest.json")) {
  message("Warning: manifest.json is missing. Run Rscript -e \"rsconnect::writeManifest()\" first.")
  errors_found <- TRUE
}

# Check 2: Verify renv.lock exists
if (!file.exists("renv.lock")) {
  message("Warning: renv.lock is missing. It is highly recommended to record package versions.")
  errors_found <- TRUE
}

# Check 3: Check for absolute paths in R scripts, Rmd, or Qmd files
r_files <- list.files(
  path = ".", 
  pattern = "\\.(R|Rmd|qmd)$", 
  recursive = TRUE, 
  full.names = TRUE
)

# Filter out files in renv directory
r_files <- r_files[!grepl("^\\./renv", r_files)]

absolute_path_pattern <- "(^[A-Za-z]:/[^/]|/home/|/Users/|/usr/local/)"

for (f in r_files) {
  lines <- readLines(f, warn = FALSE)
  for (i in seq_along(lines)) {
    if (grepl(absolute_path_pattern, lines[i]) && !grepl("^\\s*#", lines[i])) {
      message(sprintf("Warning: Potential absolute path in %s (line %d): '%s'", f, i, trimws(lines[i])))
    }
  }
}

if (errors_found) {
  message("Pre-flight checks completed with warnings/errors.")
  quit(status = 1)
} else {
  message("Pre-flight checks passed! The package is ready for deployment.")
}
