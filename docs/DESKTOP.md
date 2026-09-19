# NovaOS Linux Desktop — 基于 Debian live-build 的完整桌面发行版

> 目标：一个"拿来即用"的完整 Linux 桌面系统 ISO，含 GNOME 桌面、
> 办公/开发/网络工具、品牌壁纸与开机配置、SSH 远程管理、防火墙默认策略。
> 构建方式参考 live-build 官方手册：
> https://live-team.pages.debian.net/live-manual/html/live-manual/example-tasks.html

## 系统组成（对应 docs/REQUIREMENTS.md 的分层）

| 层 | 实现 |
|---|---|
| 引导 | grub-efi + syslinux（live-build 自动） |
| 内核 | Debian `linux-image-amd64` |
| 基座 | Debian bookworm + systemd + GNU coreutils |
| 显示 | GNOME on Wayland（gdm3 + mutter） |
| 桌面 | GNOME 全套（文件/设置/通知/启动器）+ Dash-to-Dock |
| 语言 | en_US/zh_CN UTF-8 双 locale + Noto CJK 中文字体（hook 1100） |
| 账户 | 多用户 + sudo 日志 + auditd 审计 + root 默认锁定（hook 1005） |
| 包管理 | apt（含本地 overlay 仓库支持） |
| 应用 | LibreOffice、Firefox、GIMP、VLC、VSCode 工具链、tmux/ssh |
| 品牌 | /etc/motd、主机名 novaos、默认壁纸（dconf 写入） |

## 两种版本：图形版 / 命令行版

- **图形版（默认）**：`novaos-desktop.list.chroot`，GNOME 完整桌面
- **命令行版**：`profiles/cli/novaos-cli.list.chroot`，无桌面环境，
  面向服务器/远程管理（SSH + 开发工具链）
- 构建时二选一：`cp profiles/cli/novaos-cli.list.chroot config/package-lists/novaos-desktop.list.chroot`
- 云端一键构建（免本机 root）：GitHub Actions 工作流 `.github/workflows/build-iso.yml`，
  在仓库 Actions 页点 Run workflow 即可下载 ISO

## 一键安装器

`scripts/install.sh` 在 live ISO 里运行，交互式完成：
版本（gnome/xfce/cli）→ 语言（zh/en）→ 键盘布局（us/gb/de/fr/jp）→
主机名 → 管理员用户名 → 目标磁盘（自动分区 ext4 + 可选 swap）→
rsync 根文件系统 → 写 fstab/locale/keyboard → 建用户（强制首登改密）→
装 GRUB。

## 目录

```
auto/            live-build 自动化脚本（config/clean/build）
config/
  package-lists/ 预装软件清单（novaos-desktop.list.chroot）
  hooks/         定制 hook：品牌(0990)、账户审计(1005)、服务防火墙(1000)、locale(1100)
  archives/      本地 overlay apt 仓库源
  includes.chroot/ 未来放置壁纸等文件的落盘目录
profiles/        可选构建 profile（gnome/xfce/cli）
```

## 构建

```sh
sudo apt install live-build debian-archive-keyring  # 构建机一次
cd desktop
./auto/build
# 产出 live-image-amd64.hybrid.iso
```

## 验证

- 虚拟机（QEMU/KVM）挂载 ISO 启动，检查：GNOME 桌面、默认壁纸、
  `ssh novaos@<ip>` 可登录、`ufw status` 显示 22/tcp allow、
  中文显示正常（Noto CJK）、`sudo aureport -au` 有审计输出
- 物理机：`sudo dd if=...iso of=/dev/sdX bs=4M status=progress`（见 scripts/flash.sh）

## 定制点

- 加软件：编辑 `config/package-lists/novaos-desktop.list.chroot`
- 改壁纸：放图到 `config/includes.chroot/usr/share/novaos/`，hook 自动安装
- 换 profile：`lb config --packages-list novaos-xfce` 或改 auto/config
- 本地软件仓库：`config/archives/novaos.list.chroot` 指向 reprepro 仓库
