# NovaOS 手机系统 - Root 方案（合规版）

> 需求："安卓一键 root，不需要电脑，支持临时和永久，有支持列表"。
> 本文件给出**可靠、合规、可长期维护**的方案，并说明为什么
> "完全不需要电脑的漏洞一键 root"不应该用。

## 先说结论（重要）

- **不存在可靠且安全的"完全免电脑一键 root"**：这类工具（如各类
  KingRoot 式一键 root）要么早已失效（利用的是几年前已修复的内核漏洞），
  要么本身是恶意软件（偷数据/装后门/锁机）。**不要使用**。
- **正道的"一键"**：Magisk 官方 App 本身就能在手机上完成"打补丁"这一步；
  唯一通常需要电脑的环节是**首次解锁 bootloader**（厂商安全机制，无法绕过
  也**不应该**绕过）。解锁之后，绝大多数操作可以纯手机完成。
- "临时"与"永久"的本质区别 = 是否改写 **boot 分区**，两者 Magisk 都支持。

## 推荐工具

| 工具 | 特点 | 临时/永久 |
|---|---|---|
| **Magisk**（推荐） | systemless root，不碰 system 分区，可完整还原 | 都支持 |
| **KernelSU** | 内核级 root（GKI 内核），更隐蔽、更稳 | 都支持 |

- Magisk 官方：github.com/topjohnwu/Magisk
- KernelSU 官方：github.com/tiann/KernelSU
（下载请走官方发布页，校验签名，别用第三方"修改版"）

## 标准流程（手机 + 最少电脑）

```
1. 备份所有数据（解锁会清空设备）
2. 解锁 bootloader（厂商官方工具/命令，通常需电脑一次）
3. 拿到本机原版 boot.img（官方固件包内提取，或用 Magisk App 从设备提取）
4. 【纯手机】Magisk App → 安装 → 选择并修补一个文件 → 选 boot.img
5. 刷入修补后的 boot.img：
     - 有电脑：fastboot flash boot magisk_patched-*.img
     - 无电脑（已 root 或有第三方 Recovery）：App 内直接安装到
       inactive slot / Recovery 里刷入
6. 重启，打开 Magisk App 确认 "Installed" 即成功
```

## 临时 root 与永久 root

- **永久 root**：刷入修补过的 boot.img（修改了 boot 分区）。升级系统前
  Magisk 会提示"还原原厂镜像"，否则 OTA 会失败。
- **临时 root**：Magisk App → 卸载 → 还原原厂镜像（**不丢数据**），重启即
  恢复未 root 状态；之后再次修补刷入即可恢复 root。由于 Magisk 是
  systemless（所有改动在 boot 分区的 ramdisk 里），"还原 boot"就是
  最干净的临时开关。
- 想"借一个 root 用一次"的场景（如备份 App 数据），用还原/重刷即可，
  不必折腾别的工具。

## 支持列表（怎么查你的设备）

**架构**（几乎覆盖所有在售安卓机）：
- arm64-v8a：绝大多数现代手机 ✅
- armeabi-v7a：旧机/低端机 ✅
- x86_64：少数平板/模拟器（支持有限）

**判定设备是否可行**（逐条自查）：

| 检查项 | 方法 | 说明 |
|---|---|---|
| Bootloader 可解锁 | 设置→关于→点版本号7次→开发者选项→OEM 解锁 | 部分运营商定制机/锁区机不可解锁 |
| 内核版本 | 设置→关于→内核版本 | KernelSU 需 GKI 2.0（Android 12+） |
| Magisk 兼容性 | Magisk App → 安装 → 检查"RAM disk" | 提示 no ramdisk 需改用其他方案 |
| 官方支持 | Magisk 讨论区/设备 Wiki 搜索机型 | 冷门机型看社区验证帖 |

**真实设备名单**请在社区核实（每天在变）：
- Magisk 官方讨论区（XDA 对应机型板块）
- KernelSU 官方文档的设备列表
- postmarketOS 设备数据库（与"手机 Linux 化"互通：能解锁 bootloader 的设备
  一般都能 root）

## 风险与底线

- root 后：银行/支付类 App、部分游戏可能拒绝运行（Play Integrity/安全检测）
- 系统 OTA 升级需先还原原厂镜像；保修视厂商政策可能受影响
- **红线**：本项目**不做**利用内核漏洞、绕过设备安全机制的免电脑提权工具，
  也不提供此类工具/利用代码。上面是官方、可维护、可还原的正道。
- 配套自查脚本见 `mobile/scripts/root-check.sh`（只读检查，不做任何修改）。
