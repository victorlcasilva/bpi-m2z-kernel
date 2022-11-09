#!/bin/sh

usage() {
    echo "\n  Usage: $0 kernelVersion [-check]\n"
}

checkFileExists() {
    CHECKFILE=$1
    echo "  - Checking file $CHECKFILE"
    if [ ! -f $CHECKFILE ]; then
        echo "\n  ERROR: Couldn't find file $CHECKFILE in $CURRENT_DIR"
        usage
        exit 1
    fi
}

removeExistingSymLinks() {
    SYMLINK=$1
    if [ -f $SYMLINK ]; then
        if [ -z $READONLY ]; then
            echo "  - Remove existing symlink $SYMLINK"
            rm -f $SYMLINK
        else
            echo "  - Should remove existing symlink $SYMLINK"
        fi
    fi
}

createSymLink() {
    SYMLINK=$1
    SYMTARGET=$2
    if [ -z $READONLY ]; then
        echo "  - Creating symlink $SYMLINK -> $SYMTARGET"
        ln -s $SYMTARGET $SYMLINK
    else
        echo "  - Should create symlink $SYMLINK -> $SYMTARGET"
    fi
}

if [ -z $1 ]; then
    usage
    exit 1
fi

if [ "$2" = "-check" ]; then
    READONLY=1
fi

VERSION=$1

IMG=zImage_${VERSION}
LINK_IMG=zImage

DTB=bpi-m2-zero-v4.dtb_${VERSION}
LINK_DTB=bpi-m2-zero.dtb

CURRENT_DIR=$(pwd)

echo "check:"
checkFileExists $IMG
checkFileExists $DTB

echo "\nupdate:"
removeExistingSymLinks $LINK_IMG
removeExistingSymLinks $LINK_DTB
createSymLink $LINK_IMG $IMG
createSymLink $LINK_DTB $DTB
