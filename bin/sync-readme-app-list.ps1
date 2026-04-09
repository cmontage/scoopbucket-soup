#Requires -Version 5.1

param(
    [string]$ReadmePath = "$PSScriptRoot\..\README.md",
    [string]$BucketPath = "$PSScriptRoot\..\bucket"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Escape-MarkdownTableText {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return '-'
    }

    $clean = $Text -replace "`r?`n", ' '
    $clean = $clean -replace '\|', '\|'
    return $clean.Trim()
}

$resolvedReadme = (Resolve-Path -LiteralPath $ReadmePath).Path
$resolvedBucket = (Resolve-Path -LiteralPath $BucketPath).Path

# Build Chinese table header from Unicode code points to avoid script file encoding issues.
$colAppName = ([char]0x5E94) + ([char]0x7528) + ([char]0x540D) + ([char]0x79F0)
$colDescription = ([char]0x63CF) + ([char]0x8FF0)
$colHomepage = ([char]0x5B98) + ([char]0x65B9) + ([char]0x7F51) + ([char]0x7AD9)

$rows = Get-ChildItem -LiteralPath $resolvedBucket -Filter '*.json' -File |
    Sort-Object -Property Name |
    ForEach-Object {
        $manifestFile = $_
        $appName = [System.IO.Path]::GetFileNameWithoutExtension($manifestFile.Name)
        $rawContent = Get-Content -LiteralPath $manifestFile.FullName -Raw -Encoding UTF8

        $description = '-'
        $homepage = '-'

        try {
            $manifest = $rawContent | ConvertFrom-Json
            $description = Escape-MarkdownTableText -Text ([string]$manifest.description)
            $homepage = Escape-MarkdownTableText -Text ([string]$manifest.homepage)
        }
        catch {
            Write-Warning "Failed to parse manifest as JSON: $($manifestFile.Name). Fallback to regex extraction."

            $descriptionMatch = [regex]::Match($rawContent, '"description"\s*:\s*"([^"\\]*(?:\\.[^"\\]*)*)"')
            if ($descriptionMatch.Success) {
                $description = Escape-MarkdownTableText -Text $descriptionMatch.Groups[1].Value
            }

            $homepageMatch = [regex]::Match($rawContent, '"homepage"\s*:\s*"([^"\\]*(?:\\.[^"\\]*)*)"')
            if ($homepageMatch.Success) {
                $homepage = Escape-MarkdownTableText -Text $homepageMatch.Groups[1].Value
            }
        }

        $appName = Escape-MarkdownTableText -Text $appName

        $homepageCell = if ($homepage -eq '-') { '-' } else { "[Link]($homepage)" }
        "| **$appName** | $description | $homepageCell |"
    }

$tableLines = @(
    '<!-- APP_LIST_START -->',
    "| $colAppName | $colDescription | $colHomepage |",
    '| :--- | :--- | :--- |'
) + $rows + @(
    '<!-- APP_LIST_END -->'
)

$tableBlock = ($tableLines -join [Environment]::NewLine)
$readmeContent = Get-Content -LiteralPath $resolvedReadme -Raw -Encoding UTF8

$startMarker = '<!-- APP_LIST_START -->'
$endMarker = '<!-- APP_LIST_END -->'

if ($readmeContent -notmatch [regex]::Escape($startMarker) -or $readmeContent -notmatch [regex]::Escape($endMarker)) {
    throw "README does not contain app list markers: $startMarker and $endMarker"
}

$updatedReadme = [regex]::Replace(
    $readmeContent,
    '(?s)<!-- APP_LIST_START -->.*?<!-- APP_LIST_END -->',
    [System.Text.RegularExpressions.MatchEvaluator]{
        param($m)
        $tableBlock
    },
    1
)

Set-Content -LiteralPath $resolvedReadme -Value $updatedReadme -Encoding UTF8
Write-Host 'README app list synchronized.'
