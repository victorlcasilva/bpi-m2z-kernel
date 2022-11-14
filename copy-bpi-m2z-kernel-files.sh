#!/bin/sh

KDIR=$1
KCFGDIR=$KDIR/arch/arm/configs
KDTSDIR=$KDIR/arch/arm/boot/dts

usage() {
    echo ""
    echo "  Usage: $0 linux-kernel-folder"
    echo ""
}

checkFileExists() {
    CHECKFILE=$1
    echo "  - Checking file $CHECKFILE"
    if [ ! -f $CHECKFILE ]; then
        echo ""
        echo "  ERROR: Couldn't find file $CHECKFILE in $CURRENT_DIR"
        usage
        exit 1
    fi
}

checkFolderExists() {
    CHECKFOLDER=$1
    echo "  - Checking folder $CHECKFOLDER"
    if [ ! -d $CHECKFILE ]; then
        echo ""
        echo "  ERROR: Couldn't find folder $CHECKFOLDER"
        usage
        exit 1
    fi
}

checkLinuxKernelFolder() {
    echo "check:"
    checkFolderExists $KDIR
    checkFolderExists $KCFGDIR
    checkFolderExists $KDTSDIR
    checkFileExists $KDTSDIR/Makefile
}

applyChanges() {
    echo ""
    echo "apply:"
    cp -v build-bpi-m2z.sh $KDIR
    cp -v dist-bpi-m2z.sh $KDIR
    cp -v arch/arm/configs/m2z_minimal_defconfig $KCFGDIR
    cp -v arch/arm/configs/m2z_docker_defconfig $KCFGDIR
    cp -v arch/arm/configs/m2z_lima_defconfig  $KCFGDIR
    cp -v arch/arm/boot/dts/bpi-m2-zero-v4.dts  $KDTSDIR
    cp -v arch/arm/boot/dts/sun8i-h3-x.dtsi  $KDTSDIR
    cp -v arch/arm/boot/dts/sunxi-h3-h5-x.dtsi $KDTSDIR
    cp -v arch/arm/boot/dts/sunxi-common-regulators.dtsi  $KDTSDIR
    applyDTSPatch
}

applyDTSPatch() {
    ALREADYPATCHED=$(grep bpi-m2-zero-v4.dtb $KDTSDIR/Makefile | wc -l)
    if [ $ALREADYPATCHED -eq 1 ]; then
        echo "- Found bpi-m2-zero-v4.dtb in $KDTSDIR/Makefile, skipping patch"
    else
        patch -d $KDIR -p1 < bpi-m2z-dts.patch
    fi

}

if [ -z $1 ]; then
    usage
    exit 1
fi

checkLinuxKernelFolder
applyChanges