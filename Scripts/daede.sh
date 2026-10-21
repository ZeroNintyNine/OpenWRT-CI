#!/bin/bash
set -e

cd "$GITHUB_WORKSPACE"

OPENWRT_PATH="${OPENWRT_PATH:-openwrt}"
cd "$OPENWRT_PATH"

echo "===== 集成 openwrt-daede ====="

# 下载 daede 源码
git clone --depth=1 \
    https://github.com/kenzok8/openwrt-daede.git \
    /tmp/openwrt-daede

# 避免残留旧文件导致 Makefile 混用
for pkg in dae daed luci-app-daede vmlinux-btf; do
    if [ -e "package/$pkg" ]; then
        echo "ERROR: package/$pkg 已存在，请先检查是否有同名软件包"
        exit 1
    fi
done

# 复制软件包，保留 dae 与 daed 的相对目录关系
cp -a /tmp/openwrt-daede/dae package/
cp -a /tmp/openwrt-daede/daed package/
cp -a /tmp/openwrt-daede/luci-app-daede package/
cp -a /tmp/openwrt-daede/vmlinux-btf package/

echo "===== 检查软件包 ====="
test -f package/dae/Makefile
test -f package/daed/Makefile
test -f package/luci-app-daede/Makefile
test -f package/vmlinux-btf/Makefile

echo "daede 软件包已加入编译树"
