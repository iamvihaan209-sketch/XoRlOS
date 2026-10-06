# XoRlOS

A lightweight, general-purpose Linux distribution built on Alpine Linux.

## Specs

| Component        | Choice                                   |
|------------------|------------------------------------------|
| Base             | Alpine Linux                             |
| Kernel           | Linux 6.x                                |
| Display server   | X11 (chosen over Wayland for stability)  |
| Window manager   | Openbox                                  |
| Desktop          | LXQt                                     |
| Init system      | OpenRC                                   |
| RAM              | 1 GB minimum, 3 GB sweet spot            |

## Layout

```
scripts/
  build.sh              # runs the full pipeline
  01-fetch-alpine.sh    # download Alpine minirootfs
  02-setup-chroot.sh    # mount and enter the chroot
  03-install-packages.sh# X11, Openbox, LXQt, OpenRC services
  04-configure-system.sh# users, hostname, services
  05-build-iso.sh       # assemble the bootable ISO
bootloader/grub.cfg
config/kernel.config
```

## Building

Run as root on a Linux host with `curl`, `tar`, `xorriso`, `grub` and `mtools` installed:

```sh
sudo ./scripts/build.sh
```

The ISO is written to `build/xorlos.iso`.

## Status

Early scaffolding. The scripts define the pipeline; package lists and kernel
options still need tuning and testing in a VM.
