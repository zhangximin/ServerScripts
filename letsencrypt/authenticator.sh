#!/bin/bash

echo $CERTBOT_VALIDATION > /var/www/html/.well-known/acme-challenge/$CERTBOT_TOKEN
