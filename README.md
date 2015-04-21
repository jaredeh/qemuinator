qemuinator
==========

Scripts to make a qemu based diverse architecture build farm of Debian virtual Linux boxes to connect to Jenkins for testing your project against different Linux architectures.

Builds on the work of Aurélien Jarno (http://www.aurel32.net/) with his Debian QEMU images and the Yocto project.  Yocto is really here just to supply a build of qemu I trust with my supported architectures.  The qemu images are used directly from Aurélien's site.  I just added some wrapper scripts and some structure.

host prep

install yocto/poky build to create qemu files:
    
    apt-get install tinyproxy
    export http_proxy=http://10.0.2.2:8888
    
    apt-get update
    apt-get -y install git
    apt-get -y install build-essential fakeroot
    apt-get -y build-dep linux
    
    apt-get -y install rake
    apt-get -y install gobjc
    apt-get -y install gnustep-make
    apt-get -y install libgnustep-base-dev
    apt-get -y install autoconf automake
    apt-get -y install libtool
    
