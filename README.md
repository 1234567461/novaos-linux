# NovaOS Linux — 基于上游的完整电脑 + 手机操作系统工程

一个仓库、两条产品线，全部基于成熟上游构建（**与 nova-kernel 自研仓库配套**）：

1. **桌面系统**（`desktop/`）：Debian live-build 定制发行版
   —— GNOME Wayland 桌面 + 办公/开发工具 + 品牌定制，一键出 ISO 可装机。
2. **手机系统**（`mobile/`）：postmarketOS 风格移植框架
   —— Alpine 基座 + 设备内核/设备树 + Phosh/Plasma/Sxmo 三选一 UI。

## 为什么是“完整系统”

按 `docs/REQUIREMENTS.md` 的分层清单逐项落地：
引导 → 内核 → init → 显示服务器 → 桌面环境 → 包管理 → 应用生态，
桌面与手机两条线都有真实可执行的构建产物。

## 快速开始

```sh
# 桌面 ISO
cd desktop && ./auto/build            # 产出 live-image-amd64.hybrid.iso

# 手机设备移植骨架
./mobile/scripts/init-device.sh samsung i9100 phosh
```

## 目录

```
desktop/      live-build 发行版构建（package-lists/hooks/profiles）
mobile/       postmarketOS 风格手机移植（devices/ui/scripts）
branding/     品牌资产（logo/壁纸源文件）
scripts/      总入口（build.sh / flash.sh）
docs/         桌面 / 手机 / 构建验证
```

## 文档

- `docs/DESKTOP.md` — 桌面版组成、构建、定制点
- `docs/MOBILE.md` — 手机版移植框架、外设清单
- `docs/BUILD.md` — 构建环境与验证结果

> 配套仓库：`nova-kernel` —— 从零自研的 x86 微内核（自研引导/内核/图形桌面）。
