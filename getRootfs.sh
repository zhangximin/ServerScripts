#!/bin/bash

fstring=`date "+%Y%m%d%H%M%S%N"`

sudo tar -I pbzip2 -cvf uos_loongson_${fstring}.tar.bz2 --exclude={/data,/recovery,/backup*,/dev,/home,/lost+found,/media,/mnt,/mnt2,/proc,/run,/sys,/tmp,/var/tmp,/var/lib/lxcfs,/var/lib/lxd/unix.socket,/var/log} / 


if [ -f uos_loongson_${fstring}.tar.bz2 ];then
    sudo chown ${USER}:${USER} uos_loongson_${fstring}.tar.bz2
    split -b 500M uos_loongson_${fstring}.tar.bz2 uos_loongson_${fstring}.tar.bz2.p
fi

echo "All Done."
