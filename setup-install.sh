#!/usr/bin/env bash

# Get the latest module stream number
get_latest_version(){
latest_nginx_stream=$(dnf module list nginx \
  | awk '/^nginx/ {print $2}' \
  | grep -E '^[0-9]' \
  | sort -V \
  | tail -n1)

latest_php_stream=$(dnf module list php \
  | awk '/^php/ {print $2}' \
  | grep -E '^[0-9]' \
  | sort -V \
  | tail -n1)


latest_mysql_stream=$(dnf module list mysql \
  | awk '/^mysql/ {print $2}' \
  | grep -E '^[0-9]' \
  | sort -V \
  | tail -n1)
}

# Disabled the default enabled module and enabled the latest module number and then did installation
#
# Installing Nginx Function
install_nginx(){
  dnf module disable nginx -y 
  dnf module enable "$latest_nginx_stream" -y 
  dnf module install nginx -y 
}

#Installing PHP Function
install_php(){
  dnf module disable php -y 
  dnf module enable "$latest_php_stream" -y 
  dnf install --setopt=install_weak_deps=False \
    php php-common php-cli \
    php-fpm php-mbstring php-opcache \
    php-pdo php-xml php-gd \
    php-mysqlnd mailcap libxslt -y
}

#Installing MySQL Function
install_mysql(){
  dnf module disable mysql -y 
  dnf module enable "$latest_mysql_stream" -y
  dnf install @mysql -y 
}

get_latest_version
install_nginx
install_php
install_mysql
