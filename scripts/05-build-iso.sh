#!/bin/sh
# Stage 5: build a bootable ISO from the rootfs.
set -eu

ISO_DIR="$BUILD_DIR/iso"
rm -rf "$ISO_DIR"
mkdir -p "$ISO_DIR/boot/grub"

# Unmount pseudo-filesystems before packing.
for m in dev sys proc; do
    umount -R "$ROOTFS/$m" 2>/dev/null || true
done

cp "$ROOTFS"/boot/vmlinuz-lts "$ISO_DIR/boot/vmlinuz"
cp "$ROOTFS"/boot/initramfs-lts "$ISO_DIR/boot/initramfs"
cp "$ROOT/bootloader/grub.cfg" "$ISO_DIR/boot/grub/grub.cfg"

mksquashfs "$ROOTFS" "$ISO_DIR/rootfs.squashfs" -comp xz -noappend

grub-mkrescue -o "$BUILD_DIR/xorlos.iso" "$ISO_DIR"
echo "ISO written to $BUILD_DIR/xorlos.iso"
