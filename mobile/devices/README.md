# NovaOS mobile - device porting templates
#
# This directory holds ready-to-fill device porting skeletons in
# postmarketOS (pmOS) format.  Copy a template and replace every
# <PLACEHOLDER> with the real values from YOUR device, gathered with:
#
#   ./mobile/scripts/init-device.sh <vendor> <codename> <ui>
#
# Reference (read these first - the numbers must come from the device):
#   pmOS porting guide: https://wiki.postmarketos.org/wiki/Porting_to_a_new_device
#   Mainlining guide:   https://wiki.postmarketos.org/wiki/Mainlining_Guide
#   Device database:    https://wiki.postmarketos.org/wiki/Devices
#
# Structure:
#   TEMPLATE/           - skeleton you copy per device
#   <vendor>-<codename>/ - one directory per real device (fill in the data)

## How to add a real device

1. Pick a phone that is NOT carrier-locked and has an unlockable bootloader.
2. Boot it into recovery/fastboot and collect:
   - SoC / chipset (e.g. "samsung,exynos7880" from `dmesg | grep machine`)
   - kernel version (`adb shell uname -a` or Settings -> About)
   - whether mainline or downstream kernel exists in pmOS/linux kernel trees
3. Create the directory and fill deviceinfo / kernel config / modules.
4. Build with pmbootstrap (see docs/MOBILE.md) and test-boot.
