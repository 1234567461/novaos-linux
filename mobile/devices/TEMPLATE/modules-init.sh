#!/bin/sh
# NovaOS mobile - module init script template
#
# Runs early in the initramfs on the device.  It is responsible for
# loading the kernel modules that the root filesystem or the UI needs
# before/right after switch_root.  Replace <MODULES> with the module
# names from your deviceinfo (DEVICE_MODULES).
#
# Copy to mobile/devices/<vendor>-<codename>/modules-init.sh

echo "novaos: loading device modules"

# --- wireless / wlan ------------------------------------------------------
# for <wlan> in <MODULES>; do
#     modprobe "$<wlan>" 2>/dev/null || echo "novaos: failed to load $<wlan>"
# done

# --- sound codec ----------------------------------------------------------
# modprobe <snd-codec> 2>/dev/null || true

echo "novaos: modules done"
