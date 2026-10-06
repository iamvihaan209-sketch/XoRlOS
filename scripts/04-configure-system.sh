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
User=xor
Session=lxqt.desktop
CONF
mkdir -p /etc/xdg/lxqt
cat > /etc/xdg/lxqt/session.conf <<CONF
[General]
window_manager=openbox
CONF

# Live system: empty fstab (root is an overlay), and a serial console login
# so headless boots (CI / QEMU) have somewhere to land.
touch /etc/fstab
grep -q '^ttyS0' /etc/inittab ||
    echo 'ttyS0::respawn:/sbin/getty -L 115200 ttyS0 vt100' >> /etc/inittab
EOF

echo "System configured. Default user: xor (change the password after first boot)."
