#!/bin/bash
# invoke with $1 set to destination for qemu binaries
mkdir -p $1/tmp_poky
cd $1/tmp_poky
git clone git://git.yoctoproject.org/poky.git
cd $1/tmp_poky/poky
git checkout dylan
source oe-init-build-env
bitbake core-image-minimal
mv tmp/sysroots/x86_64-linux/usr/ $1
cd $1
rm -rf $1/tmp_poky