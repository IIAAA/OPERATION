#!/bin/bash
yum -y install httpd-tools
cd /usr/local/nginx/conf
openssl genrsa > cert.key
openssl req -new -x509 -key cert.key > cert.pem
sed -i ''
