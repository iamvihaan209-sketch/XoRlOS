#!/bin/sh
# XoRlOS build driver: runs each stage in order.
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export ROOT
export BUILD_DIR="${BUILD_DIR:-$ROOT/build}"
export ROOTFS="$BUILD_DIR/rootfs"
export ALPINE_VERSION="${ALPINE_VERSION:-3.20}"
export ALPINE_RELEASE="${ALPINE_RELEASE:-3.20.3}"
export ARCH="${ARCH:-x86_64}"

if [ "$(id -u)" -ne 0 ]; then
    echo "build.sh must be run as root" >&2
    exit 1
fi

# Install host build dependencies on Debian/Ubuntu if any are missing.
need=""
for t in curl tar mksquashfs xorriso grub-mkrescue; do
    command -v "$t" >/dev/null 2>&1 || need="yes"
done
if [ -n "$need" ] && command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y curl squashfs-tools xorriso mtools \
        grub-pc-bin grub-efi-amd64-bin grub-common
fi

mkdir -p "$BUILD_DIR"

for stage in "$ROOT"/scripts/0*.sh; do
    echo "==> $(basename "$stage")"
    sh "$stage"
done

echo "Done: $BUILD_DIR/xorlos.iso"
