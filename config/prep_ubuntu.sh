#!/bin/bash

#yocto build deps
apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath libsdl1.2-dev xterm

#allows host to serve as http proxy for qemu VM's
apt-get -y install tinyproxy

#we use screen to host qemu VM's
apt-get -y install screen

