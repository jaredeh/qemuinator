#!/bin/bash
# invoke with $1 set to destination for qemu binaries
mkdir -p tmp_poky
cd tmp_poky
git clone git://git.yoctoproject.org/poky.git
cd poky
git checkout dylan
source oe-init-build-env
bitbake core-image-minimal
echo mv tmp/sysroots/x86_64-linux/usr/ $1
cd ../../../
rm -rf tmp_poky