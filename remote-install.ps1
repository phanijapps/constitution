# Remote installer for Windows PowerShell
# Usage: irm https://raw.githubusercontent.com/phanijapps/constitution/main/remote-install.ps1 | iex
$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/phanijapps/constitution"
$TempDir = Join-Path $env:TEMP "constitution-install-$(Get-Random)"
$SkillName = "constitution"

Write-Host ""
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host "  constitution - remote installer" -ForegroundColor Cyan
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host ""

if (Get-Command git -ErrorAction SilentlyContinue) {
    git clone --depth 1 --filter=blob:none --sparse $RepoUrl $TempDir 2>$null
    Push-Location $TempDir; git sparse-checkout set skill; Pop-Location
} else {
    # Fallback: download zip
    $zipUrl = "$RepoUrl/archive/refs/heads/main.zip"
    $zipPath = Join-Path $env:TEMP "constitution.zip"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $TempDir -Force
    $TempDir = Join-Path $TempDir "constitution-main"
}

$SkillDir = Join-Path $TempDir "skill"
if (-not (Test-Path $SkillDir)) {
    Write-Error "Failed to download skill"
    exit 1
}

Write-Host "  Select your coding agent:"
Write-Host ""
Write-Host "  1) Claude Code     (~/.claude/skills/)"
Write-Host "  2) Codex           (~/.agents/skills/)"
Write-Host "  3) Cursor          (~/.cursor/skills/)"
Write-Host "  4) GitHub Copilot  (.github/skills/ in current repo)"
Write-Host "  5) All (Claude + Codex + Cursor)"
Write-Host ""
$choice = Read-Host "  Enter number [1-5]"
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
        Install-To (Join-Path $repo ".github\skills")
    }
    "5" {
        Install-To "$env:USERPROFILE\.claude\skills"
        Install-To "$env:USERPROFILE\.agents\skills"
        Install-To "$env:USERPROFILE\.cursor\skills"
    }
    default { Write-Error "Invalid choice: $choice"; exit 1 }
}

if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue }

Write-Host ""
Write-Host "  Done."
Write-Host ""
