[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot

try {
    $conceptExists = Test-Path "design/gdd/game-concept.md"
    $systemsIndexExists = Test-Path "design/gdd/systems-index.md"
    $systemDocCount = @(Get-ChildItem "design/systems" -File -Filter *.md -ErrorAction SilentlyContinue).Count
    $luauCount = @(Get-ChildItem "src" -Recurse -File -Include *.lua,*.luau -ErrorAction SilentlyContinue).Count
    $playtestCount = @(Get-ChildItem "tests/playtest" -File -Filter *.md -ErrorAction SilentlyContinue).Count
    $isGitRepo = Test-Path ".git"

    Write-Host "仓库根目录: $repoRoot"
    Write-Host "是否已初始化 Git: $isGitRepo"
    Write-Host "是否存在概念文档: $conceptExists"
    Write-Host "是否存在系统总表: $systemsIndexExists"
    Write-Host "系统设计文档数量: $systemDocCount"
    Write-Host "Luau 脚本数量: $luauCount"
    Write-Host "Playtest 报告数量: $playtestCount"

    if (Test-Path "production/session-state/active.md") {
        Write-Host ""
        Write-Host "会话状态预览:"
        Get-Content "production/session-state/active.md" -TotalCount 20
    }
}
finally {
    Pop-Location
}
