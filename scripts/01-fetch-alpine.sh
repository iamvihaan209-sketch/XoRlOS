#!/bin/sh
# Stage 1: download and unpack the Alpine minirootfs.
set -eu

TARBALL="alpine-minirootfs-${ALPINE_RELEASE}-${ARCH}.tar.gz"
URL="https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/releases/${ARCH}/${TARBALL}"

mkdir -p "$BUILD_DIR/dl" "$ROOTFS"

if [ ! -f "$BUILD_DIR/dl/$TARBALL" ]; then
    curl -fL -o "$BUILD_DIR/dl/$TARBALL" "$URL"
    curl -fL -o "$BUILD_DIR/dl/$TARBALL.sha256" "$URL.sha256"
fi

(cd "$BUILD_DIR/dl" && sha256sum -c "$TARBALL.sha256")

tar -xzf "$BUILD_DIR/dl/$TARBALL" -C "$ROOTFS"
echo "Unpacked $TARBALL into $ROOTFS"
