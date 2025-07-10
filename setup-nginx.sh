#!/usr/bin/env bash

# Get the latest module stream number
get_latest_version(){
latest_nginx_stream=nginx:$(dnf module list nginx \
  | awk '/^nginx/ {print $2}' \
  | grep -E '^[0-9]' \
  | sort -V \
  | tail -n1)
}

#Install Nginx
install_nginx(){
  dnf module disable nginx -y 
  dnf module enable "$latest_nginx_stream" -y 
  dnf module install nginx -y 
}

get_latest_version
install_nginx
