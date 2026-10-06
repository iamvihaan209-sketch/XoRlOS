#!/bin/sh
# Stage 4: hostname, default user, and session defaults.
set -eu

echo "xorlos" > "$ROOTFS/etc/hostname"

chroot "$ROOTFS" /bin/sh -eu <<'EOF'
adduser -D -s /bin/sh -G wheel xor
echo "xor:xorlos" | chpasswd
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/xorlos.conf <<CONF
[Autologin]
Session=lxqt.desktop
CONF
mkdir -p /etc/xdg/lxqt
cat > /etc/xdg/lxqt/session.conf <<CONF
[General]
window_manager=openbox
CONF
EOF

echo "System configured. Default user: xor (change the password after first boot)."
