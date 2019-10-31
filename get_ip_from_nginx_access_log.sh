#!/bin/bash

#1.make dir: mkdir -p ~/temp/
#2.grep "Android" and before " - -" is ip.

badiplogs="/tmp/bad_ips.log"

#sudo tail -f /var/log/nginx/access.log|grep --line-buffered Android|grep --line-buffered community|grep --line-buffered -oP '.*?(?=\ \-\ \-)' >> $badiplogs

if [ -s $badiplogs ];then

fi
