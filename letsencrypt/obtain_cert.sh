#!/bin/bash

echo "dns_aliyun_access_key = $ali_ak" > /etc/letsencrypt/dns-aliyun-credentials.ini
echo "dns_aliyun_access_key_secret = $ali_sk" >> /etc/letsencrypt/dns-aliyun-credentials.ini

chmod 600 /etc/letsencrypt/dns-aliyun-credentials.ini;

/opt/certbot/bin/certbot certonly -a dns-aliyun \
    --dns-aliyun-credentials /etc/letsencrypt/dns-aliyun-credentials.ini \
    --non-interactive --agree-tos -m $email \
    -i nginx \
    $@