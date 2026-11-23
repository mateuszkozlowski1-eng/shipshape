<#
.SYNOPSIS
  Shipshape installer for Windows (PowerShell 5.1 or 7).
.EXAMPLE
  .\install.ps1 C:\code\my-app
  .\install.ps1 C:\code\my-app -NoHook
  .\install.ps1 C:\code\my-app -UpdateSkills
#>
param(
    [string]$Target = '.',
    [switch]$NoHook,       # don't install the secret-scan pre-commit hook
    [switch]$UpdateSkills  # replace the skill files with this version's (AGENTS.md and DECISIONS.md stay)
)
$ErrorActionPreference = 'Stop'

$Kit = $PSScriptRoot
if (-not (Test-Path -LiteralPath $Target -PathType Container)) { throw "No such folder: $Target" }
$Target = (Resolve-Path -LiteralPath $Target).Path.TrimEnd('\')
if ($Target -eq $Kit.TrimEnd('\')) { throw "That's the Shipshape folder itself. Point me at your project folder." }

Write-Host "Installing Shipshape into $Target"
$script:skipped = $false

function Copy-ShipshapeFile([string]$Source, [string]$Relative, [bool]$Overwrite) {
    $dst = Join-Path $Target $Relative
    if (Test-Path -LiteralPath $dst) {
        if ($Overwrite) {
            Copy-Item -LiteralPath $Source -Destination $dst -Force
            Write-Host "  updated  $Relative"
        } else {
            Write-Host "  kept     $Relative (already there)"
            $script:skipped = $true
        }
    } else {
        New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
        Copy-Item -LiteralPath $Source -Destination $dst
        Write-Host "  added    $Relative"
    }
}

foreach ($f in 'AGENTS.md', 'CLAUDE.md', 'DECISIONS.md') {
    Copy-ShipshapeFile (Join-Path $Kit "kit\$f") $f $false
}

$kitRoot = Join-Path $Kit 'kit'
Get-ChildItem -LiteralPath (Join-Path $kitRoot '.agents') -Recurse -File -Force | Sort-Object FullName | ForEach-Object {
    $rel = $_.FullName.Substring($kitRoot.Length + 1)
    Copy-ShipshapeFile $_.FullName $rel ([bool]$UpdateSkills)
}

# Keep env files out of git.
$gi = Join-Path $Target '.gitignore'
$covered = (Test-Path -LiteralPath $gi) -and
    (Select-String -LiteralPath $gi -Pattern '^/?\.env(\*|\.\*|\.local)?$' -Quiet)
if (-not $covered) {
    $prefix = ''
    if ((Test-Path -LiteralPath $gi) -and (Get-Item -LiteralPath $gi).Length -gt 0) {
        $raw = [IO.File]::ReadAllText($gi)
        if (-not $raw.EndsWith("`n")) { $prefix = "`n" }
    }
    [IO.File]::AppendAllText($gi, "$prefix# Secrets (added by Shipshape)`n.env`n.env.*`n!.env.example`n")
    Write-Host "  updated  .gitignore (env files)"
}

# Secret-scan pre-commit hook. Git for Windows runs hooks with its own sh, so the same script works.
if (-not $NoHook) {
    $git = Get-Command git -ErrorAction SilentlyContinue
    $isRepo = $false
    if ($git) {
        & git -C $Target rev-parse --git-dir 2>$null | Out-Null
        $isRepo = ($LASTEXITCODE -eq 0)
    }
    if (-not $isRepo) {
        Write-Host "  no hook  not a git repository yet (run 'git init', then install again for the hook)"
    } else {
        $hooksPath = (& git -C $Target config core.hooksPath 2>$null)
        if ($hooksPath) {
            Write-Host "  no hook  this repo uses its own hooks folder ($hooksPath, e.g. husky)."
            Write-Host "           Call $Kit\hooks\pre-commit from your pre-commit hook to add the secret scan."
        } else {
            $gitDir = (& git -C $Target rev-parse --absolute-git-dir).Trim()
            $hooksDir = Join-Path $gitDir 'hooks'
            New-Item -ItemType Directory -Force -Path $hooksDir | Out-Null
            $dst = Join-Path $hooksDir 'pre-commit'
            if ((Test-Path -LiteralPath $dst) -and -not (Select-String -LiteralPath $dst -Pattern 'Shipshape secret scan' -Quiet)) {
                Write-Host "  no hook  a pre-commit hook already exists; add a call to $Kit\hooks\pre-commit to it"
            } else {
                # Copy bytes as they are: the hook must keep LF line endings.
                [IO.File]::WriteAllBytes($dst, [IO.File]::ReadAllBytes((Join-Path $Kit 'hooks\pre-commit')))
                Write-Host "  added    pre-commit hook (secret scan)"
            }
        }
    }
}

if ($script:skipped) {
    Write-Host ""
    Write-Host "Some files were already there and were kept. If you had your own AGENTS.md or CLAUDE.md,"
    Write-Host "merge what you want from $Kit\kit\AGENTS.md, and make sure CLAUDE.md contains the line @AGENTS.md."
}

Write-Host ""
Write-Host "Done. Next: open your AI agent in the project and say:"
Write-Host ""
Write-Host "    Read AGENTS.md and run the setup skill."
Write-Host ""
