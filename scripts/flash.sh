#!/bin/sh
# NovaOS Linux - flash an image
# Usage: flash.sh <image> <device>
#   desktop: ISO -> USB stick (dd)
#   mobile : postmarketOS image -> partition via pmbootstrap flasher
set -e

IMAGE="${1:?usage: flash.sh <image> <device>}"
DEVICE="${2:?usage: flash.sh <image> <device>}"

case "${IMAGE}" in
*.iso)
    echo "==> Writing ISO ${IMAGE} to ${DEVICE} (dd)"
    echo "    WARNING: ${DEVICE} will be erased."
    read -r -p "Type YES to continue: " ok
    [ "${ok}" = "YES" ] || { echo aborted; exit 1; }
    sudo dd if="${IMAGE}" of="${DEVICE}" bs=4M status=progress oflag=sync
    ;;
*)
    echo "==> Flashing mobile image via pmbootstrap"
    pmbootstrap flasher flash_system --image "${IMAGE}"
    pmbootstrap flasher flash_kernel
    ;;
esac
echo "done"
