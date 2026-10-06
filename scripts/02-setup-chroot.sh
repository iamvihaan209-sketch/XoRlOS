#!/bin/sh
# Stage 2: prepare the chroot (DNS, repositories, pseudo-filesystems).
set -eu

cp /etc/resolv.conf "$ROOTFS/etc/resolv.conf"

cat > "$ROOTFS/etc/apk/repositories" <<EOF
https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main
https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community
EOF

mountpoint -q "$ROOTFS/proc" || mount -t proc proc "$ROOTFS/proc"
mountpoint -q "$ROOTFS/sys"  || mount --rbind /sys "$ROOTFS/sys"
mountpoint -q "$ROOTFS/dev"  || mount --rbind /dev "$ROOTFS/dev"

echo "Chroot ready at $ROOTFS"
