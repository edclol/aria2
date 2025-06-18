#!/bin/bash

set -euo pipefail

# 可选：设置代理（如有需要，取消注释）
# export http_proxy="http://127.0.0.1:7890"
# export https_proxy="http://127.0.0.1:7890"

# 检查代理环境变量
echo "当前代理环境变量："
env | grep -i proxy || echo "未设置代理"

# 配置文件路径
conf_path="/opt/aria2/aria2-config/aria2.conf"

# 检查配置文件是否存在
if [[ ! -f "$conf_path" ]]; then
    echo "配置文件 $conf_path 不存在，退出。"
    exit 1
fi

# 获取两个来源的 BT Tracker 列表
a_bt=$(curl -fsSL "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt" | sed '/^$/d' | tr '\n' ',')
b_bt=$(curl -fsSL "https://api.yaozuopan.top:88/composite?key=bt&auth=3cae9a3a53f1daef137126648a535ab7" | tr -d '\n' | sed 's/<br \/>/,/g')

# 合并并去除多余逗号
new_bt=$(echo "${a_bt},${b_bt}" | sed 's/,,*/,/g; s/^,//; s/,$//')

if [[ -z "$new_bt" ]]; then
    echo "获取 BT Tracker 列表失败，退出。"
    exit 1
fi

echo "最新 BT Tracker 列表："
echo "$new_bt"

# 替换或添加 bt-tracker 行
if grep -q "^bt-tracker=" "$conf_path"; then
    sudo sed -i "s|^bt-tracker=.*|bt-tracker=${new_bt}|" "$conf_path"
else
    echo "bt-tracker=${new_bt}" | sudo tee -a "$conf_path" > /dev/null
fi

# 检查替换是否成功
if grep -q "^bt-tracker=" "$conf_path"; then
    echo "BT Tracker 更新成功。"
else
    echo "BT Tracker 更新失败。"
    exit 1
fi

# 重启 aria2 服务以应用更改
cd /opt/aria2/ || { echo "目录不存在，退出。"; exit 1; }
if sudo docker compose restart; then
    echo "Aria2 服务重启成功。"
else
    echo "Aria2 服务重启失败。"
    exit 1
fi