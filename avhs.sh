#!/bin/bash

# Read parameters
read -p "Project name (new_project): " project
read -p "Server path (/var/www): " server
read -p "Host path (/etc/hosts): " host
read -p "IP host (127.0.0.1): " ip

read -p "Do you want to create some type of project? [Y/N]: " yn

case $yn in
	("y" | "Y" | "Yes" | "YES")
		read -p "Insert type of project: " type
	;;
esac

# If project is not defined then use default
if [ -z "$project" ];	then
		project="new_project"
fi

# If ip is not defined then use default
if [ -z "$server" ];	then
		server="/var/www"
fi

# If ip is not defined then use default
if [ -z "$host" ];	then
		host="/etc/hosts"
fi

# If ip is not defined then use default
if [ -z "$ip" ];	then
		ip="127.0.0.1"
fi

# Create dir for files
mkdir $server/$project

# Read config info from file
fileData=$(<host-config.conf)

# Replace %name% with given argument
hostData="${fileData//%name%/$project}"

# Create config for apache2 server
echo -e $hostData | sudo tee /etc/apache2/sites-available/$project.conf > /dev/null

# Enable site from created config
sudo a2ensite $project.conf

# Append /etc/hosts
sudo sed -i "3i $ip\t$project" $host

# Restart apache2
sudo service apache2 restart

# Function for installing wordpress
function wordpressInstall {
	# Change path to created dir
  cd $server/$project

	# Download latest wordpress
  wget http://wordpress.org/latest.tar.gz

	# Untar archive with wordpress
  tar xvfz $server/$project/latest.tar.gz

	# Move all files from wordpress dir to project dir
  mv $server/$project/wordpress/* $server/$project

	# Delete archive and empty wordpress dir
  rm $server/$project/latest.tar.gz
  rm -rf $server/$project/wordpress
}

# Function for installing opencart
function opencartInstall {
	# Current opencart version
  ver="2.0.2.0"

	# Change path to created dir
  cd $server/$project

	# Download opencart archive with given version
  wget https://github.com/opencart/opencart/archive/$ver.tar.gz -O opencart.tar.gz

	# Untar archive with opencart
  tar xvfz $server/$project/opencart.tar.gz

	# Move all files from opencart dir to project dir
  mv $server/$project/opencart-$ver/upload/* $server/$project

	# Delete archive and empty opencart dir
  rm $server/$project/opencart.tar.gz
  rm -rf $server/$project/opencart-$ver

	# Rename configs for opencart
  mv $server/$project/config-dist.php $server/$project/config.php
  mv $server/$project/admin/config-dist.php $server/$project/admin/config.php
}

# Check if type is given
if [ ! -z "$type" ]; then
	# Use specific function depending on given type
	case $type in
	  ("Wordpress" | "wordpress" | "WordPress")
			wordpressInstall
	  ;;
		("Opencart" | "opencart" | "OpenCart")
			opencartInstall
		;;
	esac
fi
