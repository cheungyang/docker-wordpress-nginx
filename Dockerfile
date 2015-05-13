FROM cheungyang/docker-nginx-php

ENV WWW_ROOT            /var/www/wordpress
ENV WWW_BASE_ROOT       /var/www

# === Change these at child Dockerfiles === 
ENV DEFAULT_SERVER_HOSTNAME localhost
ENV MYSQL_ROOT_USER     root
ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_USER          wordpress
ENV MYSQL_PASSWORD      wordpress
ENV MYSQL_DATABASE_NAME wordpress

EXPOSE 80


# Install Wordpress
ADD http://wordpress.org/latest.tar.gz /tmp/
RUN cd /tmp && tar xvf latest.tar.gz && rm latest.tar.gz
RUN chown -R www-data:www-data /tmp/wordpress
RUN mkdir -p $WWW_BASE_ROOT
RUN mv /tmp/wordpress $WWW_BASE_ROOT

# Download wp-cli (http://wp-cli.org/)
ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /tmp/
RUN chmod +x /tmp/wp-cli.phar
RUN mv /tmp/wp-cli.phar /usr/local/bin/wp

# SiteUrl plugin to override siteurl in wp_options table
ADD ./scripts/siteurl.php $WWW_ROOT/wp-content/plugins/
RUN chown www-data:www-data $WWW_ROOT/wp-content/plugins/siteurl.php


#TODO: handled wp-content


# nginx site conf
ADD ./conf/wordpress-default.conf /etc/nginx/sites-available/default
RUN sed -i -e "s/%DEFAULT_SERVER_HOSTNAME%/$DEFAULT_SERVER_HOSTNAME/g" /etc/nginx/sites-available/default
## note: using ',' instead of '/' as $WWW_ROOT contains slashes and will make the sed argument invalid
RUN sed -i -e "s,%WWW_ROOT%,$WWW_ROOT,g" /etc/nginx/sites-available/default


# Startup script
ADD ./scripts/wordpress-start /usr/local/bin/wordpress-start
RUN chmod 755 /usr/local/bin/wordpress-start


CMD ["wordpress-start"]