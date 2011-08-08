#!/bin/sh

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3

## mediafrontpage Install script for Synology by Mar2zz

## v0.8.

# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues

# Based on the tutorials by J. van Emden (Brickman)
# http://synology.brickman.nl/HowTo%20-%20install%20mediafrontpage.txt


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
echo "1. (re)Install Mediafrontpage"
echo "2. Update Mediafrontpage"
echo "3. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2 or 3: " CHOICE
case $CHOICE in
	1)
		install_Deps
		show_Menu
		;;

	2)
		git_Pull
		show_Menu
		;;
	3)
		exit
		;;
	*)
		echo "Enter 1, 2 or 3"
		show_Menu
		;;
esac
}

#### DEPENDENCY STUFF ####


## do some stuff in the webinterface
echo '
# Go to your DSM:
# Control Panel -> Web Services -> Web Applications -> Check "Enable Web Station"
# Press the Ok button
#
# Press a button to continue this installer (if you have done all of the above settings)'
read -sn 1 -p "--- [continue]---"


install_Deps () {
## Install Git and/or Textutils
ipkg install git
ipkg install textutils
ipkg install php-curl



## Install git
if [ -d /volume1/web/mediafrontpage ]
	then
	backup_MFP () {
	echo "/volume1/web/mediafrontpage allready exists..."
	echo "Do you want to backup this folder?"
	read -p "Answer yes or no: " REPLY
	case $REPLY in
		[YyJj]*)
			mv -Rf /volume1/web/mediafrontpage /volume1/web/mediafrontpage_bak &&
			echo "Moved /volume1/web/mediafrontpage to /volume1/web/mediafrontpage_bak"
			;;
		[Nn]*)
			rm -Rf /volume1/web/mediafrontpage
			echo "Removed /volume1/web/mediafrontpage"
			;;
		*)
			echo "Answer yes or no"
			backup_MFP
			;;
	esac
	}
	backup_MFP
fi
git clone git://github.com/MediaFrontPage/mediafrontpage.git /volume1/web/mediafrontpage
chown -R nobody:root /volume1/web/mediafrontpage
chmod -R 774 /volume1/web/mediafrontpage
echo "Have fun using mediafrontpage @ http://$NAS/mediafrontpage/"
read -sn 1 -p "--- [continue]---"
}


#### UPDATE STUFF ####
git_Pull () {
cd /volume1/web/mediafrontpage &&
git pull
}


### Start with the menu ###
LaSi_Logo
show_Menu


