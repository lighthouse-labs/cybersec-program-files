#!/bin/bash
osTicketVer=v1.18.2

# osTicket Dependencies
sudo apt update
sudo apt install -y apache2 mysql-server-8.0 mysql-client-8.0 php php-mysqli php-gd libapache2-mod-php php-mbstring php-apcu

# osTicket Download and Install
sudo mkdir -p /opt/osTicket
sudo chown student:student /opt/osTicket
cd /opt/osTicket
wget https://github.com/osTicket/osTicket/releases/download/${osTicketVer}/osTicket-${osTicketVer}.zip
unzip osTicket-${osTicketVer}.zip
sudo mkdir -p /var/www/ticketing
echo "Installing osTicketing"
sudo cp -r ./upload/* /var/www/ticketing/
sudo cp /var/www/ticketing/include/ost-sampleconfig.php /var/www/ticketing/include/ost-config.php
sudo chown www-data:www-data /var/www/ticketing/include/ost-config.php
#sudo sed -i 's/allow_url_include = Off/allow_url_include = On/' /etc/php/8.1/apache2/php.ini

# osTicket Database Creation
echo "DB Setup In-Progress"
sudo systemctl start mysql
sudo mysql -e "create database osticket"
sudo mysql -e "create user osticket@localhost identified by 'osS3%T1CPa33'"
sudo mysql -e "grant all on osticket.* to osticket@localhost"
sudo mysql -e "flush privileges"

echo "Adding osTicketing to Apache"
cat << HERE >ticketing.conf
<VirtualHost *:80>
	ServerName ticketing.localhost
	ServerAdmin webmaster@localhost
        DocumentRoot /var/www/ticketing
	ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
HERE
echo "127.0.0.1            ticketing.localhost"|sudo tee -a /etc/hosts
sudo cp ticketing.conf /etc/apache2/sites-available/
sudo a2ensite ticketing
sudo systemctl restart apache2
echo
echo "osTicket Setup, now you can open a browser and surf to http://ticketing.localhost"
echo
echo "Recommended Settings:"
echo "Helpdesk Name: SOC-Desk"
echo "Default Email: soc-desk@ticketing.localhost"
echo "First Name: SOC"
echo "Last Name: User"
echo "Login email: soc-user@ticketing.localhost"
echo "Login user: soc-user"
echo "Login password: password"
echo "DB Name: osticket"
echo "DB User: osticket"
echo 'DB Pass: osS3%T1CPa33'
echo "AFTER running through the web setup, run the following:"
echo "  sudo chown root:root /var/www/ticketing/include/ost-config.php"
echo "  sudo rm -rf /var/www/ticketing/setup"
echo "You may then login normally to:"
echo "http://ticketing.localhost/scp/login.php"
