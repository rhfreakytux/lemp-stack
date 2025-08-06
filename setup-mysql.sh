#!/usr/bin/env bash

export DB_PASSWORD=P@ssw0rd@123

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
  dnf install @mysql expect -y 
}

#Manage Service
service_enable(){
  systemctl enable --now mysqld
}

# Update firewall rules
firewalld_policy(){
  firewall-cmd --add-service=mysql --permanent
  firewall-cmd --reload
}

# Check and enable if needed
update_firewall(){
  if [[ $(firewall-cmd --state 2>&1) == "not running" ]]; then
    systemctl enable --now firewalld && firewalld_policy
  else
    firewalld_policy
  fi
}

get_latest_version
install_mysql
service_enable
update_firewall
