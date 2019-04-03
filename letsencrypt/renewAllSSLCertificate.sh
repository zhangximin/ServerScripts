#!/bin/bash

/bin/certbot renew --manual-auth-hook /etc/letsencrypt/authenticator.sh --manual-cleanup-hook /etc/letsencrypt/cleanup.sh

systemctl restart httpd.service

# git
scp /etc/letsencrypt/live/tiertime.net/privkey.pem simon@git.tiertime.net:~
scp /etc/letsencrypt/live/tiertime.net/fullchain.pem simon@git.tiertime.net:~
ssh -t simon@git.tiertime.net "sudo /var/opt/gitlab/renewSSLCertificate.sh"

# svn
scp /etc/letsencrypt/live/tiertime.net/privkey.pem simon@svn.tiertime.net:~
scp /etc/letsencrypt/live/tiertime.net/fullchain.pem simon@svn.tiertime.net:~
ssh -t simon@svn.tiertime.net "sudo /srv/svn/renewSSLCertificate.sh"



##sudo certbot certonly --manual --installer apache -d *.tiertime.net --pre-hook "systemctl stop httpd" --post-hook "systemctl start httpd" -w /var/www/html --server=https://acme-v02.api.letsencrypt.org/directory

##sudo certbot certonly --server https://acme-v02.api.letsencrypt.org/directory --manual --preferred-challenges dns -d 'tiertime.net,*.tiertime.net'

