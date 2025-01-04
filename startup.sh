#! /bin/sh

if test -f "/data/.DONOTDEL"; then
    ln -s /data/plugins /var/www/upload/include/plugins
    ln -s /data/ost-config.php /var/www/upload/include/ost-config.php
    exec mysqld_safe --datadir=/data/mysql &
else
    mkdir /data/plugins
    ln -s /data/plugins /var/www/upload/include/plugins
    cp /var/www/upload/include/ost-sampleconfig.php /data/ost-config.php
    ln -s /data/ost-config.php /var/www/upload/include/ost-config.php
    echo "This file is used to check if the containers data directory exists, do not delete!" > /data/.DONOTDEL

    mkdir /data/mysql
    mysql_install_db --user=mysql --datadir=/data/mysql
    exec mysqld_safe --datadir=/data/mysql &
    sleep 2
    echo "CREATE DATABASE osticket;" | mysql -u root
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'securepassword';" | mysql -u root
fi