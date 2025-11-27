#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git mysql-client -y

sudo apt-get install openjdk-11-jdk -y

# Install Tomcat 9 لانه افضل اصدار لنسخة جافا Legacy: javax
sudo apt-get install tomcat9 tomcat9-admin -y

sudo systemctl stop tomcat9
sudo rm -rf /var/lib/tomcat9/webapps/ROOT
sudo rm -rf /var/lib/tomcat9/webapps/ROOT.war

cd /tmp
git clone -b sourcecodeseniorwr https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project

mysql -h ${db_host} -u ${db_user} -p${db_pass} accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql

sudo systemctl start tomcat9
