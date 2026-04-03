#!/bin/bash
# OpenClaw Control Center Docker 安装脚本

set -e

# 配置
IMAGE_NAME="ghcr.io/rdone4425/openclaw-control-center"
CONTAINER_NAME="openclaw-control-center"
PORT_UI=4310
PORT_GATEWAY=18789

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  OpenClaw Control Center 安装脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# 检查 Docker
echo -e "${YELLOW}检查 Docker 环境...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: Docker 未安装${NC}"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

echo -e "${GREEN}✓ Docker 已安装${NC}"
docker --version
echo

# 拉取镜像
echo -e "${YELLOW}拉取 Docker 镜像...${NC}"
echo "镜像: $IMAGE_NAME"
docker pull ${IMAGE_NAME}:latest
echo -e "${GREEN}✓ 镜像拉取完成${NC}"
echo

# 创建必要目录
echo -e "${YELLOW}创建数据目录...${NC}"
mkdir -p ~/.openclaw
mkdir -p ~/.openclaw/workspace
mkdir -p ~/.codex
echo -e "${GREEN}✓ 目录创建完成${NC}"
echo

# 停止并删除旧容器
echo -e "${YELLOW}清理旧容器...${NC}"
docker rm -f ${CONTAINER_NAME} 2>/dev/null || true
echo

# 启动容器
echo -e "${YELLOW}启动容器...${NC}"
docker run -d \
    --name ${CONTAINER_NAME} \
    -p ${PORT_UI}:${PORT_UI} \
    -p ${PORT_GATEWAY}:${PORT_GATEWAY} \
    -e NODE_ENV=production \
    -e UI_MODE=true \
    -e UI_PORT=${PORT_UI} \
    -e UI_BIND_ADDRESS=0.0.0.0 \
    -e READONLY_MODE=true \
    -e LOCAL_TOKEN_AUTH_REQUIRED=true \
    -e LOCAL_API_TOKEN=change-this-token \
    -e GATEWAY_URL=host.docker.internal:18789 \
    -e OPENCLAW_HOME=/data/.openclaw \
    -e OPENCLAW_CONFIG_PATH=/data/.openclaw/openclaw.json \
    -e OPENCLAW_WORKSPACE_ROOT=/data/workspace \
    -e CODEX_HOME=/data/.codex \
    -v openclaw-home:/data/.openclaw \
    -v openclaw-workspace:/data/workspace \
    -v codex-home:/data/.codex \
    --add-host=host.docker.internal:host-gateway \
    ${IMAGE_NAME}:latest

echo
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo
echo -e "访问地址:"
echo -e "  • Control Center: ${BLUE}http://localhost:${PORT_UI}${NC}"
echo -e "  • OpenClaw Gateway: ${BLUE}ws://localhost:${PORT_GATEWAY}${NC}"
echo
echo -e "常用命令:"
echo -e "  • 查看日志: ${YELLOW}docker logs -f ${CONTAINER_NAME}${NC}"
echo -e "  • 停止: ${YELLOW}docker stop ${CONTAINER_NAME}${NC}"
echo -e "  • 启动: ${YELLOW}docker start ${CONTAINER_NAME}${NC}"
echo -e "  • 删除: ${YELLOW}docker rm -f ${CONTAINER_NAME}${NC}"
echo
