#!/bin/sh

CONFIG=m2z_lima_defconfig

if [ "$1" = "docker" ]; then
    CONFIG=m2z_docker_defconfig
fi

BUILDTIMESTAMP=$(date +%Y%m%d)

rm -rf output
make ARCH=arm clean
make ARCH=arm LOCALVERSION=-$BUILDTIMESTAMP CROSS_COMPILE=arm-none-eabi- INSTALL_MOD_PATH=output -j8 $CONFIG zImage modules modules_install dtbs

sh dist-bpi-m2z.sh