#!/bin/sh
# Stage 5: build a bootable ISO from the rootfs.
set -eu

ISO_DIR="$BUILD_DIR/iso"
rm -rf "$ISO_DIR"
mkdir -p "$ISO_DIR/boot/grub"

# Build the live-boot initramfs inside the chroot with our own init.
KVER="$(ls "$ROOTFS/lib/modules" | head -n 1)"
echo "Kernel modules found for: $KVER"
mkdir -p "$ROOTFS/etc/mkinitfs/features.d"
cp "$ROOT/initramfs/xorlos.modules" "$ROOTFS/etc/mkinitfs/features.d/xorlos.modules"
cp "$ROOT/initramfs/init" "$ROOTFS/xorlos-init"
chmod 755 "$ROOTFS/xorlos-init"
chroot "$ROOTFS" mkinitfs -o /boot/initramfs-xorlos -i /xorlos-init \
    -F "base xorlos" "$KVER"
rm -f "$ROOTFS/xorlos-init"
test -s "$ROOTFS/boot/initramfs-xorlos"

# Unmount pseudo-filesystems before packing (lazy fallback if busy).
for m in dev sys proc; do
    umount -R "$ROOTFS/$m" 2>/dev/null || umount -R -l "$ROOTFS/$m" 2>/dev/null || true
done

# Refuse to pack if anything is still mounted under the rootfs.
if grep -q " $ROOTFS/" /proc/mounts; then
    echo "ERROR: mounts still present under $ROOTFS:" >&2
    grep " $ROOTFS/" /proc/mounts >&2
    exit 1
fi

cp "$ROOTFS"/boot/vmlinuz-lts "$ISO_DIR/boot/vmlinuz"
cp "$ROOTFS"/boot/initramfs-xorlos "$ISO_DIR/boot/initramfs"
cp "$ROOT/bootloader/grub.cfg" "$ISO_DIR/boot/grub/grub.cfg"

mksquashfs "$ROOTFS" "$ISO_DIR/rootfs.squashfs" -comp xz -noappend \
    -wildcards -e 'proc/*' 'sys/*' 'dev/*' 'run/*' 'tmp/*' 'boot/*'

grub-mkrescue -o "$BUILD_DIR/xorlos.iso" "$ISO_DIR"
echo "ISO written to $BUILD_DIR/xorlos.iso"
