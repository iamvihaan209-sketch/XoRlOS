#!/bin/sh
# Stage 3: install the base system, X11, Openbox and LXQt inside the chroot.
set -eu

chroot "$ROOTFS" /bin/sh -eu <<'EOF'
apk update
apk add \
    alpine-base openrc linux-lts linux-firmware-none \
    eudev udev-init-scripts dbus elogind polkit-elogind \
    xorg-server xf86-input-libinput xf86-video-vesa mesa-dri-gallium \
    openbox obconf-qt \
    lxqt-desktop lxqt-session lxqt-panel pcmanfm-qt qterminal \
    sddm \
    networkmanager networkmanager-wifi \
    font-dejavu \
    firefox-esr

rc-update add devfs sysinit
rc-update add udev sysinit
rc-update add dbus default
rc-update add elogind default
rc-update add networkmanager default
rc-update add sddm default
EOF
