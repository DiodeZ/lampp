FROM ubuntu:trusty
MAINTAINER DIREKTSPEED LTD

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M
RUN apt-get update 
RUN apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN rm -rf /var/lib/mysql/*
RUN a2enmod rewrite
RUN apt-get install -y phpmyadmin
RUN ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
RUN a2enconf phpmyadmin
RUN /etc/init.d/apache2 reload

# Configure /app folder with sample app
# RUN git clone https://github.com/fermayo/hello-world-lamp.git /app
# RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD apache_default /etc/apache2/sites-available/000-default.conf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh

RUN chmod 755 /*.sh

# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

EXPOSE 80 3306
CMD ["/run.sh"]
