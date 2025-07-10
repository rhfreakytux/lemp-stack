#!/usr/bin/env bash

# Get the latest module stream number
get_latest_version(){

latest_php_stream=php:$(dnf module list php \
  | awk '/^php/ {print $2}' \
  | grep -E '^[0-9]' \
  | sort -V \
  | tail -n1)
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

get_latest_version
install_php
