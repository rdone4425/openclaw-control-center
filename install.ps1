# OpenClaw Control Center Docker 安装脚本 (Windows PowerShell)

$ErrorActionPreference = "Stop"

# 颜色定义
function Write-Color($message, $color = "White") {
    $colors = @{
        "Red" = "[31m"
        "Green" = "[32m"
        "Yellow" = "[33m"
        "Blue" = "[34m"
        "White" = "[0m"
    }
    $esc = [char]0x1B
    Write-Host "$esc$($colors[$color])$message$esc[0m" -NoNewline
    Write-Host ""
}

Write-Color "========================================" "Blue"
Write-Color "  OpenClaw Control Center 安装脚本" "Blue"
Write-Color "========================================" "Blue"
Write-Color ""

# 检查 Docker
Write-Color "检查 Docker 环境..." "Yellow"
$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
if (-not $dockerCmd) {
    Write-Color "错误: Docker 未安装" "Red"
    Write-Host "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
}

$dockerComposeCmd = Get-Command docker.compose -ErrorAction SilentlyContinue
if (-not $dockerComposeCmd) {
    $dockerComposeCmd = Get-Command docker -ErrorAction SilentlyContinue
}
Write-Color "✓ Docker 已安装" "Green"
docker --version
Write-Color ""

# 检查镜像
Write-Color "检查 Docker 镜像..." "Yellow"
$imageName = "ghcr.io/rdone4425/openclaw-control-center"
try {
    docker manifest inspect "$imageName:latest" | Out-Null
    Write-Color "✓ 镜像存在" "Green"
} catch {
    Write-Color "⚠ 镜像不存在，需要从源码构建" "Yellow"
    Write-Host "请确保当前目录有 Dockerfile"
}
Write-Color ""

# 创建必要目录
Write-Color "创建数据目录..." "Yellow"
$openclawHome = "$env:USERPROFILE\.openclaw"
$openclawWorkspace = "$openclawHome\workspace"
$codexHome = "$env:USERPROFILE\.codex"

if (-not (Test-Path $openclawHome)) {
    New-Item -ItemType Directory -Path $openclawHome -Force | Out-Null
}
if (-not (Test-Path $openclawWorkspace)) {
    New-Item -ItemType Directory -Path $openclawWorkspace -Force | Out-Null
}
if (-not (Test-Path $codexHome)) {
    New-Item -ItemType Directory -Path $codexHome -Force | Out-Null
}
Write-Color "✓ 目录创建完成" "Green"
Write-Color ""

# 启动容器
Write-Color "启动容器..." "Yellow"
docker compose up -d --build

Write-Color ""
Write-Color "========================================" "Green"
Write-Color "  安装完成！" "Green"
Write-Color "========================================" "Green"
Write-Color ""
Write-Host "访问地址:"
Write-Color "  • Control Center: http://localhost:4310" "Blue"
Write-Color "  • OpenClaw Gateway: ws://localhost:18789" "Blue"
Write-Color ""
Write-Host "常用命令:"
Write-Color "  • 查看日志: docker compose logs -f" "Yellow"
Write-Color "  • 停止: docker compose down" "Yellow"
Write-Color "  • 重启: docker compose restart" "Yellow"
Write-Color ""
