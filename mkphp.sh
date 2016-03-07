#!/bin/sh

wget -c http://cn2.php.net/distributions/php-7.0.3.tar.bz2

if [ -f "./php-7.0.3.tar.bz2" ];then
sudo apt-get -y install build-essential
sudo apt-get -y install libjpeg62-dev libpng-dev libfreetype6-dev libxml2 libxml2-dev libapr1-dev libcurl4-openssl-dev libapr1-dev libmcrypt-dev 
tar jxvf php-7.0.3.tar.bz2

cd php-7.0.3
./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--enable-fpm \
--with-fpm-user=www-data \
--with-fpm-group=www-data \
--with-pdo-mysql \
--with-mysqli \
--with-mysql-sock=/var/run/mysqld/mysqld.sock \
--enable-opcache \
--enable-static \
--enable-inline-optimization \
--enable-sockets \
--enable-wddx \
--enable-zip \
--enable-calendar \
--enable-bcmath \
--enable-soap \
--with-zlib \
--with-iconv \
--with-gd \
--with-jpeg-dir \
--with-png-dir \
--with-vpx-dir \
--with-xmlrpc \
--enable-mbstring \
--with-curl \
--enable-ftp \
--with-mcrypt  \
--disable-ipv6 \
--disable-debug \
--with-openssl \
--disable-maintainer-zts \
--disable-fileinfo

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
echo "make php"
if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
make clean
make
sudo make install

sudo ln -s /usr/local/php/bin/php /usr/bin/php
sudo ln -s /usr/local/php/bin/phpize /usr/bin/phpize
sudo ln -s /usr/local/php/sbin/php-fpm /usr/bin/php-fpm

sudo mkdir -p /usr/local/php/etc
sudo cp php.ini-production /usr/local/php/etc/php.ini

sudo sed -i 's@expose_php = On@expose_php = Off@g' /usr/local/php/etc/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /usr/local/php/etc/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/g' /usr/local/php/etc/php.ini
#sudo sed -i 's/;date.timezone =/date.timezone = PRC/g' /usr/local/php/etc/php.ini
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/g' /usr/local/php/etc/php.ini
sudo sed -i 's/; cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/php/etc/php.ini
sudo sed -i 's/register_long_arrays = On/;register_long_arrays = On/g' /usr/local/php/etc/php.ini
sudo sed -i 's/magic_quotes_gpc = On/;magic_quotes_gpc = On/g' /usr/local/php/etc/php.ini
#sudo sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,pfsockopen,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsockopen/g' /usr/local/php/etc/php.ini
sudo sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,pfsockopen,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/php/etc/php.ini

#enable opcache
sudo sed -i '/;opcache.enable=0/i\zend_extension=opcache.so' /usr/local/php/etc/php.ini
sudo sed -i 's/;opcache.enable=0/opcache.enable=1/g' /usr/local/php/etc/php.ini
sudo sed -i 's/;opcache.enable_cli=0/opcache.enable_cli=1/g' /usr/local/php/etc/php.ini
sudo sed -i 's/;opcache.memory_consumption=64/opcache.memory_consumption=128/g' /usr/local/php/etc/php.ini
sudo sed -i 's/;opcache.interned_strings_buffer=4/opcache.interned_strings_buffer=8/g' /usr/local/php/etc/php.ini
sudo sed -i 's/;pcache.max_accelerated_files=2000/pcache.max_accelerated_files=4000/g' /usr/local/php/etc/php.ini
sudo sed -i 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=60/g' /usr/local/php/etc/php.ini
sudo sed -i 's/;opcache.fast_shutdown=0/opcache.fast_shutdown=1/g' /usr/local/php/etc/php.ini

else
echo "Get php-7.0.3.tar.bz2 error!"
fi
