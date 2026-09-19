# 设备移植模板使用说明（TEMPLATE）

本模板是给**真实手机**做 NovaOS mobile（postmarketOS 风格）移植的骨架。
**模板里的 `<尖括号>` 全部是占位符，必须换成你手里那台真机的数据**，
不换就跑不起来——移植的本质就是“用真机数据填充骨架”。

## 移植步骤（对着 postmarketOS 官方文档做）

1. **选机**：bootloader 可解锁、社区有移植先例的机型成功率最高。
   可查设备数据库：https://wiki.postmarketos.org/wiki/Devices

2. **收集真机数据**（全程在手机上操作，或 adb shell）：
   - 架构：`uname -m`
   - SoC/主板：`cat /proc/device-tree/compatible` 或 `dmesg | grep machine`
   - 内核版本：`uname -r`
   - GPU 家族：`dmesg | grep -i gpu`

3. **填 deviceinfo**：复制本目录 `deviceinfo` → `mobile/devices/<厂商>-<代号>/`，
   逐行替换占位符。每个字段的取值方法都写在文件注释里。

4. **填内核**：在 deviceinfo 里写清楚用哪个内核包
   （`linux-postmarketos-mainline` 或厂商下游内核），
   内核配置补丁参考 pmOS 主线化指南：
   https://wiki.postmarketos.org/wiki/Mainlining_Guide

5. **构建 + 烧录**：
   ```sh
   python3 pmbootstrap.py init          # 首次配置
   ./mobile/scripts/build-mobile.sh     # 构建镜像
   ./mobile/scripts/flash.sh --device <代号>
   ```

6. **排错**：串口日志（若支持）/ 屏幕报错 → 回 wiki 对照常见问题。
   一个可用的移植通常要迭代多轮，社区机型板块是最好的参考资料。

## 为什么不能直接给“成品”设备文件

每个型号的 SoC、分区表、bootloader 行为都不同，任何“抄来的”设备文件
在别的机器上都会变砖。**填真机数据不是可选项**——这正是 postmarketOS
官方移植流程的硬性要求，也是“不是玩具”的底线。

> 参考：
> - pmOS 移植指南：https://wiki.postmarketos.org/wiki/Porting_to_a_new_device
> - 主线化指南：https://wiki.postmarketos.org/wiki/Mainlining_Guide
> - 设备数据库：https://wiki.postmarketos.org/wiki/Devices
