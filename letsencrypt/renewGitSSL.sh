#!/bin/bash

if [ -s /home/simon/privkey.pem ];then
	mv /home/simon/privkey.pem /etc/gitlab/ssl/
fi

if [ -s /home/simon/fullchain.pem ];then
	mv /home/simon/fullchain.pem /etc/gitlab/ssl/
fi

/usr/bin/gitlab-ctl restart
