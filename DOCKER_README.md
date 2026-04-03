# OpenClaw Control Center Docker 版

## 快速启动

```powershell
cd E:\app\openclaw-control-center
docker-compose up --build -d
```

## 访问地址

| 服务 | 地址 |
|------|------|
| Control Center UI | http://127.0.0.1:4310 |
| OpenClaw Gateway | ws://127.0.0.1:18789 |

## 配置

修改 `docker-compose.yml` 中的 `LOCAL_API_TOKEN` 为安全令牌

## 常用命令

```powershell
# 启动
docker-compose up --build -d

# 查看日志
docker-compose logs -f control-center

# 停止
docker-compose down

# 重启
docker-compose restart
```

## 数据持久化

- `openclaw-home`: OpenClaw 主目录 (~/.openclaw)
- `openclaw-workspace`: 工作区文件
- `codex-home`: Codex 目录 (~/.codex)
- `control-center-runtime`: 运行时数据
