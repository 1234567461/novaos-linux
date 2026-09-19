#!/bin/sh
# NovaOS mobile - read-only root-readiness check
# Usage: run this ON the Android device (Termux / adb shell):
#   sh root-check.sh
#
# It only READS device information - it does not modify anything,
# does not unlock anything, and does not install anything.
set -e

say() { printf "\033[1;34m[check]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[warn ]\033[0m %s\n" "$*"; }
ok()  { printf "\033[1;32m[ok   ]\033[0m %s\n" "$*"; }
fail(){ printf "\033[1;31m[fail ]\033[0m %s\n" "$*"; }

say "device model"
getprop ro.product.model 2>/dev/null | sed 's/^/    /'
getprop ro.product.manufacturer 2>/dev/null | sed 's/^/    /'

say "architecture"
ABI="$(getprop ro.product.cpu.abi 2>/dev/null)"
case "$ABI" in
    arm64-v8a) ok "arm64-v8a - Magisk fully supported" ;;
    armeabi-v7a|armeabi) ok "armeabi-v7a - supported (older devices)" ;;
    x86_64|x86) warn "x86_64 - limited support" ;;
    *) warn "unknown ABI: $ABI" ;;
esac

say "android version / api"
API="$(getprop ro.build.version.sdk 2>/dev/null)"
echo "    sdk=$API"
if [ -n "$API" ] && [ "$API" -ge 31 ] 2>/dev/null; then
    ok "Android 12+ (GKI 2.0) - KernelSU eligible"
else
    warn "pre-GKI device - Magisk path recommended"
fi

say "kernel"
uname -r 2>/dev/null | sed 's/^/    /'

say "bootloader unlock state (may be empty on some devices)"
case "$(getprop ro.boot.flash.locked 2>/dev/null)" in
    0) ok "bootloader appears UNLOCKED" ;;
    1) warn "bootloader appears LOCKED - unlock is the first required step" ;;
    *) echo "    unknown (vendor hides this prop)" ;;
esac

say "current root status"
if [ -x /system/bin/su ] || [ -f /sbin/su ] || command -v magisk >/dev/null 2>&1; then
    ok "already rooted (su/magisk detected)"
else
    warn "not rooted yet"
fi

echo
say "next steps (see docs/ANDROID-ROOT.md):"
echo "    1. back up your data"
echo "    2. unlock the bootloader (vendor official tool, one-time, usually needs a PC)"
echo "    3. Magisk App -> Install -> patch boot.img (phone-only)"
echo "    4. flash patched boot.img (fastboot / recovery / Magisk direct install)"
