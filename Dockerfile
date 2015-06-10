#vim:set ft=dockerfile:
FROM centos:7.1.1503

MAINTAINER Crakmedia <docker@crakmedia.com>

# PHP5 Stack and nginx
RUN yum -y install epel-release yum-utils && \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php56,remi && \
    yum -y update && \
    yum -y install php-fpm php-mysql php-mcrypt php-curl php-cli php-gd php-pgsql php-pdo \
           php-common php-json php-pecl-redis php-pecl-memcache nginx python-pip && \
    yum clean all

# Supervisor config
RUN /usr/bin/pip install supervisor supervisor-stdout

# Expose Ports
EXPOSE 80
EXPOSE 443

ADD ./docker/conf.d /etc/nginx/conf.d
ADD ./docker/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/php.ini /etc/php.ini
ADD ./docker/php-fpm.conf /etc/php-fpm.conf
ADD ./docker/php-fpm.d /etc/php-fpm.d
ADD ./docker/supervisord.conf /etc/supervisord.conf

# Volumes
VOLUME /var/log
VOLUME /var/lib/php/session

CMD ["/usr/bin/supervisord", "-n"]