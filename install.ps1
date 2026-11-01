# constitution installer for Windows PowerShell
$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillDir = Join-Path $RepoDir "skill"
$SkillName = "constitution"

if (-not (Test-Path $SkillDir)) {
    Write-Error "skill/ not found in $RepoDir"
    exit 1
}

Write-Host ""
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host "  constitution - installer" -ForegroundColor Cyan
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Select your coding agent:"
Write-Host ""
Write-Host "  1) Claude Code     (~/.claude/skills/)"
Write-Host "  2) Codex           (~/.agents/skills/)"
Write-Host "  3) Cursor          (~/.cursor/skills/)"
Write-Host "  4) GitHub Copilot  (.github/skills/ in current repo)"
Write-Host "  5) Generic         (~/.agents/skills/ - shared with Codex)"
Write-Host "  6) All (Claude + Codex + Cursor)"
Write-Host ""
$choice = Read-Host "  Enter number [1-6]"
Write-Host ""

function Install-To($dest) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    $target = Join-Path $dest $SkillName
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Copy-Item -Recurse $SkillDir $target
    Write-Host "  OK installed to $dest\$SkillName" -ForegroundColor Green
}

switch ($choice) {
    "1" { Install-To "$env:USERPROFILE\.claude\skills" }
    "2" { Install-To "$env:USERPROFILE\.agents\skills" }
    "3" { Install-To "$env:USERPROFILE\.cursor\skills" }
    "4" {
        $repo = Read-Host "  Path to repo root (default: current dir)"
        if ([string]::IsNullOrWhiteSpace($repo)) { $repo = (Get-Location).Path }
        Install-To (Join-Path $repo ".github\agents")
    }
    "5" { Install-To "$env:USERPROFILE\.agents\skills" }
    "6" {
        Install-To "$env:USERPROFILE\.claude\skills"
        Install-To "$env:USERPROFILE\.agents\skills"
        Install-To "$env:USERPROFILE\.cursor\skills"
    }
    default { Write-Error "Invalid choice: $choice"; exit 1 }
}

Write-Host ""
Write-Host "  Done. Verify with:"
Write-Host "    python3 ~\.claude\skills\constitution\scripts\scaffold.py --help"
Write-Host ""
