#!/bin/sh

DIST_DIR=output
CFG=.config
IMAGE=arch/arm/boot/Image
KERNEL=arch/arm/boot/zImage
DTB=arch/arm/boot/dts/bpi-m2-zero-v4.dtb
KV=$(strings arch/arm/boot/Image | grep "Linux version" -m 1 | awk '{print $3}')

if [ -z $KV ]; then
    echo "\n  ERROR: No kernel version identified"
    exit 1
fi

MODULES=$DIST_DIR/lib/modules/${KV}
OUT_CFG=config_${KV}
OUT_KERNEL=zImage_${KV}
OUT_DTB=bpi-m2-zero-v4.dtb_${KV}

DIST_BOOT=boot-${KV}.tar.gz
DIST_MODULES=modules-${KV}.tar.gz

checkFileExists() {
    F_PATH=$1
    echo "- Checking file $F_PATH"
    if [ ! -f $F_PATH ]; then
        echo "\n  ERROR: Couldn't find file $F_PATH"
        exit 1
    fi
}

checkDirExists() {
    F_PATH=$1
    echo "- Checking directory $F_PATH"
    if [ ! -d $F_PATH ]; then
        echo ""
        echo "  ERROR: Couldn't find directory $F_PATH"
        echo ""
        exit 1
    fi
}

checkFiles() {
    checkFileExists $CFG
    checkFileExists $IMAGE
    checkFileExists $KERNEL
    checkFileExists $DTB
    checkDirExists $MODULES
}

prepareBootFiles() {
    cp $CFG $DIST_DIR/$OUT_CFG
    cp $KERNEL $DIST_DIR/$OUT_KERNEL
    cp $DTB $DIST_DIR/$OUT_DTB
}

clearOutput() {
    rm -f $DIST_DIR/$OUT_CFG
    rm -f $DIST_DIR/$OUT_KERNEL
    rm -f $DIST_DIR/$OUT_DTB
}

clearGeneratedOutput() {
    if [ -f $DIST_DIR/$DIST_BOOT ]; then
        echo "- Removing previously generated file $DIST_DIR/$DIST_BOOT"
        rm -f $DIST_DIR/$DIST_BOOT
    fi
    if [ -f $DIST_DIR/$DIST_MODULES ]; then
        echo "- Removing previously generated file $DIST_DIR/$DIST_MODULES"
        rm -f $DIST_DIR/$DIST_MODULES
    fi
}

buildOutputBoot() {
    echo "- Creating $DIST_DIR/$DIST_BOOT"
    tar -pczf $DIST_DIR/$DIST_BOOT -C $DIST_DIR $OUT_CFG $OUT_KERNEL $OUT_DTB
}

buildOutputModules() {
    echo "- Creating $DIST_DIR/$DIST_MODULES"
    tar -pczf $DIST_DIR/$DIST_MODULES -C $DIST_DIR/lib/modules $KV
}

echo ""
echo "  Build version: $KV"
echo ""
checkFiles
echo ""

clearGeneratedOutput
echo ""

clearOutput
prepareBootFiles
buildOutputBoot
buildOutputModules
clearOutput

echo ""