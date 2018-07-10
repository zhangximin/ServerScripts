#!/bin/bash

/bin/certbot renew --manual-auth-hook /etc/letsencrypt/authenticator.sh --manual-cleanup-hook /etc/letsencrypt/cleanup.sh

scp /etc/letsencrypt/live/tiertime.net/privkey.pem simon@192.168.1.25:~
scp /etc/letsencrypt/live/tiertime.net/fullchain.pem simon@192.168.1.25:~

ssh -t simon@192.168.1.25 "sudo /var/opt/gitlab/renewSSLCertificate.sh"
