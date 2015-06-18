#!/usr/bin/env bash

echo ">>>>>> Starting Install Script"

# Update
# Issue because of 'no public key available' http://unix.stackexchange.com/questions/75807/no-public-key-available-on-apt-get-update
sudo apt-get -y install debian-keyring debian-archive-keyring
sudo apt-get -y update



# Installing Git
echo ">>>>>> Installing Git"
sudo apt-get -y install git

# Install Nginx
echo ">>>>>> Installing Nginx"
sudo apt-get -y install nginx

# Install PHP FPM
echo ">>>>>> Updating PHP repository"
apt-get -y install python-software-properties build-essential
add-apt-repository ppa:ondrej/php5
apt-get -y update

echo ">>>>>> Installing PHP"
sudo apt-get -y install php5-common php5-dev php5-cli php5-fpm

echo ">>>>>> Installing PHP Extensions"
sudo apt-get -y install curl php5-curl php5-gd php5-mcrypt php5-mysql

# Install MySQL without prompt
echo ">>>>>> Preparing MySQL"
sudo apt-get -y install debconf-utils
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "Installing MySQL"
sudo apt-get -y install mysql-server

# Nginx Configuration
echo "Configuring Nginx"
sudo cp /vagrant/provision/nginx_vhost_config /etc/nginx/sites-available/nginx_vhost_config
sudo ln -s /etc/nginx/sites-available/nginx_vhost_config /etc/nginx/sites-enabled/

if [ -f /etc/nginx/sites-available/default ]; then
	sudo rm -rf /etc/nginx/sites-available/default
	echo ">>>>>> Done removing /etc/nginx/sites-available/default "
else
	echo ">>>>>> File /etc/nginx/sites-available/default doesn't exists!!!"
fi

if [ -f /etc/nginx/sites-enabled/default ]; then
	sudo rm -rf /etc/nginx/sites-enabled/default
	echo ">>>>>> Done removing /etc/nginx/sites-enabled/default "
else
	echo ">>>>>> File /etc/nginx/sites-enabled/default doesn't exists!!!"
fi


# Restart Nginx for the config to take effect
sudo service nginx restart

echo ">>>>>> DONE <<<<<<<"