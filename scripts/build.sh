#!/bin/sh
# NovaOS Linux - build scripts
# build-desktop.sh : live-build ISO (desktop/)
# build-mobile.sh  : pmbootstrap image (mobile/)
# flash.sh         : flash a built image to a device / USB stick
set -e

case "${1}" in
desktop)
    cd "$(dirname "$0")/../desktop"
    ./auto/build
    ;;
mobile)
    cd "$(dirname "$0")/../mobile"
    ./scripts/build-mobile.sh
    ;;
flash)
    shift
    "$(dirname "$0")/flash.sh" "$@"
    ;;
*)
    echo "usage: $0 {desktop|mobile|flash <image> <device>}"
    exit 1
    ;;
esac
