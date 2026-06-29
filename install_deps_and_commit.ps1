## install_deps_and_commit.ps1
# ------------------------------------------------------------
# 自动在本机安装 U‑Claw Portable 所需的 npm 依赖、
# 把 node_modules 强制加入 Git 并一次性提交、
# 打上版本 tag（用于 GitHub Release）
# ------------------------------------------------------------
# 1. 进入项目根目录（脚本所在目录）
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

# 2. 确保 .gitignore 不再忽略 node_modules
if (Test-Path ".gitignore") {
    (Get-Content ".gitignore") |
        Where-Object { $_ -notmatch '^[#\s]*node_modules/?' } |
        Set-Content ".gitignore"
}

# 3. 安装 runtime 依赖 (app\runtime\node-win-x64)
Write-Host "Installing runtime dependencies..."
Push-Location "app\runtime\node-win-x64"
if (Test-Path "package-lock.json") { npm ci } else { npm install }
Pop-Location

# 4. 安装 core 依赖 (app\core)
Write-Host "Installing core dependencies..."
Push-Location "app\core"
if (Test-Path "package-lock.json") { npm ci } else { npm install }
Pop-Location

# 5. 强制把 node_modules 加入 Git（两个位置）
Write-Host "Adding node_modules to Git (force)..."
git add -f "app\runtime\node-win-x64\node_modules"
git add -f "app\core\node_modules"

# 6. 提交更改
$CommitMsg = "Add full node_modules for portable U‑Claw $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m $CommitMsg

# 7. 推送到远端
git push

# 8. 打 tag 并推送（用于 Release）
$Tag = "v$(Get-Date -UFormat "%Y%m%d%H%M")"
git tag $Tag
git push origin $Tag

Write-Host "\n✅ 完成！已提交 node_modules 并创建 tag $Tag"
