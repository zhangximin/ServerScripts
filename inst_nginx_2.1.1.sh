#!/bin/sh

sudo apt-get install libxml2-dev libapr1-dev libcurl4-openssl-dev libapr1-dev libmcrypt-dev

# make tengine
wget -c http://tengine.taobao.org/download/tengine-2.1.1.tar.gz
if [ -f "./tengine-2.1.1.tar.gz" ];then

tar zxf tengine-2.1.1.tar.gz
cd tengine-2.1.1
./configure --prefix=/usr/local/nginx \
--user=www-data \
--group=www-data \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_concat_module
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
