# --------------------------------------------------------------------
# | Usage Rec:
# | docker run --name web-app --publish 8080:80 --volume $(pwd):/var/www/html --detach payam/apache-php7
# |
# | 
# | 
# |

FROM ubuntu:latest

MAINTAINER Payam Naderi <naderi.payam@gmail.com>

# Install base packages
## install python-software-properties package on your system which 
## provides add-apt-repository command then use the following set of 
## commands to add PPA for PHP 7 in your Ubuntu system and install it
RUN apt-get install -yq software-properties-common && \
	add-apt-repository ppa:ondrej/php && \
	add-apt-repository ppa:ondrej/apache2 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
		php7.0
        apache2 \
        libapache2-mod-php7.0 \
        php7.0-mysql \
        php7.0-curl \
        php7.0-json \
        php-pear \
        php-apc && \
    rm -rf /var/lib/apt/lists/*
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

# Default Configuration
ENV ALLOW_OVERRIDE True ## enable mod_rewrite/AllowOverride

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure www/html folder with sample app
RUN rm -rf /var/www && \
    mkdir /var/www
# Copy default/php test content
COPY www/ /var/www 
VOLUME /var/www

EXPOSE 80
CMD ["/run.sh"]

