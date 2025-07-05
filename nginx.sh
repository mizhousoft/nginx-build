#!/bin/sh

set -e
set -u

OpenSSLVersion='openssl-3.0.17';
NginxVersion='nginx-1.26.3';
PcreVersion='pcre2-10.45';
ZlibVersion='zlib-1.3.1';

[ -f ${OpenSSLVersion}.tar.gz ] || wget --no-check-certificate https://github.com/openssl/openssl/releases/download/${OpenSSLVersion}/${OpenSSLVersion}.tar.gz
[ -f ${ZlibVersion}.tar.gz ] || wget --no-check-certificate http://zlib.net/${ZlibVersion}.tar.gz
[ -f ${PcreVersion}.tar.gz ] || wget --no-check-certificate https://github.com/PCRE2Project/pcre2/releases/download/${PcreVersion}/${PcreVersion}.tar.gz
[ -f ${NginxVersion}.tar.gz ] || wget --no-check-certificate https://nginx.org/download/${NginxVersion}.tar.gz

NGINX_PATH=/opt/mizhousoft/nginx

tar xzf $OpenSSLVersion.tar.gz
tar zxf $NginxVersion.tar.gz
tar zxf $PcreVersion.tar.gz
tar zxf $ZlibVersion.tar.gz

cd $NginxVersion

./configure --prefix=$NGINX_PATH \
	--user=mizhou --group=mizhou \
	--with-http_v2_module \
	--with-http_ssl_module \
	--with-http_gzip_static_module \
	--with-http_stub_status_module \
	--with-pcre=../$PcreVersion \
	--with-zlib=../$ZlibVersion \
	--with-openssl=../$OpenSSLVersion \
	--http-client-body-temp-path=$NGINX_PATH/temp/client_body_temp/ \
	--http-proxy-temp-path=$NGINX_PATH/temp/proxy_temp/ \
	--http-fastcgi-temp-path=$NGINX_PATH/temp/fastcgi_temp/ \
	--http-uwsgi-temp-path=$NGINX_PATH/temp/uwsgi_temp/ \
	--http-scgi-temp-path=$NGINX_PATH/temp/scgi_temp/
	
make && make install

mkdir -p ${NGINX_PATH}/temp

cp -r ../html/* ${NGINX_PATH}/html/
[ -f ${NGINX_PATH}/html/index.html ] && rm ${NGINX_PATH}/html/index.html

cp -r ../nginxconfig.io ${NGINX_PATH}/conf

$NGINX_PATH/sbin/nginx -v

$NGINX_PATH/sbin/nginx -t
