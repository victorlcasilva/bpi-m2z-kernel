#!/bin/sh
make ARCH=arm clean
make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- INSTALL_MOD_PATH=output -j8 m2z_lima_defconfig zImage modules modules_install dtbs
