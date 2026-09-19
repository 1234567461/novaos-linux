# NovaOS Linux - desktop build profiles
#
# Each subdirectory is a selectable build profile. Set LB_PACKAGE_LISTS and
# LB_HOOKS in auto/config to point at a profile, or pass on the command line:
#   lb config --packages-list novaos-desktop
#
# Available profiles:
#   gnome    - full GNOME desktop (default, task-gnome-desktop)
#   xfce     - lightweight XFCE for old hardware
#   cli      - no desktop environment (server / headless, SSH-based)
#              built with:
#                cp profiles/cli/novaos-cli.list.chroot \
#                   config/package-lists/novaos-desktop.list.chroot
