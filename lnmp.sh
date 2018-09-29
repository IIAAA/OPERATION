#!/bin/bash
yum -y install gcc openssl-devel pcre-devel zlib-devel
cd /root
tar -xf lnmp_soft.tar.gz
cd lnmp_soft/
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2/
useradd nginx
./configure --with-http_ssl_module
make & make install
yum -y install mariadb-server mariadb-devel
yum -y install php php-mysql
cd /root/lnmp_soft/
rpm -ivh php-fpm-5.4.16-42.el7.x86_64.rpm
sed -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '45s/.*/index index.php index.html index.htm;/' /usr/local/nginx/conf/nginx.conf
sed -i '69s/^/#/' /usr/local/nginx/conf/nginx.conf
sed -i '70s/fastcgi_params/fastcgi.conf/' /usr/local/nginx/conf/nginx.conf
systemctl stop httpd
/usr/local/nginx/sbin/nginx
systemctl restart mariadb
systemctl enable mariadb
systemctl restart php-fpm
systemctl enable php-fpm
