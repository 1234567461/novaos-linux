# NovaOS Linux Mobile — postmarketOS 风格手机系统移植框架

> 目标：让 Linux 手机系统跑在真机上。机制完全复用 postmarketOS：
> Alpine Linux（musl + BusyBox + apk-tools）为基座，每个设备一个
> 移植目录（deviceinfo + 内核 APKBUILD + 设备树），UI 三选一。
> 参考：
> - https://wiki.postmarketos.org/wiki/Porting_to_a_new_device
> - https://wiki.postmarketos.org/wiki/Mainlining_Guide
> - https://wiki.postmarketos.org/wiki/UI

## 手机系统组成（调研结论）

| 组件 | 说明 | 本仓库位置 |
|---|---|---|
| Alpine 基座 | 5-6MB 根文件系统，apk 包管理 | 构建时拉取 |
| 设备专属内核包 | `linux-<厂商>-<机型>` APKBUILD + 内核 .config | `mobile/devices/<设备>/APKBUILD` |
| deviceinfo | 屏幕/内存/架构/DTB/引导参数 | `mobile/devices/<设备>/deviceinfo` |
| 设备树 DTB | 主线上游或 downstream | 构建时编译 |
| UI | phosh / plasma-mobile / sxmo | `mobile/ui/` |

## 新建一个设备移植

```sh
./mobile/scripts/init-device.sh <厂商> <代号> [ui]
# 例如: ./mobile/scripts/init-device.sh samsung i9100 phosh
```

然后补全 deviceinfo 真实值 + 内核 .config（可从主线 defconfig 裁剪）。

## 构建镜像

```sh
# 依赖 pmbootstrap（postmarketOS 官方工具）
./mobile/scripts/build-mobile.sh <设备> <ui>
```

## 烧录

```sh
./scripts/flash.sh <导出镜像> <设备>
```

## 硬件外设清单（移植时要逐项验证）

- 屏幕（DSI/DPU/背光）、触屏（I2C/SPI）
- 调制解调器（RIL：ModemManager + oFono，需 firmware）
- Wi-Fi/BT（cfg80211 + 固件）、GPS、NFC
- 音频（ALSA UCM 配置）、相机、电池/充电（power_supply）、按键
- 传感器（accel/gyro/prox）→ iio

## 与 nova-kernel 自研仓库的关系

自研内核的图形栈（帧缓冲 + 窗口管理）为手机 UI 提供底层认知；
pmOS 是生产级参照实现，两者驱动代码与经验互相借鉴。
