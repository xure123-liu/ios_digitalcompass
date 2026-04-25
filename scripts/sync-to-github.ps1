# Sync local project to GitHub. Requires: Git for Windows (https://git-scm.com/download/win)
# Usage: in PowerShell, run:  .\scripts\sync-to-github.ps1
# Optional:  .\scripts\sync-to-github.ps1 "your commit message"

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $repoRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: 'git' not found. Install Git for Windows, then reopen the terminal."
    exit 1
}

$remote = "https://github.com/xure123-liu/ios_digitalcompass.git"
$msg = $args[0]
if ([string]::IsNullOrWhiteSpace($msg)) {
    $msg = "chore: sync project"
}

if (-not (Test-Path (Join-Path $repoRoot ".git"))) {
    git init
}

$remotes = @(git remote 2>$null)
if ($remotes -notcontains "origin") {
    git remote add origin $remote
} else {
    $url = git remote get-url origin 2>$null
    if ($url -and $url -ne $remote) {
        Write-Host "Remote 'origin' is: $url (expected: $remote). Update with: git remote set-url origin $remote"
    }
}

git add -A
$status = git status --porcelain
if ([string]::IsNullOrEmpty($status)) {
    Write-Host "Nothing to commit (working tree clean)."
} else {
    git commit -m $msg
}

$branch = git rev-parse --abbrev-ref HEAD 2>$null
if ($branch -ne "main") {
    git branch -M main 2>$null
}

Write-Host "Pushing to origin main..."
git push -u origin main
