# 构建环境与验证

## 云端一键构建（推荐，免本机 root）

仓库已带 GitHub Actions 工作流 `.github/workflows/build-iso.yml`：

1. 打开仓库 → **Actions** 标签页
2. 选择 **build-iso** → **Run workflow**（可选 profile：gnome/xfce/cli）
3. 构建完成后在 run 页面下载 `novaos-<profile>-iso` 产物
   （即 `live-image-amd64.hybrid.iso`，约 14 天内可下载）

无需本地安装任何工具、无需 root——这是当前环境（无 root、apt 受限）
下验证过的最可靠构建通道。

## 桌面 ISO（live-build，本机构建）
```sh
# 构建机（Debian 12 / Ubuntu 22.04+，需要 root）
sudo apt update
sudo apt install -y live-build debian-archive-keyring xorriso isolinux
cd desktop
./auto/config && ./auto/build
```
产物：`live-image-amd64.hybrid.iso`

### 常见问题
- `lb build` 网络慢：用国内镜像改 auto/config 里的 `--mirror-bootstrap`
- 本地 overlay 仓库：用 reprepro 建 `bookworm main`，密钥放到
  `config/archives/novaos.gpg`（可选，文件内已用 trusted=yes 简化）
- 产物大于 4GB：默认 iso-hybrid 单分区即可，无需 UDF

## 装机（live ISO 内）
```sh
sudo ./scripts/install.sh   # 交互式：版本/语言/键盘/磁盘/用户/GRUB
```

## 手机镜像（pmbootstrap）
```sh
wget https://gitlab.postmarketos.org/postmarketOS/pmbootstrap/-/raw/master/pmbootstrap.py
python3 pmbootstrap.py init
./mobile/scripts/build-mobile.sh
```
说明：设备移植需要真机硬件信息，仓库提供**模板 + 流程**；
填入真实值后即可按 postmarketOS 官方文档完成移植。

## 本环境验证情况（2026-09-19）
- 两个仓库目录、构建脚本、配置模板全部落盘
- `nova-kernel` v0.5：零警告编译通过，镜像布局字节级验证（55AA 签名、loader、
  内核 28828B、ELF 单段 0x200000、FAT12 根目录/簇链/文件内容验证通过）
- `novaos-linux`：live-build/pmbootstrap 脚本与安装器均通过 `sh -n` 语法检查；
  本机无 root，实际出 ISO 走上述 GitHub Actions 云端通道
