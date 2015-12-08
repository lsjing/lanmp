#!/bin/bash
#====================================================================
# MariaDB binary Installation Auto Install Script
#
# Copyright (c) 2011-2015 Junorz.com All rights reserved.
#
# Intro: http://www.junorz.com/archives/374.html
#
# 为了配合以往的习惯，以及官方文档，因此MariaDB安装在/usr/local/mysql
# 其他地方也没有特意地将MySQL换成MariaDB
#====================================================================

Install_MariaDBin(){
#解压到相应目录
echo "Extracting Mariadb.tar.gz....."
tar -zxf ~/.lanmp/resources/mariadb.tar.gz -C /usr/local
mv /usr/local/mariadb-* /usr/local/mysql

#创建运行Mariadb进程的用户
groupadd mysql
useradd -r -g mysql mysql

#使用my-medium.cnf，可以根据实际情况更改
chown -R mysql /usr/local/mysql/
cp /usr/local/mysql/support-files/my-medium.cnf /etc/my.cnf

#初始化数据库
/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
chown -R root /usr/local/mysql
chown -R mysql /usr/local/mysql/data

#开机自启动
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysqld

#设置系统库路径
echo "/usr/local/mysql/lib" >> /etc/ld.so.conf
ldconfig

#启动服务
service mysqld start

#设置管理员密码
/usr/local/mysql/bin/mysqladmin -u root password $rootpwd
}
