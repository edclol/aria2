# Aria2-Pro Docker 一键部署指南

本项目基于 [p3terx/aria2-pro](https://github.com/P3TERX/Aria2-Pro-Docker) 镜像，集成 Aria2 下载器与 AriaNg 前端，支持自动更新 BT Tracker 列表，适合离线下载、PT、BT 等多种场景。

---

## 目录结构

```
aria2-config/      # Aria2 配置与会话文件目录
aria2-downloads/   # 下载文件保存目录
compose.yml        # Docker Compose 配置文件
get_bt.sh          # 一键更新 BT Tracker 脚本
README.md          # 项目说明
```

---

## 快速启动

1. **准备环境**

   - 安装 [Docker](https://docs.docker.com/get-docker/) 和 [Docker Compose](https://docs.docker.com/compose/install/)，建议使用 Linux 服务器。

2. **启动服务**

   ```sh
   cd /opt/aria2/
   sudo docker compose up -d
   ```

3. **访问 AriaNg 前端**

   浏览器访问 `http://<你的服务器IP>:6880`，即可使用 AriaNg 管理 Aria2。

4. **更新 BT Tracker 列表**

   ```sh
   bash get_bt.sh
   ```

---

## 配置说明

- **配置文件**：位于 `aria2-config/aria2.conf`，可根据需要自定义参数。
- **下载目录**：所有下载文件默认保存到 `aria2-downloads/` 目录。
- **网络模式**：默认使用 host 网络模式，端口映射见 `compose.yml`。如需自定义端口，可切换为 bridge 模式并取消注释端口映射部分。
- **重要参数**：如 `RPC_SECRET`（RPC 密钥），需与 AriaNg 前端配置一致。

---

## 自动更新 BT Tracker

运行 `get_bt.sh` 脚本可自动获取最新 BT Tracker 并重启 Aria2 服务，提升 BT/PT 下载速度和连接数。

```sh
bash get_bt.sh
```

脚本会自动合并多个来源的 Tracker，并写入配置文件，无需手动维护。

---

## 常用环境变量（compose.yml）

- `PUID` / `PGID`：容器内运行用户和用户组 ID，建议与主机用户一致，避免权限问题。
- `UMASK_SET`：文件权限掩码，默认 022。
- `RPC_SECRET`：Aria2 RPC 密钥。
- `RPC_PORT`：RPC 端口，默认 6800。
- `LISTEN_PORT`：BT/PT 监听端口，默认 6888。
- `DISK_CACHE`：磁盘缓存设置，提升性能。
- `TZ`：时区设置，默认 Asia/Shanghai。
- 其他环境变量详见 `compose.yml` 文件注释。

---

## 常见问题

- **Aria2 配置未生效？**  
  请确认修改配置后已重启容器，或运行 `get_bt.sh` 自动重载配置。
- **AriaNg 无法连接？**  
  检查 RPC 密钥、端口设置及网络连通性。
- **下载权限问题？**  
  请确保 `aria2-downloads/` 和 `aria2-config/` 目录权限正确，或调整 `PUID`/`PGID`。

---

## 参考项目

- [p3terx/aria2-pro](https://github.com/P3TERX/Aria2-Pro-Docker)
- [AriaNg](https://github.com/mayswind/AriaNg)

---

如有问题欢迎提 Issue

