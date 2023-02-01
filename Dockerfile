FROM ubuntu:22.04

ARG PHP_VERSION_DEFAULT=7.1
ARG TARGETOS_DEFAULT=lin
ARG TARGETARCH_DEFAULT=x86-64
#ARG TARGETARCH_DEFAULT=aarch64

#_lin_aarch64
#_lin_x86-64

ENV TARGETOS=${TARGETOS_DEFAULT}
ENV TARGETARCH=${TARGETARCH_DEFAULT}

ENV BUILDX_ARCH="_${TARGETOS}_${TARGETARCH}"



ENV PHP_VERSION=${PHP_VERSION_DEFAULT}


RUN apt update && apt install tzdata -y
ENV TZ="Europe/Istanbul"

RUN apt-get -y update && apt-get install -y software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2 && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get -y update

RUN apt-get install -y \
    curl \
    unzip \
    apache2 \
    php${PHP_VERSION} \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-enchant \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-gmp \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-intl \
    #php${PHP_VERSION}-ioncube_loader \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mcrypt \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-mysqlnd \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-pdo \
    #php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-sqlite3 \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-pspell \
    php${PHP_VERSION}-snmp \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-sockets \
    php${PHP_VERSION}-tidy \
    php${PHP_VERSION}-xmlreader \
    php${PHP_VERSION}-xmlrpc \
    php${PHP_VERSION}-xmlwriter \
    php${PHP_VERSION}-xsl \
    #php${PHP_VERSION}-zend_guard_loader \
    php${PHP_VERSION}-zip

RUN apt-get install -y php${PHP_VERSION}-json || true

WORKDIR /usr/lib/php/20131226/
RUN curl https://downloads.ioncube.com/loader_downloads/ioncube_loaders${BUILDX_ARCH}.tar.gz | tar -xz
RUN echo "zend_extension = \"/usr/lib/php/20131226/ioncube/ioncube_loader_lin_${PHP_VERSION}.so\"" > /etc/php/${PHP_VERSION}/apache2/conf.d/00-ioncube.ini

#RUN a2enmod php5.6
RUN a2enmod rewrite && \
    rm /var/www/html/index.html && \
    echo "<?php phpinfo(); ?>" > /var/www/html/index.php && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN sed -i "s#</VirtualHost>#\n<Directory \"/var/www/html/\">\nOptions FollowSymLinks\nAllowOverride All\nOrder allow,deny\nAllow from all\n</Directory>\n</VirtualHost>#g" /etc/apache2/sites-enabled/000-default.conf
#RUN sed -i "s%#ServerName www.example.com%ServerName hyip%g" /etc/apache2/sites-enabled/000-default.conf


RUN echo "display_errors = on\ndisplay_errors = true\ndisplay_startup_errors = true\n" > "/etc/php/${PHP_VERSION}/apache2/conf.d/50-errors.ini"

ADD entrypoint.sh /
CMD ["bash", "/entrypoint.sh"]
#ENTRYPOINT [ "/entrypoint.sh" ]
WORKDIR "/var/www/html"
EXPOSE 8000