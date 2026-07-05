[CmdletBinding()]
param(
    [ValidateSet('markdown', 'json', 'csv')]
    [string]$OutputFormat = 'json',

    [string]$OutputFile,

    [int]$Count = 1,

    [string]$SightFile = (Join-Path $PSScriptRoot 'prompts/sight.yaml'),

    [string]$SoundFile = (Join-Path $PSScriptRoot 'prompts/sound.yaml'),

    [string]$StoryFile = (Join-Path $PSScriptRoot 'prompts/story.yaml')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Count -lt 1) {
    throw 'Count must be at least 1.'
}

if ([string]::IsNullOrWhiteSpace($OutputFile)) {
    $extension = switch ($OutputFormat) {
        'markdown' { 'md' }
        'json' { 'json' }
        'csv' { 'csv' }
    }

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $OutputFile = Join-Path $PWD ("writing-prompts-$timestamp.$extension")
}

foreach ($file in @($SightFile, $SoundFile, $StoryFile)) {
    if (-not (Test-Path -LiteralPath $file)) {
        throw "Prompt file not found: $file"
    }
}

function Get-PromptOptions {
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$PropertyName
    )

    $lines = Get-Content -LiteralPath $Path
    $items = @()
    $inSection = $false

    foreach ($line in $lines) {
        if ($line -match "^\s*$PropertyName\s*:\s*$") {
            $inSection = $true
            continue
        }

        if (-not $inSection) {
            continue
        }

        if ($line -match '^\s*([A-Za-z0-9_-]+)\s*:\s*$') {
            break
        }

        if ($line -match '^\s*-\s*(.+?)\s*$') {
            $value = $Matches[1].Trim()
            if (
                ($value.StartsWith("'") -and $value.EndsWith("'")) -or
                ($value.StartsWith('"') -and $value.EndsWith('"'))
            ) {
                $value = $value.Substring(1, $value.Length - 2)
            }

            $items += $value
        }
    }

    if ($items.Count -eq 0) {
        throw "YAML file '$Path' must contain a '$PropertyName' list."
    }

    if ($items.Count -lt 20) {
        throw "YAML file '$Path' must contain at least 20 '$PropertyName' entries."
    }

    return $items
}

$sights = Get-PromptOptions -Path $SightFile -PropertyName 'sight'
$sounds = Get-PromptOptions -Path $SoundFile -PropertyName 'sound'
$stories = Get-PromptOptions -Path $StoryFile -PropertyName 'story'

$combinations = foreach ($sight in $sights) {
    foreach ($sound in $sounds) {
        foreach ($story in $stories) {
            [PSCustomObject]@{
                Sight = [string]$sight
                Sound = [string]$sound
                Story = [string]$story
            }
        }
    }
}

if ($Count -gt $combinations.Count) {
    throw "Count ($Count) exceeds available unique combinations ($($combinations.Count))."
}

$selectedPrompts = $combinations | Get-Random -Count $Count

switch ($OutputFormat) {
    'json' {
        $selectedPrompts | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutputFile -Encoding utf8
    }
    'csv' {
        $selectedPrompts | Export-Csv -LiteralPath $OutputFile -NoTypeInformation -Encoding utf8
    }
    'markdown' {
        $lines = @(
            '# Sight, Sound, Story Writing Prompts'
            ''
            '| # | Sight | Sound | Story |'
            '|---|---|---|---|'
        )

        $i = 1
        foreach ($prompt in $selectedPrompts) {
            $safeSight = ([string]$prompt.Sight).Replace('|', '\|')
            $safeSound = ([string]$prompt.Sound).Replace('|', '\|')
            $safeStory = ([string]$prompt.Story).Replace('|', '\|')
            $lines += "| $i | $safeSight | $safeSound | $safeStory |"
            $i++
        }

        $lines | Set-Content -LiteralPath $OutputFile -Encoding utf8
    }
}

Get-Content -LiteralPath $OutputFile -Raw | Write-Host
