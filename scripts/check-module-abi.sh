#!/bin/bash
# 校验内核的模块 ABI 标记和原厂内核一致。
#
# 原厂 munch 内核（4.19.157）的模块标记：
#   CONFIG_MODVERSIONS=y / CONFIG_MODULE_UNLOAD=y / CONFIG_PREEMPT=y
#   vermagic 尾部 = "SMP preempt mod_unload modversions aarch64"
#
# 只要这里有一项和原厂不一样，vendor 分区里的 .ko 在加载时就会报
#   "<mod>: version magic '4.19.157-perf-... modversions aarch64' should be
#    '... aarch64'"
# 直接 ENOEXEC，模块一个都进不去。
#
# 用法: bash check-module-abi.sh <resolved .config> [vmlinux]
set -eu

if [ "$#" -lt 1 ] || [ ! -r "$1" ]; then
    echo "Usage: bash $0 <resolved .config> [vmlinux]" >&2
    exit 2
fi

config_file=$1
vmlinux=${2:-}
fail=0

require_y() {
    if ! grep -qx "CONFIG_$1=y" "$config_file"; then
        echo "module-abi: CONFIG_$1=y 缺失 — 原厂 .ko 会因 version magic 不匹配加载失败" >&2
        fail=$((fail + 1))
    fi
}

require_n() {
    if grep -qx "CONFIG_$1=y" "$config_file"; then
        echo "module-abi: CONFIG_$1 必须是关闭状态" >&2
        fail=$((fail + 1))
    fi
}

require_y MODULES
require_y MODULE_UNLOAD
require_y MODVERSIONS
require_y PREEMPT
require_n MODULE_SIG_FORCE

if [ -n "$vmlinux" ] && [ -f "$vmlinux" ]; then
    expected="SMP preempt mod_unload modversions aarch64"
    if ! grep -aq "$expected" "$vmlinux"; then
        echo "module-abi: vmlinux 里没有找到 vermagic 尾部 \"$expected\"" >&2
        fail=$((fail + 1))
    fi
fi

if [ "$fail" -ne 0 ]; then
    echo "MODULE_ABI_FAIL" >&2
    exit 1
fi

echo "module-abi: OK"
