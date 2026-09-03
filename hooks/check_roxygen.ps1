# PostToolUse Hook: Inspect and synchronize Roxygen2 documentation in R packages
param (
    [string]$FilePath = $env:CLAUDE_TOOL_INPUT_FILE_PATH
)

if (-not $FilePath -and [Console]::IsInputRedirected) {
    try {
        $inputJson = [Console]::In.ReadToEnd() | ConvertFrom-Json
        $FilePath = $inputJson.tool_input.file_path
    } catch {}
}

if (-not $FilePath -or -not (Test-Path $FilePath)) {
    exit 0
}

$ext = [System.IO.Path]::GetExtension($FilePath).ToLower()
if ($ext -in @('.r')) {
    $hasRoxygen = Get-Content -Path $FilePath -ErrorAction SilentlyContinue | Select-String "^#' @" -Quiet
    if ($hasRoxygen) {
        $dir = Split-Path -Path (Resolve-Path $FilePath) -Parent
        while ($dir -and -not (Test-Path (Join-Path $dir "DESCRIPTION"))) {
            $parent = Split-Path -Path $dir -Parent
            if ($parent -eq $dir) { break }
            $dir = $parent
        }

        if ($dir -and (Test-Path (Join-Path $dir "DESCRIPTION"))) {
            $rscript = Get-Command Rscript -ErrorAction SilentlyContinue
            if ($rscript) {
                Write-Host "Detected roxygen2 changes in $FilePath. Synchronizing documentation with devtools::document()..."
                Push-Location $dir
                try {
                    & Rscript -e "if (requireNamespace('devtools', quietly=TRUE)) devtools::document(quiet=TRUE)" 2>&1 | Out-Null
                    Write-Host "Documentation synchronized for package at $dir"
                } finally {
                    Pop-Location
                }
            }
        }
    }
}

exit 0
