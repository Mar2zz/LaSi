#!/bin/sh

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3

## Headphones Install script for Synology by Mar2zz

## v0.1.

# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues

# Based on the tutorials by J. van Emden (Brickman)
# http://synology.brickman.nl/HowTo%20-%20install%20Spotweb.txt


######## INSTALLATION ########

NAS=$(hostname);
INSTALLDIR="/volume1/@appstore";
DROPBOX=http://dl.dropbox.com/u/18712538/;


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
echo "1. (re)Install Headphones"
echo "2. Update Headphones"
echo "3. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2 or 3: " CHOICE
case $CHOICE in
	1)
		install_Deps
		cf_Config
		show_Menu
		;;
	2)
		enable_Api
		show_Menu
		;;
		
	3)
		echo "Have fun using Headphones @ http://$NAS:8181/"	
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



## Install software needed
install_Deps () {
ipkg install git
ipkg install textutils

## make sure python 2.6 is present
if ! $(which python | grep "python2.6")
	then
	ipkg install python26
fi

## Install git
if [ -d $INSTALLDIR/headphones ]
	then
	backup_Head () {
	echo "$INSTALLDIR/headphones allready exists..."
	echo "Do you want to backup this folder?"
	read -p "Answer yes or no: " REPLY
	case $REPLY in
		[YyJj]*)
			mv -Rf $INSTALLDIR/headphones $INSTALLDIR/headphones_bak &&
			echo "Moved $INSTALLDIR/headphones to $INSTALLDIR/headphones_bak"
			git clone https://github.com/rembo10/headphones.git $INSTALLDIR/headphones
			;;
		[Nn]*)
			rm -Rf $INSTALLDIR/headphones
			echo "Removed $INSTALLDIR/headphones"
			git clone https://github.com/rembo10/headphones.git $INSTALLDIR/headphones
			;;
		*)
			echo "Answer yes or no"
			backup_Head
			;;
	esac
	}
	backup_Head
else
	git clone https://github.com/rembo10/headphones.git $INSTALLDIR/headphones
fi
}

cf_Config() {
echo '-------'
echo "Now you can start Headphones with a clean configuration..."
echo "By default $APP's webinterface adress is: http://$NAS:8181."
echo "It will not ask for a username and password."
echo 

	Question() {
	echo "Do you want change the defaults or import your own configuration file?"
	read -p "(yes/no)   :" REPLY
	case $REPLY in
	[Yy]*)
		echo 'As you wish, master...'
		;;
	[Nn]*)
		echo "Point your webbrowser to http://$NAS:8181 and start configuring!"
		LaSi_Menu
		;;
	*)
		echo "Answer yes or no"
		Question
		;;
	esac
	}
Question
}


#### LET USER CONFIRM CONFIGURATION ####
cf_Config() {
echo '-------'
echo "Now you can start Headphones with a clean configuration..."
echo "By default Headphones webinterface adress is: http://$NAS:8181."
echo "It will not ask for a username and password."
echo 

	import_Config() { 
	echo
	echo 'Type the full path and filename of the configurationfile you want to import'
	echo 'or s to skip:'
	read -p ' :' IMPORTCONFIG
	if [ -e $IMPORTCONFIG ]
		then
		cp -f --suffix=.bak $IMPORTCONFIG $INSTALLDIR/headphones/config.ini &&
		echo "Point your webbrowser to you know where and have fun using Headphones!"
		show_Menu
	else
		echo 'File does not exist, enter correct path as /path/to/config.ini' &&
		import_Config
	fi
	}

	Question() {
	echo "Do you want to import your own configuration file?"
	read -p "(yes/no): " REPLY
	case $REPLY in
	[Yy]*)
		echo 'As you wish, master...'
		import_Config
		;;
	[Nn]*)
		echo "Point your webbrowser to http://$NAS:$8181 and start configuring!"
		show_Menu
		;;
	*)
		echo "Answer yes or no"
		Question
		;;
	esac
	}
Question
}


