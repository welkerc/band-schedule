#/bin/bash

#installing the needed componets
echo "Installing basic LEMP stack"
sudo setenforce 0 #if you are planning on using SELinux, remove this line
sudo yum -y install epel-release
sudo yum -y install nginx php-fpm php-mysql mariadb mariadb-server

echo "Installing MariaDB"
sudo mysql_install_db --user=mysql
sudo mysqld_safe &
sleep 5
sudo mysql -u root < setup/db_setup.sql
sudo mysql -u foo --password=1337 band_sched < examples/sched.sql
sudo mysql -u foo --password=1337 band_sched < setup/inital_user.sql

echo "copying band_sched.ini"
sudo cp setup/band_sched.ini /var/db/

echo "copying nginx config"
sudo cp examples/nginx-example.conf /etc/nginx/conf.d/band_sched.conf
sudo cp examples/main-nginx-example.conf /etc/nginx/nginx.conf

sudo mkdir -p /srv/www/
sudo cp -R ../band-schedule /srv/www/
sudo chown -R nginx:nginx /srv/www/

#chaning nginx user form apache in php-fpm
sudo sed -i 's,apache,nginx,g' /etc/php-fpm.d/www.conf

#create the session folders
sudo mkdir -p /var/lib/php/session
sudo chown -R nginx:nginx /var/lib/php/session

echo "Starting nginx on port 80"
sudo systemctl start nginx
sudo systemctl start php-fpm
