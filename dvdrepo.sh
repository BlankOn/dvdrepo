#!/bin/bash

DIST=$1
ARCH=$2

function usage() {
   echo "$0 DIST ARCH"
   exit
}

if [ -z $DIST ];then
   usage
fi

if [ -z $ARCH ];then
   usage
fi

cd ~/dvdrepo
debpartial --nosource --dirprefix=$DIST-$ARCH- --arch=$ARCH --section=main,restricted,extras,extras-restricted --dist=$DIST  --size=DVD  ~/repo/blankon/ ~/dvdrepo/parts

DISTARCH=$DIST-$ARCH
NUM=`ls --color=never ~/dvdrepo/parts | grep --color=never $DISTARCH| wc -l`
ID=1

mkdir -p ~/dvdrepo/results
for i in `ls --color=never ~/dvdrepo/parts | grep --color=never $DISTARCH`;do
   echo "Copying set $ID of $NUM"
   ~/dvdrepo/debcopy -l ~/repo/blankon ~/dvdrepo/parts/$i
   echo "Creating ISO $ID of $NUM"
   mkisofs -f -J -r -V "BlankOn $DIST $ARCH $ID/$NUM" -o ~/dvdrepo/results/$DISTARCH.$(date -I)-dvd-$ID.iso ~/dvdrepo/parts/$i
   rm -rf ~/dvdrepo/parts/$i
   ID=$(($ID+1))
done

pushd ~/dvdrepo/results
md5sum * > $DISTARCH.$(date -I)-MD5SUM.txt
popd
