#!/bin/sh
# Stage 5: build a bootable ISO from the rootfs.
set -eu

ISO_DIR="$BUILD_DIR/iso"
rm -rf "$ISO_DIR"
mkdir -p "$ISO_DIR/boot/grub"

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
cp "$ROOTFS"/boot/initramfs-lts "$ISO_DIR/boot/initramfs"
cp "$ROOT/bootloader/grub.cfg" "$ISO_DIR/boot/grub/grub.cfg"

mksquashfs "$ROOTFS" "$ISO_DIR/rootfs.squashfs" -comp xz -noappend \
    -wildcards -e 'proc/*' 'sys/*' 'dev/*' 'run/*' 'tmp/*'

grub-mkrescue -o "$BUILD_DIR/xorlos.iso" "$ISO_DIR"
echo "ISO written to $BUILD_DIR/xorlos.iso"
