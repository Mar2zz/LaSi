#!/bin/sh

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3

## Spotweb Install script for Synology by Mar2zz

## v0.8.

# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues

# Based on the tutorials by J. van Emden (Brickman)
# http://synology.brickman.nl/HowTo%20-%20install%20Spotweb.txt


######## INSTALLATION ########

NAS=$(hostname);


## Check if ipkg is installed by updating the packagelist
if ! ipkg update
	then
	echo "Bootstrap is not installed, please install it before using this script"
	echo "Information how to install bootstrap can be found on" 
	echo "http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc#How_to_install_ipkg"
	exit
fi

LaSi_Logo (){
clear
echo " Lazy admin Scripted installers -----------------------"
echo "                    ___           ___                  "
echo "                   /\  \         /\__\                 "
echo "                  /::\  \       /:/ _/_       ___      "
echo "                 /:/\:\  \     /:/ /\  \     /\__\     "
echo "  ___     ___   /:/ /::\  \   /:/ /::\  \   /:/__/     "
echo " /\  \   /\__\ /:/_/:/\:\__\ /:/_/:/\:\__\ /::\  \     "
echo " \:\  \ /:/  / \:\/:/  \/__/ \:\/:/ /:/  / \/\:\  \__  "
echo "  \:\  /:/  /   \::/__/       \::/ /:/  /     \:\/\__\ "
echo "   \:\/:/  /     \:\  \        \/_/:/  /       \::/  / "
echo "    \::/  /       \:\__\         /:/  /        /:/  /  "
echo "     \/__/         \/__/         \/__/         \/__/   "
echo
echo "----------------------------------------------- Mar2zz "
echo
echo
}

show_Menu (){
echo "1. (re)Install Spotweb"
echo "2. Enable spotweb-api"
echo "3. Update Spotweb"
echo "4. Add a cronjob for retrieving spots"
echo "5. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2, 3 ,4 or 5: " CHOICE
case $CHOICE in
	1)
		install_Deps
		install_DB
		config_Own
		php_All
		show_Menu
		;;
	2)
		enable_Api
		show_Menu
		;;
		
	3)
		git_Pull
		update_Spot
		php_All
		show_Menu
		;;
	4)
		check_Cron
		add_Cron
		show_Menu
		;;
	5)
		echo "Have fun using spotweb @ http://$NAS/spotweb/"
		;;
	*)
		echo "Enter 1, 2, 3, 4 or 5"
		show_Menu
		;;
esac
}

#### DEPENDENCY STUFF ####

install_Deps () {
# Install the pear package (and check if bootstrap is installed)
ipkg install php-pear

## Edit /usr/syno/etc/php.ini
sed -i 's#;include_path = ".:/php/includes"#include_path = ".:/php/includes:/opt/share/pear"#g' /usr/syno/etc/php.ini

## Install pear
pear install --alldeps Net_NNTP &&
pear config-set php_bin /usr/bin/php

## Install Git and/or Textutils
ipkg install git
ipkg install textutils

## do some stuff in the webinterface
echo '
# Go to your DSM:
# Control Panel -> Web Services -> Web Applications -> Check "Enable Web Station" and "Enable MySQL"
# Control Panel -> Web Services -> PHP Settings:
# Check "Customize PHP open_basedir" and add ":/opt/share/pear" at the end
# Under "Select PHP extension": Make sure that the following items are checked: openssl,
  mysql, zlib, gd
# Press the Ok button
#
# Press a button to continue this installer (if you have done all of the above settings)'
read -sn 1 -p "--- [continue]---"

## Install git
if [ -d /volume1/web/spotweb ]
	then
	backup_Spot () {
	echo "/volume1/web/spotweb allready exists..."
	echo "Do you want to backup this folder?"
	read -p "Answer yes or no: " REPLY
	case $REPLY in
		[YyJj]*)
			mv -Rf /volume1/web/spotweb /volume1/web/spotweb_bak &&
			echo "Moved /volume1/web/spotweb to /volume1/web/spotweb_bak"
			git clone https://github.com/spotweb/spotweb.git /volume1/web/spotweb
			;;
		[Nn]*)
			rm -Rf /volume1/web/spotweb
			echo "Removed /volume1/web/spotweb"
			git clone https://github.com/spotweb/spotweb.git /volume1/web/spotweb
			;;
		*)
			echo "Answer yes or no"
			backup_Spot
			;;
	esac
	}
	backup_Spot
else
	git clone https://github.com/spotweb/spotweb.git /volume1/web/spotweb
fi
}


#### MYSQL STUFF ####

install_DB () {
## Change mysql password?
my_SQL () {
echo "Do you know your mySQL password?"
read -p "yes/no :" REPLY
case $REPLY in
	[Yy]*)
		read -p "Enter mySQL password:" PASSWORD
		;;
	[Nn]*)
		set_Pass () { 
		read -p "Set a new password: " PASSWORD
		read -p "Confirm new password: " PASSWORD2
		if [ "$PASSWORD" != "$PASSWORD2" ]
			then
			echo "Passwords do not match, try again"
			set_Pass
		else
			/usr/syno/mysql/bin/mysqladmin -u root password $PASSWORD
		fi
		}
	set_Pass
		;;
	*)
		echo "Answer yes or no"
		my_SQL
		;;
esac
}
my_SQL

## Create databases
if ! $(/usr/syno/mysql/bin/mysql --password="$PASSWORD" -e "USE spotweb;")
	then
	/usr/syno/mysql/bin/mysql --password="$PASSWORD" -e "
	CREATE DATABASE spotweb;
	CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
	GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"
	echo "Created database spotweb for user spotweb with password spotweb"
else
	remove_DB () {
	echo "Database allready exists"
	echo "1. It's ok, keep it"
	echo "2. Please remove it, I want to start fresh"
	read -p "Choose 1 or 2: " DB
	case $DB in
		1)
			/usr/syno/mysql/bin/mysql --password="$PASSWORD" -e "
			CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
			GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"
			echo "Granted user spotweb access tot database spotweb with password spotweb"
			;;
		2)
			/usr/syno/mysql/bin/mysql --password="$PASSWORD" -e "
			DROP DATABASE spotweb;
			CREATE DATABASE spotweb;
			CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
			GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"
			echo "Created a fresh database spotweb for user spotweb with password spotweb"
			;;
		*)
			echo "Enter 1 or 2"
			remove_DB
			;;
	esac
	}
	remove_DB
fi
}


#### CREATE OWNSETTINGS STUFF ####

config_Own () {
echo "Do you want to import your own ownsettings.php?"
echo "If you say no a new one will be created."
echo "NOTE: This installer assumes you use default MYSQL-values as written in settings.php"
echo "Make sure you didn't override those defaults in ownsettings.php when importing"
read -p "Answer yes or no: " IMPORT
case $IMPORT in
	[YyJj]*)
		import_Path () {
		echo "Enter full path to ownsettings.php"
		read -p "Path: " IMPORTPATH
		if [ -e $IMPORTPATH ]
			then
			cp -f $IMPORTPATH /volume1/web/spotweb/ownsettings.php
			echo "Copied $IMPORTPATH to /volume1/web/spotweb/ownsettings.php"
		else
			echo "File not found, try again"
			import_Path
		fi
		}
		import_Path
		;;
	[Nn]*)
		echo "Importing a new ownsettings.php with minimal settings"
		wget -P /volume1/web/spotweb http://dl.dropbox.com/u/18712538/Spotweb/ownsettings_syn.php
		mv /volume1/web/spotweb/ownsettings_syn.php /volume1/web/spotweb/ownsettings.php
		## Edit ownsettings.php
		echo "Press a key to edit your usenetserver credentials"
		read -sn 1 -p "--- [continue]---"
		if $(which nano) 
			then
			nano /volume1/web/spotweb/ownsettings.php
		else
			vi /volume1/web/spotweb/ownsettings.php
		fi
		;;
	*)
		echo "Answer yes or no"
		config_Own
		;;
esac
}


php_All () {
## Create databasetables and start retrieving.
echo "Now starting database upgrade, this can take a while"
cd /volume1/web/spotweb
/usr/bin/php upgrade-db.php &&
echo "
Now starting retrieval of spots, this can take hours!!
If it errors and stops, just type:
cd /volume1/web/spotweb && usr/bin/php retrieve.php 
to continue retrieving where it stopped. Have fun using Spotweb!
"
read -sn 1 -p "--- [press any key to start retrieving]---"
/usr/bin/php retrieve.php
}


#### UPDATE STUFF ####
git_Pull () {
cd /volume1/web/spotweb &&
git pull
}


### ENABLE API ####
enable_Api () {
if [ -e /volume1/web/spotweb/.htaccess ]
	then
	cp -f /volume1/web/spotweb/.htaccess /volume1/web/spotweb/.htaccess_backup
	echo "Made a backup of your .htaccess to /volume1/web/spotweb/.htaccess_backup"
	sed -i 1i'RewriteEngine on' /volume1/web/spotweb/.htaccess
	sed -i 2i'RewriteCond %{REQUEST_URI} !api/' /volume1/web/spotweb/.htaccess
	sed -i 3i'RewriteRule ^api/?$ index.php?page=newznabapi [QSA,L]' /volume1/web/spotweb/.htaccess
else
	touch /volume1/web/spotweb/.htaccess
	echo 'RewriteEngine on' > /volume1/web/spotweb/.htaccess
	echo 'RewriteCond %{REQUEST_URI} !api/' >> /volume1/web/spotweb/.htaccess
	echo 'RewriteRule ^api/?$ index.php?page=newznabapi [QSA,L]' >> /volume1/web/spotweb/.htaccess
fi
echo "Now visit http://$NAS/spotweb/api?t=c and if you see XML-output the API works!"
}


#### ADD CRONJOB ####
check_Cron () {
if $(grep -q "/usr/bin/php retrieve.php" /etc/crontab)
	then
	echo "The following cronjob for Spotweb allready exists"
	echo $(grep "/usr/bin/php retrieve.php" /etc/crontab)
	read -p "Do you want to replace this? (yes/no): " DOUBLE
	case $DOUBLE in
		[YyJj]*)
			sed -i '/retrieve.php/d' /etc/crontab
			;;
		[Nn]*)
			echo "Crontab not edited"
			show_Menu
			;;
		*)
			echo "Answer yes or no"
			check_Cron
			;;
	esac
fi
}


add_Cron () {
echo "How often in hours should Spotweb retrieve spots?"
echo "Valid answers are 1, 2, 3 etc..."
echo "Enter 1 to update every hour, 2 for every two hours, etc...!"
read -p "Enter a digit: " HOUR
if [ $HOUR -eq $HOUR ]
	then
	echo "0	\*/$HOUR	\*	\*	\*	root	cd /volume1/web/spotweb && /usr/bin/php retrieve.php \> /dev/null" >> /etc/crontab &&
	echo "Cronjob added for spotweb to retrieve spots every $HOUR hour(s)"
	/usr/syno/etc/rc.d/S04crond.sh stop &&
	/usr/syno/etc/rc.d/S04crond.sh start
else
	echo "You did not enter a digit, try again"
	add_Cron
fi
}




### Start with the menu ###
LaSi_Logo
show_Menu


