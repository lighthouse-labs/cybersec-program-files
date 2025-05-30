#!/bin/bash
# DVWA Dependencies
echo "Installing Dependencies"
sudo apt update
#sudo apt install -y apache2 mariadb-server mariadb-client php php-mysqli php-gd libapache2-mod-php
sudo apt install -y apache2 mysql-server-8.0 mysql-client-8.0 php php-mysqli php-gd libapache2-mod-php
sudo apt install -y git

# DVWA Download and Install
echo "Pulling DVWA"
sudo mkdir -p /opt/DVWA
sudo chown student:student /opt/DVWA
cd /opt/DVWA
git clone https://github.com/digininja/DVWA.git .
cp ./config/config.inc.php.dist ./config/config.inc.php
echo "Installing DVWA's webroot"
sudo mkdir -p /var/www/dvwa
sudo cp -r /opt/DVWA/* /var/www/dvwa/
sudo chown www-data /var/www/dvwa/hackable/uploads
sudo chown www-data /var/www/dvwa/config
sudo sed -i 's/allow_url_include = Off/allow_url_include = On/' /etc/php/8.1/apache2/php.ini

echo "Creating DB"
# DVWA Database Creation
sudo mysql -e "create database dvwa"

## Added to allow MySQL8 setup
sudo mysql -e "SET GLOBAL validate_password.policy=LOW"

sudo mysql -e "create user dvwa@localhost identified by 'p@ssw0rd'"
sudo mysql -e "grant all on dvwa.* to dvwa@localhost"
sudo mysql -e "flush privileges"

## Added to allow MySQL8 setup
sudo mysql -e "SET GLOBAL validate_password.policy=MEDIUM"

echo "Adding DVWA to Apache"
cat << HERE >dvwa.conf
<VirtualHost *:80>
ServerName dvwa.localhost
ServerAdmin webmaster@localhost
        DocumentRoot /var/www/dvwa
ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
HERE
#IntOut=`ip route | grep default | awk '{print $5}'`
#IPOut=`ip addr show $IntOut | grep -oP '(?<=inet\s)(\d+\.\d+\.\d+\.\d+)'`
echo "127.0.0.1            dvwa.localhost"|sudo tee -a /etc/hosts
sudo cp dvwa.conf /etc/apache2/sites-available/
sudo a2ensite dvwa
sudo systemctl restart apache2

# Changing folder permissions
sudo chown -R www-data:www-data /var/www/dvwa
echo "DONE!"
