#!/bin/sh

#curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
#curl -fsSL -o hello-rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4

INSTALLER=$1

cp -R /builder/workdir .workdir
rm .workdir/Meowfile

sudo ./alpine-make-rootfs \
  --branch 'latest-stable' \
  --packages 'openrc util-linux rng-tools' \
  --script-chroot \
  rootfs.tar.gz - <<SHELL
    ln -s agetty /etc/init.d/agetty.ttyS0
    echo ttyS0 > /etc/securetty
    echo 'nameserver 1.1.1.1' > /etc/resolv.conf
    rc-update add agetty.ttyS0 default
    rc-update add devfs boot
    rc-update add procfs boot
    rc-update add sysfs boot
    rc-update add rngd default
    
    cd .workdir
    ${INSTALLER}
SHELL


dd if=/dev/zero of=alpine.ext4 bs=1 count=1 seek=500M

sudo mkfs.ext4 alpine.ext4
sudo mkdir /tmp/alpine-rootfs
sudo mount alpine.ext4 /tmp/alpine-rootfs

sudo tar xzvf rootfs.tar.gz -C /tmp/alpine-rootfs

sudo umount /tmp/alpine-rootfs

sudo cp alpine.ext4 /builder/out/alpine.ext4
