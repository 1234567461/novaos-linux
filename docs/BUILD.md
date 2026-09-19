# 构建环境与验证

## 桌面 ISO（live-build）
```sh
# 构建机（Debian 12 / Ubuntu 22.04+）
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
- `nova-kernel`：零警告编译通过，镜像布局字节级验证（55AA 签名、loader、
  内核地址 0x100000）
- `novaos-linux`：live-build/pmbootstrap 脚本为真实可执行语法，
  因本机无 root + 无对应硬件，未实际出 ISO/烧录——在具备 Debian 构建机
  或真机环境下按本文件步骤执行即可
