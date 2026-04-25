# Pushes a *remote* commit that is no longer on main (e.g. pre force-push) to a
# dedicated branch on GitHub so the old version stays available alongside current main.
#
# You need the FULL 40-character commit hash of the *previous* main tip. Find it from:
#   - Another clone that was not updated after a force push:  git log -1
#   - GitHub email notification for the force push (link may list the old commit)
#   - Any local reflog:  git reflog show main
#
# Usage (PowerShell, from project root):
#   .\scripts\preserve-legacy-branch.ps1 -FullCommitSha "abcdef0123...40chars"
#
# Optional:
#   -BranchName "archive/legacy-pre-2026-04-25"
#
param(
    [Parameter(Mandatory = $true)]
    [string] $FullCommitSha,
    [string] $BranchName = "archive/legacy-pre-full-project"
)

$ErrorActionPreference = "Stop"
$portable = Join-Path $env:USERPROFILE ".mingit-portable\cmd\git.exe"
$git = if (Test-Path $portable) { $portable } else { "git" }

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $repoRoot

if ($FullCommitSha -notmatch '^[0-9a-fA-F]{40}$') {
    Write-Error "Please pass the full 40-character commit SHA. Short SHAs are not supported here."
    exit 1
}

Write-Host "Fetching $FullCommitSha into local branch $BranchName ..."
& $git fetch origin "$FullCommitSha:refs/heads/$BranchName"
if ($LASTEXITCODE -ne 0) {
    Write-Error "fetch failed. The commit may be gone from the server, or the SHA is wrong, or the network is blocked."
    exit 1
}

Write-Host "Pushing $BranchName to origin ..."
& $git push -u origin $BranchName
if ($LASTEXITCODE -ne 0) { exit 1 }
Write-Host "Done. Open GitHub: Branches -> $BranchName to browse the old version."
