#!/bin/bash

# Read parameters
read -p "Project name (new_project): " project
read -p "Server path (/var/www): " server
read -p "Host path (/etc/hosts): " host
read -p "IP host (127.0.0.1): " ip

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
