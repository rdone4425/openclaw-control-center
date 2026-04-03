# OpenClaw Control Center Docker 安装脚本 (Windows PowerShell)

$ErrorActionPreference = "Stop"

# 配置
$IMAGE_NAME = "ghcr.io/rdone4425/openclaw-control-center"
$CONTAINER_NAME = "openclaw-control-center"
$PORT_UI = 4310

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
Write-Color "✓ Docker 已安装" "Green"
docker --version
Write-Color ""

# 拉取镜像
Write-Color "拉取 Docker 镜像..." "Yellow"
Write-Host "镜像: $IMAGE_NAME"
docker pull $IMAGE_NAME:latest
Write-Color "✓ 镜像拉取完成" "Green"
Write-Color ""

# 停止并删除旧容器
Write-Color "清理旧容器..." "Yellow"
docker rm -f $CONTAINER_NAME 2>$null
Write-Color ""

# 启动容器
Write-Color "启动容器..." "Yellow"
docker run -d `
    --name $CONTAINER_NAME `
    -p ${PORT_UI}:${PORT_UI} `
    -e NODE_ENV=production `
    -e UI_MODE=true `
    -e UI_PORT=$PORT_UI `
    -e UI_BIND_ADDRESS=0.0.0.0 `
    -e READONLY_MODE=true `
    -e LOCAL_TOKEN_AUTH_REQUIRED=true `
    -e LOCAL_API_TOKEN=change-this-token `
    -e GATEWAY_URL=host.docker.internal:18789 `
    -e OPENCLAW_HOME=/root/.openclaw `
    -e OPENCLAW_CONFIG_PATH=/root/.openclaw/openclaw.json `
    -e OPENCLAW_WORKSPACE_ROOT=/root/.openclaw/workspace `
    -e CODEX_HOME=/root/.codex `
    --add-host=host.docker.internal:host-gateway `
    $IMAGE_NAME:latest

Write-Color ""
Write-Color "========================================" "Green"
Write-Color "  安装完成！" "Green"
Write-Color "========================================" "Green"
Write-Color ""
Write-Host "访问地址:"
Write-Color "  • Control Center: http://localhost:${PORT_UI}" "Blue"
Write-Color ""
Write-Host "注意: OpenClaw Gateway 端口 18789 需要在宿主机手动启动"
Write-Color ""
Write-Host "常用命令:"
Write-Color "  • 查看日志: docker logs -f ${CONTAINER_NAME}" "Yellow"
Write-Color "  • 停止: docker stop ${CONTAINER_NAME}" "Yellow"
Write-Color "  • 启动: docker start ${CONTAINER_NAME}" "Yellow"
Write-Color "  • 删除: docker rm -f ${CONTAINER_NAME}" "Yellow"
Write-Color ""
