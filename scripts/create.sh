#!/bin/sh

#curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
# curl -fsSL -o hello-rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4

# apk update
# apk add e2fsprogs sudo

apt update -y
apt install -y sudo wget

wget https://raw.githubusercontent.com/alpinelinux/alpine-make-rootfs/v0.5.1/alpine-make-rootfs -O alpine-make-rootfs

sudo chmod +x ./alpine-make-rootfs

sudo ./alpine-make-rootfs \
  --branch v3.8 \
  --packages 'openrc util-linux' \
  --script-chroot \
  rootfs.tar.gz - <<'SHELL'
    mkdir -p /etc
    ln -s agetty /etc/init.d/agetty.ttyS0
    echo ttyS0 > /etc/securetty
    echo 'nameserver 1.1.1.1' > /etc/resolv.conf
    rc-update add agetty.ttyS0 default
    rc-update add devfs boot
    rc-update add procfs boot
    rc-update add sysfs boot
SHELL

dd if=/dev/zero of=alpine.ext4 bs=1 count=1 seek=256M

sudo mkfs.ext4 alpine.ext4
sudo mkdir /tmp/alpine-rootfs
sudo mount alpine.ext4 /tmp/alpine-rootfs

sudo tar xzvf rootfs.tar.gz -C /tmp/alpine-rootfs

sudo umount /tmp/alpine-rootfs

sudo cp alpine.ext4 /build/out/alpine.ext4
