#!/bin/bash
# chown www-data:www-data /var/www/ -R

if [ "$ALLOW_OVERRIDE" = "False" ]; then
    unset ALLOW_OVERRIDE
else
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    a2enmod rewrite
fi

if [[ -d "/var/www/public" && !(-L "/var/www/html" || -d "/var/www/html") ]]; then
  ln -s /var/www/public /var/www/html
fi

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
