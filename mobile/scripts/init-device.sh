#!/bin/sh
# NovaOS mobile - generate a new device port skeleton
# Usage: ./mobile/scripts/init-device.sh <vendor> <codename> [ui]
#   ui: phosh | plasma-mobile | sxmo   (default phosh)
set -e

VENDOR="${1:?usage: init-device.sh <vendor> <codename> [ui]}"
CODENAME="${2:?usage: init-device.sh <vendor> <codename> [ui]}"
UI="${3:-phosh}"
DEV="mobile/devices/${VENDOR}-${CODENAME}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEV_ABS="${ROOT}/${DEV}"

mkdir -p "${DEV_ABS}"
cat > "${DEV_ABS}/deviceinfo" <<EOF
# NovaOS device port - ${VENDOR} ${CODENAME}
# Copy the real values from upstream postmarketOS or the vendor's
# downstream device tree, then adjust.
deviceinfo_format_version="0"
deviceinfo_name="${VENDOR} ${CODENAME}"
deviceinfo_manufacturer="${VENDOR}"
deviceinfo_codename="${CODENAME}"
deviceinfo_arch="armv7"
deviceinfo_chassis="handset"
deviceinfo_keyboard="false"
deviceinfo_external_storage="true"
deviceinfo_screen_width="1080"
deviceinfo_screen_height="1920"
deviceinfo_ram="2048"
deviceinfo_cpu="generic-cortex-a7"
deviceinfo_dtb="${VENDOR}-${CODENAME}"
deviceinfo_modules_initfs=""
deviceinfo_generate_bootimg="true"
deviceinfo_bootimg_generate="true"
deviceinfo_bootimg_kernel_cmdline="console=ttyMSM0,115200n8"
EOF

cat > "${DEV_ABS}/APKBUILD" <<EOF
# NovaOS kernel package for ${VENDOR} ${CODENAME}
# Based on postmarketOS device kernel template. Point _commit at the
# mainline or downstream kernel tag for this SoC.
pkgname="linux-${VENDOR}-${CODENAME}"
pkgver=6.6.30
pkgrel=0
pkgdesc="${VENDOR} ${CODENAME} kernel"
arch="armv7 armv7hf aarch64"
depends="postmarketos-base"
makedepends="perl sed installkernel gcc-armv7-none-eabihf"
options="!strip !check !tracedeps pmb:strict"
_url="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.30.tar.xz"
source="
	\$pkgname-\$pkgver.tar.xz::\$_url
	${CODENAME}.config
"
builddir="\$srcdir/linux-\$pkgver"
EOF

# UI preset
mkdir -p "mobile/ui/${UI}"
echo "# NovaOS UI profile: ${UI}" > "mobile/ui/${UI}/README.md"

echo "==> Created ${DEV}"
echo "Next steps:"
echo "  1. fill deviceinfo (screen, ram, dtb, cmdline)"
echo "  2. add a kernel .config (make ${CODENAME}.config)"
echo "  3. pmbootstrap build; see docs/MOBILE.md"
