FROM    ubuntu:16.04

ARG NGINX_CONFIG=nginx

#######################
# Update applications #
#######################

RUN     apt update -y \
        && apt upgrade -y \

########################
# Install applications #
########################

        && apt install -y \
            software-properties-common \
            python-software-properties \
            curl \
            git \
            nano \
            wget \
            sshpass \

####################
# Add repositories #
####################

        && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
        && apt update -y \

##############################
# Install Nginx, PHP , MySQL #
##############################

        && echo 'mysql-server mysql-server/root_password password pass' | debconf-set-selections \
        && echo 'mysql-server mysql-server/root_password_again password pass' | debconf-set-selections \

        && apt install -y \
            nginx \
            mysql-server \
            mysql-client \
            php7.2 \
            php7.2-cli \
            php7.2-cgi \
            php7.2-curl \
            php7.2-common \
            php7.2-fpm \
            php7.2-gd \
            php7.2-json \
            php7.2-mbstring \
            php7.2-mysql \
            php7.2-xml \
            php7.2-zip \

##############################
# Composer, NPM, Grunt, Robo #
##############################

        && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
        && apt install -y \
            nodejs \
            composer \

        && npm install -g \
            grunt \

        && wget http://robo.li/robo.phar \
        && chmod +x robo.phar \
        && mv robo.phar /usr/bin/robo \

###########################################
# Redirect application logs to dev output #
###########################################

        && ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log \

########################
# Create web directory #
########################

	    && mkdir /www

############################
# Copy configuration files #
############################

COPY    ./nginx/${NGINX_CONFIG}.conf /etc/nginx/sites-available/default

COPY    ./mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
COPY    ./mysql/setup.sql /root/setup.sql

###################
# Configure mysql #
###################

RUN     usermod -d /var/lib/mysql/ mysql \
        && chown -R mysql: /var/lib/mysql/ \

        && service mysql start \
        && mysql --user=root --password=pass < /root/setup.sql \
        && rm /root/setup.sql \
        && service mysql stop

#########################
# Configure stop signal #
#########################

STOPSIGNAL SIGTERM

################
# Expose ports #
################

EXPOSE  80 3306

###############################
# Configure working directory #
###############################

WORKDIR /www

################################
# Configure entrypoint command #
################################

CMD     echo "Starting up container" \

        && echo "Configuring www-data user" \
        && usermod -d /www/ www-data \
        && echo "Settings up permissions for www-data user" \
        && chown -R www-data: /www/ \

        && echo "Configuring mysql user" \
        && usermod -d /var/lib/mysql/ mysql \
        && echo "Settings up permissions for mysql user" \
        && chown -R mysql: /var/lib/mysql/ \

        && echo "Starting PHP" \
        && service php7.2-fpm start >> /dev/null \

        && echo "Starting MySQL" \
        && service mysql start >> /dev/null \

        && echo "Starting Nginx and waiting for connection" \
        && nginx -g 'daemon off;'
