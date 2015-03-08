#!/bin/bash
#====================================================================
# Apache Auto Install Script
#
# Copyright (c) 2011-2015 Junorz.com All rights reserved.
# 
# Intro: http://www.junorz.com/archives/374.html
#
#====================================================================

# 检查是否为管理员
if [ $(id -u) != "0" ]; then
    echo "Please login as root to run this script"
    exit 1
fi

#自定义Nginx版本
#版本号参照http://nginx.org/en/download.html
echo "The version of Nginx can be referenced to http://nginx.org/en/download.html"
read -p "Enter the version you want to install(1.6.2 by deafult):" vernginx
if [ "$vernginx" = "" ]; then
	vernginx="1.6.2"
fi
read -p "Do you want to install Nginx $vernginx?[Y/N]" ifinstall
if [ "$ifinstall" = "Y" ] || [ "$ifinstall" = "y" ] || [ "$ifinstall" = "" ]; then
	#创建运行Nginx进程的用户
	groupadd www
	useradd -s /sbin/nologin -g www www

	#避免系统找不到PCRE等库
	export LD_LIBRARY_PATH=/usr/local/lib
	
	cd /root
	wget -O nginx.tar.gz http://nginx.org/download/nginx-$vernginx.tar.gz
	tar -zxf nginx.tar.gz
	cd /root/nginx*
	./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6
	make && make install
else
	echo "Installation interrupted.Try to run this script again."
	exit 1
fi

#软链接以便命令行直接调用
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

#启动Nginx请直接在命令行输入nginx
#停止Nginx请直接在命令行输入nginx -s stop
#重新载入nginx.conf请直接在命令行输入nginx -s reload

#加入开机自启动，如果不需要自在/etc/rc.d/rc.local文件里删除相应命令
echo "/usr/bin/nginx" >> /etc/rc.d/rc.local

#启动Nginx
/usr/bin/nginx

echo "==========================================="
echo "脚本已运行完成 Script Written by Junorz.com"
echo "==========================================="