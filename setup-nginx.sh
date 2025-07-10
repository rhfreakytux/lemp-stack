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

#Manage Service
service_enable(){
  systemctl enable --now nginx
}

#Update firewall
firewalld_policy(){
  firewall-cmd --add-service={http,https} --permanent
  firewall-cmd --reload
}

update_firewall(){
  if [[ $(firewall-cmd --state > /dev/null) == "not running" ]]; then 
    systemctl enable --now firewalld && firewalld_policy 
  else 
    firewalld_policy 
  fi
}

# Calling the function in sequence
get_latest_version
install_nginx
service_enable
update_firewall
