#!/bin/bash

HOSTNAME=`hostname`
APP_IP=`/sbin/ifconfig eth0| grep 'inet addr:' | awk {'print $2'}| cut -d ':' -f 2`

echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf

echo "********************************************
PHP 7 is ready for use

Your application is available at http://$APP_IP

********************************************

"
tail -F /var/log/apache2/* &
exec apache2ctl -D FOREGROUND
