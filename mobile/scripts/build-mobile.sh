#!/bin/sh
# NovaOS mobile - build a postmarketOS-style image for a device port
# Requires: pmbootstrap (https://postmarketos.org, pmbootstrap.py)
# Usage: ./scripts/build-mobile.sh [vendor-codename] [ui]
set -e

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE="${1:-samsung-i9100}"       # placeholder: replace with your port
UI="${2:-phosh}"
UI_PKGS=""
case "${UI}" in
    phosh)         UI_PKGS="phosh phoc postmarketos-ui-phosh" ;;
    plasma-mobile) UI_PKGS="plasma-mobile" ;;
    sxmo)          UI_PKGS="sxmo" ;;
    *) echo "unknown UI: ${UI} (phosh|plasma-mobile|sxmo)"; exit 1 ;;
esac

command -v pmbootstrap >/dev/null || {
    echo "pmbootstrap not found - fetch it:"
    echo "  wget https://gitlab.postmarketos.org/postmarketOS/pmbootstrap/-/raw/master/pmbootstrap.py"
    exit 1
}

pmbootstrap init \
    --aports "$ROOT/mobile" \
    --device "${DEVICE}" \
    --ui "${UI}"

pmbootstrap install
pmbootstrap export
echo "==> image exported under ~/.local/var/postmarketOS/export/"
echo "    flash with: ./scripts/flash.sh <image> <device>"
