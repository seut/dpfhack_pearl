#!/bin/bash
#
# derived copy of: http://forum.doozan.com/read.php?9,2435,9321#msg-9321 
#
# very crude script that pulls everything together and installs
# build 1184 of lcd4linux with mpd plugin and patch for scaleable fonts
# does not build firmware for hacking dpf-ax206 frame, only libdpf library

PREREQUISITES='pkg-config aclocal automake autoconf'

for i in $PREREQUISITES; do
        if [ -z `which $i` ]; then
                echo missing tool "'$i'". Please install package.
                err=1
        fi
done

if [ $err ]; then
        echo "Error, cancelling"
        exit
fi

# download and untar dpf-ax tools
wget https://sourceforge.net/projects/dpf-ax/files/dpf-ax_20151118.tgz/download -O dpf-ax_20151118.tgz
tar xzf dpf-ax_20151118.tgz
cd dpf-ax

# this part takes for a while on dockstar, aside from building custom
# firmware for your dpf, it is needed to build libdpf library and module
make

# patch files for mpd plugin and scaled fonts for dpf
patch -p1 < ../dpflib_python_lcd4linux.patch

# Run lcd4linux installation script
# The lcd4linux installation script from dpf-ax package is configured such that it installs DPF driver only.
# If you are running multiple displays on your dosckstar, you will need to comment out last script call below
# and edit build-dpf-lcd4linux.sh sript so that it configures build with all drivers.

# around line 49 of build-dpf-lcd4linux.sh sript
# change from
# ./configure --with-drivers=DPF
# to:
# ./configure --with-drivers=all
# and then run build-dpf-lcd4linux.sh manually.

red='\033[31m'
yellow='\033[33m'
NC='\e[0m' # No Color


./build-dpf-lcd4linux.sh

