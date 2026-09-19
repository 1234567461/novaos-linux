# NovaOS Linux — 基于上游的完整电脑 + 手机操作系统工程

一个仓库、两条产品线，全部基于成熟上游构建（**与 nova-kernel 自研仓库配套**）：

1. **桌面系统**（`desktop/`）：Debian live-build 定制发行版
   —— **图形版（GNOME Wayland）与命令行版双版本** + 一键安装器，
   中文/英文双语言 + Noto CJK 中文字体 + 多键盘布局，多用户权限审计。
2. **手机系统**（`mobile/`）：postmarketOS 风格移植框架
   —— Alpine 基座 + 设备内核/设备树 + Phosh/Plasma/Sxmo 三选一 UI。

## 为什么是“完整系统”

按 `docs/REQUIREMENTS.md` 的分层清单逐项落地：
引导 → 内核 → init → 显示服务器 → 桌面环境 → 包管理 → 应用生态，
桌面与手机两条线都有真实可执行的构建产物。

## 如何克隆这个仓库（小白版）

git 就是把整个仓库复制到你电脑上的工具。三分钟搞定：

**第 1 步：安装 git**
- Windows：去 https://git-scm.com/download/win 下载安装（一路下一步）
- macOS：打开“终端”，输入 `xcode-select --install`
- Linux（Ubuntu/Debian）：终端输入 `sudo apt install -y git`

**第 2 步：复制仓库地址**
本仓库地址：`https://github.com/1234567461/novaos-linux.git`

**第 3 步：克隆**
打开终端 / 命令行，输入：

```sh
git clone https://github.com/1234567461/novaos-linux.git
cd novaos-linux
```

以后更新：进文件夹输入 `git pull`。
**只看不下载**：浏览器打开 https://github.com/1234567461/novaos-linux ，点 `<> Code` → Download ZIP。

## 快速开始

```sh
# 云端构建 ISO（推荐，免本机 root）：
#   仓库 → Actions → build-iso → Run workflow → 下载 ISO

# 或本机构建
cd desktop && ./auto/build            # 产出 live-image-amd64.hybrid.iso

# 装机（live ISO 内运行，交互式）
sudo ./scripts/install.sh

# 手机设备移植骨架
./mobile/scripts/init-device.sh samsung i9100 phosh
```

## 目录

```
desktop/      live-build 发行版构建（package-lists/hooks/profiles）
mobile/       postmarketOS 风格手机移植（devices/ui/scripts）
branding/     品牌资产（logo/壁纸源文件）
scripts/      总入口（build.sh / flash.sh / install.sh 一键安装器）
docs/         桌面 / 手机 / 账户审计 / 构建验证
.github/      GitHub Actions 云端构建 ISO
```

## 文档

- `docs/DESKTOP.md` — 桌面版组成（图形/命令行双版本）、构建、安装器
- `docs/MOBILE.md` — 手机版移植框架、外设清单
- `docs/ACCOUNTS.md` — 多用户、权限管控、审计策略（“防止乱改，包括管理员”）
- `docs/BUILD.md` — 云端/本机构建与验证

> 配套仓库：`nova-kernel` —— 从零自研的 x86 微内核（自研引导/内核/ring3
> 用户态/FAT12/图形桌面）。
