#!/bin/bash
#Welcome http://www.junorz.com


# 检查是否为管理员
if [ $(id -u) != "0" ]; then
    echo "Please login as root to run this script"
    exit 1
fi

#创建运行Apache的用户
groupadd www
useradd -s /sbin/nologin -g www www

#下载编译
cd /root
wget http://source.ocha.so/httpd.tar.gz
tar -zxf httpd*
cd httpd*
./configure --prefix=/usr/local/apache \
--with-apr=/usr/local/apr/bin/apr-1-config \
--with-apr-util=/usr/local/apr-util/bin/apu-1-config \
--enable-so \
--enable-rewrite \
--enable-ssl \
--enable-mods-shared=all \
--enable-expires \
--with-mpm=prefork
make && make install

#配置httpd.conf文件
sed -i "s/User daemon/User www/g" /usr/local/apache/conf/httpd.conf
sed -i "s/Group daemon/Group www/g" /usr/local/apache/conf/httpd.conf
sed -i "s/#ServerName www.example.com:80/ServerName localhost/g" /usr/local/apache/conf/httpd.conf
sed -i "2 a #chkconfig:345 85 15" /usr/local/apache/bin/apachectl
sed -i "3 a #description:httpd" /usr/local/apache/bin/apachectl

#添加服务
cp /usr/local/apache/bin/apachectl /etc/init.d/httpd
chkconfig --add httpd
service httpd start

cd /root

echo "========================================================================="
echo "Apache已安装完成，请运行其他安装脚本 Script Written by Junorz.com"
echo "========================================================================="
