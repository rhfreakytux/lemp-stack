#!/usr/bin/env bash

# Get the latest module stream number
get_latest_version(){
latest_mysql_stream=mysql:$(dnf module list mysql \
  | awk '/^mysql/ {print $2}' \
  | grep -E '^[0-9]' \
  | sort -V \
  | tail -n1)
}

#Installing MySQL
install_mysql(){
  dnf module disable mysql -y 
  dnf module enable "$latest_mysql_stream" -y
  dnf install @mysql -y 
}

#Manage Service
service_enable(){
  systemctl enable --now mysqld
}

#Update firewall
update_firewall(){
  firewall-cmd --add-service=mysql --permanent
  firewall-cmd --reload
}

get_latest_version
install_mysql
service_enable
update_firewall
