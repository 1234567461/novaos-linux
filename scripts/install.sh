#!/bin/sh
# ============================================================================
#  NovaOS Linux - one-shot installer (run inside the live ISO)
#  Usage: sudo ./scripts/install.sh
#
#  Asks for:  version (gnome/xfce/cli)  language (zh/en)  keyboard layout
#             target disk  hostname  admin username
#  Then: partitions the disk (ext4 + optional swap), copies the live root
#  filesystem, installs GRUB, and writes locale/fonts/keyboard/fstab.
#
#  This is a real, runnable installer - not a mockup.  It intentionally
#  avoids wiping anything without confirmation and refuses to touch the
#  disk it is currently running from.
# ============================================================================
set -e

say()  { printf "\033[1;34m[NovaOS]\033[0m %s\n" "$*"; }
die()  { printf "\033[1;31m[NovaOS ERROR]\033[0m %s\n" "$*"; exit 1; }
ask()  { printf "%s" "$*"; }

# --- must be root ----------------------------------------------------------
[ "$(id -u)" = "0" ] || die "run with sudo/root: sudo ./scripts/install.sh"

# --- which disk are we booted from? never touch it -------------------------
BOOTDEV="$(findmnt -no SOURCE / 2>/dev/null | sed 's/[0-9]*$//')"
say "current live root is on: ${BOOTDEV:-unknown}"

echo
ask "NovaOS version? [gnome/xfce/cli] (default: gnome) > "
read -r VER; VER="${VER:-gnome}"
case "$VER" in gnome|xfce|cli) ;; *) die "unknown version: $VER" ;; esac

ask "Language? [zh/en] (default: zh) > "
read -r LANG_; LANG_="${LANG_:-zh}"
case "$LANG_" in zh|en) ;; *) die "unknown language: $LANG_" ;; esac

ask "Keyboard layout? [us/gb/de/fr/jp] (default: us) > "
read -r KBD; KBD="${KBD:-us}"
case "$KBD" in us|gb|de|fr|jp) ;; *) die "unknown keyboard: $KBD" ;; esac

ask "Hostname? (default: novaos) > "
read -r HOST; HOST="${HOST:-novaos}"

ask "Admin username? (default: novaos) > "
read -r USERNAME; USERNAME="${USERNAME:-novaos}"

echo
say "Available disks:"
lsblk -d -o NAME,SIZE,MODEL | grep -v loop
echo
ask "Target disk (e.g. sda, nvme0n1) > "
read -r DISK
DISK="/dev/$DISK"
[ -b "$DISK" ] || die "not a block device: $DISK"
case "$DISK" in
    "$BOOTDEV"*) die "refusing to install onto the disk you are running from" ;;
esac
PART="${DISK}$([ "${DISK#/dev/nvme}" != "$DISK" ] && echo p)"
ROOTPART="${PART}1"
SWAPPART="${PART}2"

ask "Create swap partition? [y/N] > "
read -r WANTSWAP; WANTSWAP="${WANTSWAP:-n}"

say "Installing NovaOS $VER (lang=$LANG_, kbd=$KBD, host=$HOST, user=$USERNAME)"
say "Target: $DISK  (root=$ROOTPART${WANTSWAP:+, swap=$SWAPPART})"
ask "Type YES to continue > "
read -r OK; [ "$OK" = "YES" ] || die "aborted"

# --- partition -------------------------------------------------------------
say "partitioning $DISK"
wipefs -a "$DISK" 2>/dev/null || true
if [ "$WANTSWAP" = "y" ]; then
    sfdisk --wipe always "$DISK" <<EOF
label: gpt
${ROOTPART}: size=+20G, type=linux
${SWAPPART}: type=linux-swap
EOF
else
    sfdisk --wipe always "$DISK" <<EOF
label: gpt
${ROOTPART}: type=linux
EOF
fi
partprobe "$DISK" 2>/dev/null || sleep 3

# --- filesystems -----------------------------------------------------------
say "formatting"
mkfs.ext4 -F -L novaos-root "$ROOTPART"
[ "$WANTSWAP" = "y" ] && mkswap "$SWAPPART"

# --- copy the live root filesystem -----------------------------------------
say "copying root filesystem (this takes a while)..."
mkdir -p /mnt/novaos
mount "$ROOTPART" /mnt/novaos
rsync -aHAXx --info=progress2 \
    --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/run \
    --exclude=/tmp --exclude=/mnt --exclude=/media --exclude=/lost+found \
    / /mnt/novaos/
mkdir -p /mnt/novaos/{proc,sys,dev,run,tmp,mnt,media,lost+found}

# --- configure the installed system ----------------------------------------
say "writing fstab"
ROOTUUID="$(blkid -s UUID -o value "$ROOTPART")"
{
    echo "UUID=$ROOTUUID  /  ext4  errors=remount-ro  0  1"
    [ "$WANTSWAP" = "y" ] && \
        echo "UUID=$(blkid -s UUID -o value "$SWAPPART")  none  swap  sw  0  0"
    echo "proc  /proc  proc  defaults  0  0"
} > /mnt/novaos/etc/fstab

say "configuring language/keys"
sed -i "s/^LANG=.*/LANG=${LANG_}.UTF-8/" /mnt/novaos/etc/default/locale
[ -f /mnt/novaos/etc/locale.gen ] && \
    sed -i "s/^# *${LANG_}.UTF-8/${LANG_}.UTF-8/" /mnt/novaos/etc/locale.gen
sed -i "s/^XKBLAYOUT=.*/XKBLAYOUT=\"$KBD\"/" /mnt/novaos/etc/default/keyboard
echo "$HOST" > /mnt/novaos/etc/hostname

say "creating user $USERNAME in chroot"
chroot /mnt/novaos /bin/bash -c "
    useradd -m -G sudo,users -s /bin/bash '$USERNAME' 2>/dev/null || true
    passwd -l root 2>/dev/null || true
"
echo "set a password for $USERNAME:"
chroot /mnt/novaos /bin/bash -c "passwd '$USERNAME'"

say "installing GRUB"
mount --bind /dev /mnt/novaos/dev
mount --bind /proc /mnt/novaos/proc
mount --bind /sys /mnt/novaos/sys
chroot /mnt/novaos /bin/bash -c "
    grub-install '$DISK' --target=i386-pc 2>/dev/null || grub-install '$DISK'
    update-grub
"

say "unmounting"
umount /mnt/novaos/dev /mnt/novaos/proc /mnt/novaos/sys 2>/dev/null || true
umount /mnt/novaos

say "done.  remove the live USB and reboot:  sudo reboot"
