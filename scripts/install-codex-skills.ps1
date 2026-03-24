param(
    [string]$SkillsRoot = (Join-Path $PSScriptRoot "..\codex\skills-src"),
    [string]$CodexHome = $env:CODEX_HOME
)

[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

if (-not $CodexHome) {
    $CodexHome = Join-Path $HOME ".codex"
}

$resolvedSkillsRoot = Resolve-Path $SkillsRoot -ErrorAction Stop
$targetRoot = Join-Path $CodexHome "skills"

New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

$installed = @()

Get-ChildItem -Path $resolvedSkillsRoot -Directory | ForEach-Object {
    $target = Join-Path $targetRoot $_.Name
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Copy-Item -Path (Join-Path $_.FullName "*") -Destination $target -Recurse -Force
    $installed += $_.Name
}

Write-Host "已将 Codex skills 安装到 $targetRoot"
$installed | Sort-Object | ForEach-Object { Write-Host " - $_" }
