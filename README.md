# nginx-build
build nginx


# 证书加密命令
openssl rsa -aes256 -in site.key -out site.sec.key


# 增加用户

useradd -r -s /sbin/nologin -d /opt/middleware/nginx nginx

mkdir -p /opt/middleware/nginx
chown -R nginx:nginx /opt/middleware/nginx
chown -R nginx:nginx /opt/middleware/nginx

