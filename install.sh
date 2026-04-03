#!/bin/bash
# OpenClaw Control Center Docker 安装脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
IMAGE_NAME="ghcr.io/rdone4425/openclaw-control-center"
CONTAINER_NAME="openclaw-control-center"
PORT_UI=4310
PORT_GATEWAY=18789

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

if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}错误: Docker Compose 未安装${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker 已安装${NC}"
docker --version
docker compose version
echo

# 检查镜像是否可用
echo -e "${YELLOW}检查 Docker 镜像...${NC}"
if docker manifest inspect "${IMAGE_NAME}:latest" &> /dev/null; then
    echo -e "${GREEN}✓ 镜像存在${NC}"
else
    echo -e "${YELLOW}⚠ 镜像不存在，将从源码构建${NC}"
    echo "请确保当前目录有 Dockerfile"
fi
echo

# 创建必要目录
echo -e "${YELLOW}创建数据目录...${NC}"
mkdir -p ~/.openclaw
mkdir -p ~/.openclaw/workspace
mkdir -p ~/.codex
echo -e "${GREEN}✓ 目录创建完成${NC}"
echo

# 启动容器
echo -e "${YELLOW}启动容器...${NC}"
docker compose up -d --build

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
echo -e "  • 查看日志: ${YELLOW}docker compose logs -f${NC}"
echo -e "  • 停止: ${YELLOW}docker compose down${NC}"
echo -e "  • 重启: ${YELLOW}docker compose restart${NC}"
echo
