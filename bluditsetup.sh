#!/bin/bash

DEBIAN_FRONTEND=noninteractive

echo -e "\e[96m*************************** Upgrade Packages ***************************\e[0m"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

echo -e "\e[96m*************************** Install Apache/PHP *************************\e[0m"
apt-get install -y apache2
apt-get install -y php

echo -e "\e[96m*************************** Install Extra PHP Packages *****************\e[0m"
apt-get install -y php-xml
apt-get install -y php-gd
apt-get install -y php.mbstring
apt-get install -y php-json

echo -e "\e[96m*************************** Install Misc Packages **********************\e[0m"
apt-get install -y vim
apt-get install -y unzip
apt-get install -y wget
apt-get install -y rsync

echo -e "\e[96m*************************** Install Latest Bludit **********************\e[0m"
cd /var/www/html
wget https://www.bludit.com/releases/bludit-latest.zip -O temp.zip;
unzip temp.zip 
rm temp.zip
mkdir bluditpi
rsync -a bludit-*/ bluditpi/
rm -rf bludit-*
cd ~

echo -e "\e[96m*************************** Set Permissions ****************************\e[0m"
chown -R www-data: /var/www/html
chmod g+wx -R /var/www/html

echo -e "\e[96m*************************** Enable Mod Rewrite *************************\e[0m"
a2enmod rewrite

echo -e "\e[96m*************************** Update Apache Conf *************************\e[0m"
if [ -f "/etc/apache2/sites-available/bluditpi.conf" ]; then
  rm /etc/apache2/sites-available/bluditpi.conf
fi
touch /etc/apache2/sites-available/bluditpi.conf
echo "<VirtualHost *:80>" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "	  DocumentRoot /var/www/html/bluditpi" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "	  ErrorLog ${APACHE_LOG_DIR}/error.log" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "	  CustomLog ${APACHE_LOG_DIR}/access.log combined" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "</VirtualHost>" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "<Directory /var/www/html/bluditpi>" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "    Options Indexes FollowSymLinks" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "    AllowOverride All" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "    Require all granted" |  tee -a /etc/apache2/sites-available/bluditpi.conf
echo "</Directory>" |  tee -a /etc/apache2/sites-available/bluditpi.conf
a2dissite 000-default.conf
a2ensite bluditpi.conf

echo -e "\e[96m*************************** Restart Apache *****************************\e[0m"
service apache2 restart
