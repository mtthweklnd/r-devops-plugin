# PostToolUse Hook: Automatically format R and Quarto files using Posit `air`
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
if ($ext -in @('.r', '.qmd')) {
    $airCmd = Get-Command air -ErrorAction SilentlyContinue
    if ($airCmd) {
        & air format "$FilePath" 2>&1 | Out-Null
        Write-Host "Formatted $FilePath with air"
    }
}

exit 0
