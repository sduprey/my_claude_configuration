# Sync personal Claude Code config between this repo and ~/.claude
#   .\sync.ps1 export   -> copy this laptop's config into the repo
#   .\sync.ps1 import   -> install the repo's config on this laptop (backs up first)
param([Parameter(Mandatory)][ValidateSet('export', 'import')][string]$Direction)

$ErrorActionPreference = 'Stop'
$Claude = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
$Repo = Join-Path $PSScriptRoot 'claude'
# Only hand-written config. Never .credentials.json, sessions, projects, caches.
$Items = 'settings.json', 'CLAUDE.md', 'keybindings.json', 'skills', 'agents', 'commands'

if ($Direction -eq 'export') { $From, $To = $Claude, $Repo } else { $From, $To = $Repo, $Claude }

if ($Direction -eq 'import') {
    $Backup = Join-Path $Claude ("backups\sync-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
    New-Item -ItemType Directory -Force $Backup | Out-Null
    foreach ($i in $Items) { if (Test-Path (Join-Path $Claude $i)) { Copy-Item -Recurse (Join-Path $Claude $i) $Backup } }
    Write-Host "Backup: $Backup"
}

New-Item -ItemType Directory -Force $To | Out-Null
foreach ($i in $Items) {
    $src = Join-Path $From $i
    if (-not (Test-Path $src)) { continue }
    $dst = Join-Path $To $i
    if (Test-Path $src -PathType Container) {
        # copy children so an existing $dst is merged, not nested; skills/synced is claude.ai-managed
        New-Item -ItemType Directory -Force $dst | Out-Null
        Get-ChildItem $src | Where-Object Name -ne 'synced' | ForEach-Object {
            Copy-Item -Recurse -Force $_.FullName $dst
        }
    } else {
        Copy-Item -Force $src $dst
    }
    Write-Host "$Direction $i"
}

if ($Direction -eq 'import') {
    Write-Host "`nDone. Start 'claude' - it will offer to install the plugins listed in settings.json."
}
