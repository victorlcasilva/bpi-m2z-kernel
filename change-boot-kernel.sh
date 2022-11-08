#!/bin/sh

usage() {
    echo "\n  Usage: $0 version [-check]\n"
}

checkFileExists() {
    CHECKFILE=$1
    if [ ! -f $CHECKFILE ]; then
        echo "\n  ERROR: Couldn't find file $CHECKFILE"
        usage
        exit 1
    fi
}

if [ -z $1 ]; then
    echo "\n  ERROR: No version specified"
    usage
    exit 1
fi

VERSION=$1

IMG=zImage_${VERSION}
LINK_IMG=zImage

DTB=bpi-m2-zero-v4.dtb_${VERSION}
LINK_DTB=bpi-m2-zero.dtb

checkFileExists $IMG
checkFileExists $DTB

if [ "$2" = "-check" ]; then
    echo "> Remove $LINK_IMG"
    echo "> Remove $LINK_DTB"
    echo "> Create symlink $LINK_IMG -> $IMG"
    echo "> Create symlink $LINK_DTB -> $DTB"
else
    echo "Updating boot kernel to version $VERSION"
    echo "Removing existing links"
    rm -f $LINK_IMG
    rm -f $LINK_DTB
    echo "Creating new links"
    ln -s $IMG $LINK_IMG
    ln -s $DTB $LINK_DTB
    echo "Done!"
fi