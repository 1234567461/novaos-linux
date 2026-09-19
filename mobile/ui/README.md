# NovaOS Mobile - UI profiles
#
# postmarketOS style: same Alpine base, pick a UI at build time.
# Reference: https://wiki.postmarketos.org/wiki/UI
#
# phosh         - GNOME Phone Shell (Phosh), Wayland compositor wlroots-based,
#                 swipe gestures, good for daily-driver handsets
# plasma-mobile - KDE Plasma Mobile, full KDE experience adapted to touch
# sxmo          - suckless X11 mobile: dmenu + sway/tmux, keyboard-first,
#                 extremely light (runs on 512MB RAM devices)
#
# Select by editing mobile/scripts/build-mobile.sh: UI=phosh|plasma-mobile|sxmo
