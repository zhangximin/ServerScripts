#!/bin/bash

/bin/certbot renew --manual-auth-hook /etc/letsencrypt/authenticator.sh --manual-cleanup-hook /etc/letsencrypt/cleanup.sh

systemctl restart httpd.service

# git
scp /etc/letsencrypt/live/tiertime.net/privkey.pem simon@192.168.1.25:~
scp /etc/letsencrypt/live/tiertime.net/fullchain.pem simon@192.168.1.25:~
ssh -t simon@192.168.1.25 "sudo /var/opt/gitlab/renewSSLCertificate.sh"

# svn
scp /etc/letsencrypt/live/tiertime.net/privkey.pem simon@192.168.1.26:~
scp /etc/letsencrypt/live/tiertime.net/fullchain.pem simon@192.168.1.26:~
ssh -t simon@192.168.1.26 "sudo /srv/svn/renewSSLCertificate.sh"



##sudo certbot certonly --manual --installer apache -d *.tiertime.net --pre-hook "systemctl stop httpd" --post-hook "systemctl start httpd" -w /var/www/html --server=https://acme-v02.api.letsencrypt.org/directory

##sudo certbot certonly --server https://acme-v02.api.letsencrypt.org/directory --manual --preferred-challenges dns -d 'tiertime.net,*.tiertime.net'

