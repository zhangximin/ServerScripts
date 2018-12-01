#!/bin/bash

echo "Take Screenshot Capture in a file named with current datetime."

DATE=`date '+%Y%m%d%H%M%S'`

if [ ! -f /usr/bin/import ];then
	sudo apt-get install imagemagick
fi	
/usr/bin/import -display :0 -window root ${DATE}.png

echo "Saved as ${DATE}.png"
