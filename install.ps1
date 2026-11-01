# constitution installer for Windows PowerShell — works piped OR run locally.
#
# Remote:  irm https://raw.githubusercontent.com/phanijapps/constitution/main/install.ps1 | iex
# Local:   git clone https://github.com/phanijapps/constitution; cd constitution; .\install.ps1
$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/phanijapps/constitution"
$SkillName = "constitution"
$TempDir = $null

# Detect mode: local if script file exists, remote if piped
$ScriptDir = if ($MyInvocation.MyCommand -and $MyInvocation.MyCommand.Path) { Split-Path $MyInvocation.MyCommand.Path } else { $null }
$SkillDir = if ($ScriptDir -and (Test-Path (Join-Path $ScriptDir "skill"))) {
    Join-Path $ScriptDir "skill"
} else {
    $TempDir = Join-Path $env:TEMP "constitution-install-$(Get-Random)"
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git clone --depth 1 --filter=blob:none --sparse $RepoUrl $TempDir 2>$null
        Push-Location $TempDir; git sparse-checkout set skill; Pop-Location
        Join-Path $TempDir "skill"
    } else {
        $zipPath = Join-Path $env:TEMP "constitution.zip"
        Invoke-WebRequest -Uri "$RepoUrl/archive/refs/heads/main.zip" -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $TempDir -Force
        Join-Path $TempDir "constitution-main/skill"
    }
}

if (-not (Test-Path $SkillDir)) {
    Write-Error "skill/ not found"
    exit 1
}

Write-Host ""
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host "  constitution - installer" -ForegroundColor Cyan
Write-Host "  ====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Select your coding agent:"
Write-Host ""
Write-Host "  1) Claude Code     (.claude/skills/ in current dir)"
Write-Host "  2) Codex           (.agents/skills/ in current dir)"
Write-Host "  3) Cursor          (.cursor/skills/ in current dir)"
Write-Host "  4) Kiro IDE/CLI     (.kiro/skills/ in current dir)"
Write-Host "  5) GitHub Copilot  (.github/skills/ in current dir)"
Write-Host "  6) All (Claude + Codex + Cursor + Kiro)"
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
    "1" { Install-To ".claude\skills" }
    "2" { Install-To ".agents\skills" }
    "3" { Install-To ".cursor\skills" }
    "4" { Install-To ".kiro\skills" }
    "5" { Install-To ".github\skills" }
    "6" {
        Install-To ".claude\skills"
        Install-To ".agents\skills"
        Install-To ".cursor\skills"
        Install-To ".kiro\skills"
    }
    default { Write-Error "Invalid choice: $choice"; exit 1 }
}

if ($TempDir -and (Test-Path $TempDir)) {
    Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "  Done."
Write-Host ""
