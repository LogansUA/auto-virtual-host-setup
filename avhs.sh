#!/bin/bash

# Read parameters
read -p "Project directory (new_project): " projectDir
read -p "Virtual host address (new-project.work): " hostAddress
read -p "Server path (/var/www): " server
read -p "Host path (/etc/hosts): " host
read -p "IP host (127.0.0.1): " ip

read -p "Do you want to create some type of project? [Y/N]: " yn

case "${yn,,}" in
	("y" | "yes")
		read -p "Insert type of project: " type
	;;
esac

# If project dir is not defined then use default
if [ -z "$projectDir" ];	then
		project="new_project"
fi

# If virtual host address is not defined then use default
if [ -z "$hostAddress" ];	then
		project="new-project.work"
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

hostData="
	<VirtualHost *:80>\n
			\tServerName $hostAddress\n
			\tServerAdmin webmaster@localhost\n
			\tDocumentRoot /var/www/$projectDir\n
			\t<Directory /var/www/$projectDir>\n
					\t\tOptions Indexes FollowSymLinks MultiViews\n
					\t\tAllowOverride All\n
					\t\tOrder allow,deny\n
					\t\tallow from all\n
			\t</Directory>\n
	</VirtualHost>\n"

# Check if type is given
if [ ! -z "$type" ]; then
	# Use specific configuration depending on given type
	if [ $type == "Symfony" ] || [ $type == "symfony" ]; then
		hostData="
			<VirtualHost *:80>\n
					\tServerName $hostAddress\n
					\tServerAdmin webmaster@localhost\n
					\tDocumentRoot /var/www/$projectDir/web\n
					\t<Directory /var/www/$projectDir/web>\n
							\t\tOptions Indexes FollowSymLinks MultiViews\n
							\t\tAllowOverride All\n
							\t\tOrder allow,deny\n
							\t\tallow from all\n
					\t</Directory>\n
			</VirtualHost>\n"
		fi
fi

# Create dir if not exist for files
if [ ! -d "$projectDir" ]; then
  mkdir $server/$projectDir
fi

# Create config for apache2 server
echo -e $hostData | sudo tee /etc/apache2/sites-available/$projectDir.conf > /dev/null

# Enable site from created config
sudo a2ensite $projectDir.conf

# Append /etc/hosts
sudo sed -i "3i $ip\t$hostAddress" $host

# Restart apache2
sudo service apache2 restart

notify-send "Success" "Virtual host $hostAddress created successfully" -i info

# Function for installing wordpress
function wordpressInstall {
	# Change path to created dir
  cd $server/$projectDir

	# Download latest wordpress
  wget http://wordpress.org/latest.tar.gz

	# Untar archive with wordpress
  tar xvfz $server/$projectDir/latest.tar.gz

	# Move all files from wordpress dir to project dir
  mv $server/$projectDir/wordpress/* $server/$projectDir

	# Delete archive and empty wordpress dir
  rm $server/$projectDir/latest.tar.gz
  rm -rf $server/$projectDir/wordpress
}

# Function for installing opencart
function opencartInstall {
	# Current opencart version
  ver="2.0.2.0"

	# Change path to created dir
  cd $server/$projectDir

	# Download opencart archive with given version
  wget https://github.com/opencart/opencart/archive/$ver.tar.gz -O opencart.tar.gz

	# Untar archive with opencart
  tar xvfz $server/$projectDir/opencart.tar.gz

	# Move all files from opencart dir to project dir
  mv $server/$projectDir/opencart-$ver/upload/* $server/$projectDir

	# Delete archive and empty opencart dir
  rm $server/$projectDir/opencart.tar.gz
  rm -rf $server/$projectDir/opencart-$ver

	# Rename configs for opencart
  mv $server/$projectDir/config-dist.php $server/$projectDir/config.php
  mv $server/$projectDir/admin/config-dist.php $server/$projectDir/admin/config.php
}

# Function for installing symfony
function symfonyInstall {
	# Check if symfony installer exist
	if [ ! -f /usr/local/bin/symfony ]; then
		read -p "Do you want to install symfony installer? [Y/N]: " yn

		case "${yn,,}" in
			("y" | "yes")
				# Installing symfony installer
				sudo curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
				sudo chmod a+x /usr/local/bin/symfony
			;;
			("n" | "no")
				exit 0
			;;
		esac
	fi

	mask="$server/$projectDir"

	# Self update symfony installer
	symfony self-update

	# Create symfony project based on user symfony installer
	symfony new $mask

	# Setting up Permissions
	HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
	sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX $mask/app/cache $mask/app/logs
	sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX $mask/app/cache $mask/app/logs
}

# Check if type is given
if [ ! -z "$type" ]; then
	# Use specific function depending on given type
	case "${type,,}" in
		# Wordpress installation
	  ("wordpress")
			wordpressInstall
	  ;;
		# Opencart installation
		("opencart")
			opencartInstall
		;;
		# Symfony installation
		("symfony")
			symfonyInstall
		;;
	esac
fi
