#!/bin/sh

sudo apt-get install libxml2-dev libcurl4-openssl-dev libapr1-dev libmcrypt-dev libjpeg62-dev

# google PageSpeed for nginx.
sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev unzip
NPS_VERSION=1.11.33.3
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -O release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz  # extracts to psol/

# make tengine
TENGIN_VERSION=2.1.1
wget -c http://tengine.taobao.org/download/tengine-2.1.1.tar.gz
tar zxf tengine-${TENGIN_VERSION}.tar.gz
cd tengine-${TENGIN_VERSION}
./configure --prefix=/usr/local/nginx \
--user=www-data \
--group=www-data \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_concat_module \
--add-module=../ngx_pagespeed-release-${NPS_VERSION}-beta
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
    make install

# make nginx startup script
wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
chmod +x /etc/init.d/nginx
service nginx status  # to poll for current status
sudo update-rc.d -f nginx defaults

else
echo "Error get tengine-2.1.1.tar.gz"
fi
