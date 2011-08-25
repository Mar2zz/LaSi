#!/bin/sh

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3

## sickbeard Install script for Synology by Mar2zz

## v0.8.

# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues

# Based on the tutorials by J. van Emden (Brickman)
# http://synology.brickman.nl/HowTo%20-%20install%20sickbeard.txt



#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

APP=SickBeard; 	# name of app to install 
			# APP needs to be exactly the same (caps) as on Github (App.git, without .git)
APPLOW=sickbeard;	# lowercase appname

CONN1=github.com; 	# to test connections needed to install apps
CONN2=dropbox.com;

GITHUB=git://github.com/midgetspy/Sick-Beard.git; 	#github-adres
DROPBOX=http://dl.dropbox.com/u/18712538/Synology	#dropbox-adres

INSTALLDIR=/volume1/@appstore/$APPLOW;			#directory you want to install to.

IPADRESS=0.0.0.0;					#default ipadress to listen on
PORT=8081; 						#default port to listen on
NAS=hostname;


## Check if ipkg is installed by updating the packagelist
ipkg_Test () {
if ! ipkg update
	then
	echo "Bootstrap is not installed, please install it before using this script"
	echo "Information how to install bootstrap can be found on" 
	echo "http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc#How_to_install_ipkg"
	exit
fi
}

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
echo "1. (re)Install $APP"
echo "2. Update $APP"
echo "3. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2 or 3: " CHOICE
case $CHOICE in
	1)
		edit_DSM
		install_Deps
		make_Daemon
		cf_Config
		use_Database
		start_App
		show_Menu
		;;
	2)
		git_Update
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



######## INSTALLATION ########

edit_DSM () {
## do some stuff in the webinterface
echo '
# Go to your DSM:
# Control Panel -> Users -> Create user"
# and create a user called "sickbeard"
# Press the Ok button
#
# Press a button to continue this installer 
(if you have done all of the above settings)'
read -sn 1 -p "--- [continue]---"
}


install_Deps () {
# Install the following if needed
echo "Now checking if all dependency's are installed"
ipkg install git			# Install git if it is not on your system
ipkg install textutils			# Needed to use git pull to update from the source
ipkg install python26			# Install Python 2.6 if it is not on your system
ipkg install py26-cheetah		# Install Cheetah - The Python-Powered Template Engine

# Install from gitsource
if [ -d $INSTALLDIR ]
	then
	backup_Dir () {
	echo "$INSTALLDIR allready exists..."
	echo "Do you want to backup this folder?"
	read -p "Answer yes or no: " REPLY
	case $REPLY in
		[YyJj]*)
			mv -Rf $INSTALLDIR backup_$INSTALLDIR &&
			echo "Moved $INSTALLDIR to backup_$INSTALLDIR"
			;;
		[Nn]*)
			rm -Rf $INSTALLDIR
			echo "Removed $INSTALLDIR"
			;;
		*)
			echo "Answer yes or no"
			backup_Dir
			;;
	esac
	}
backup_Dir
fi
git clone $GITHUB $INSTALLDIR
cp -f $INSTALLDIR/autoProcessTV.cfg.sample $INSTALLDIR/autoProcessTV/autoProcessTV.cfg
}

# Install service to start @ boot
make_Daemon () {
echo "Grabbing startupscript provided by J. van Emden (Brickman)"
wget -O /opt/etc/init.d/S99sickbeard.sh http://dl.dropbox.com/u/5653370/sickbeard/S99sickbeard.sh &&
chmod a+x /opt/etc/init.d/S99sickbeard.sh
}


#### GET NEW CONFIGFILE ####
new_Config(){

	get_Config () { #download new config.ini
	if [ -e $INSTALLDIR/config.ini ]
		then
		mv -f $INSTALLDIR/config.ini $INSTALLDIR/config.ini.bak
	fi
	wget -P $INSTALLDIR http://dl.dropbox.com/u/18712538/$APP/config.ini
	}

	import_Config() { # import config.ini
	echo
	echo 'Type the full path and filename of the configurationfile you want to import'
	echo 'or s to skip:'
	read -p ' :' IMPORTCONFIG
	if [ $IMPORTCONFIG = S -o $IMPORTCONFIG = s ]
		then
		cf_Import
	elif [ -e $IMPORTCONFIG ]
		then
		cp -f $IMPORTCONFIG $INSTALLDIR/config.ini
	else
		echo 'File does not exist, enter correct path as /path/to/file.ext' &&
		import_Config
	fi
	}

	cf_Import () { # Confirm import
	echo "Do you want to import your own configurationfile?"
	read -p "(yes/no): " REPLY
	case $REPLY in
		[Yy]*)
			import_Config
			;;
		[Nn]*)
			echo "Downloading fresh config from dropbox.com"
			get_Config
			;;
		*)
			echo "Answer yes or no"
			cf_Import
			;;
	esac
	}
cf_Import
}


### CHANGE DEFAULTS IN CONFIGFILE ####

#### CHANGE IPADRESS AND PORT ####

set_IP () {
read -p 'Enter new ipadress, default is 0.0.0.0 ...: ' NEW_IP
read -p "Enter new port, default is $PORT ...: " NEW_PORT

	cf_IP () {
	echo "You entered $NEW_IP:$NEW_PORT, is this correct?"
	read -p "(yes/no): " REPLY
	case $REPLY in
		[Yy]*)
			echo "Ok, adding $NEW_IP:$NEW_PORT to config.ini..."
			sed -i "
				s/web_host = 0.0.0.0/web_host = $NEW_IP/g
				s/web_port = 8081/web_port = $NEW_PORT/g 
			" $INSTALLDIR/config.ini
			echo "and autoProcessTV.cfg..."
			sed -i "
				s/host=/host=$NEW_IP/g
				s/port=/port=$NEW_PORT/g
			" $INSTALLDIR/autoProcessTV/autoProcessTV.cfg
			;;
		[Nn]*)
			set_IP
			;;
		*)
			echo "Answer yes or no"
			cf_IP
			;;
	esac
	}
cf_IP
}


#### CHANGE USERNAME AND PASSWORD ####
set_UP () {
read -p 'Enter new username, leave blank for none ...    :' NEW_USER
read -p 'Enter new password, leave blank for none ...    :' NEW_PASS

	cf_UP () {
	echo "You entered username '$NEW_USER' and password '$NEW_PASS', is this correct?  :"
	read -p "(yes/no or skip)   :" REPLY
	case $REPLY in
		[Yy]*)
			echo "Adding username and password to config.ini..."
			sed -i "
				s/web_username = \"\"/web_username = $NEW_USER/g
				s/web_password = \"\"/web_password = $NEW_PASS/g
			" $INSTALLDIR/config.ini
			echo "and autoProcessTV.cfg..."
			sed -i "
				s/username=/username=$NEW_USER/g
				s/password=/password=$NEW_PASS/g
			" $INSTALLDIR/autoProcessTV/autoProcessTV.cfg
			;;
		[Nn]*)
			set_UP
			;;
		[Ss]*)
			echo "Skipped that one, it stays blank"
			;;
		*)
			echo "Answer yes or no or skip"
			cf_UP
			;;
	esac
	}
cf_UP
}

#### LET USER CONFIRM CONFIGURATION ####
cf_Config() {
echo '-------'
echo "Now you can start $APP with a clean configuration..."
echo "By default $APP's webinterface adress is: http://$IPADRESS:$PORT."
echo "That's the same as http://localhost:$PORT or http://$NAS:$PORT."
echo "It will not ask for a username and password."
echo 

	Question() {
	echo "Do you want change the defaults or import your own configuration file?"
	read -p "(yes/no): " REPLY
	case $REPLY in
		[Yy]*)
			echo 'As you wish, master...'
			new_Config
			set_IP
			set_UP
			;;
		[Nn]*)
			if [ -e $INSTALLDIR/config.ini ]
				then
				mv -f $INSTALLDIR/config.ini $INSTALLDIR/config.ini.bak
			fi
			wget -P $INSTALLDIR http://dl.dropbox.com/u/18712538/$APP/config.ini
			;;
		*)
			echo "Answer yes or no"
			Question
			;;
	esac
	}
Question
}


#### IMPORT DATABASE ####
use_Database () {

	import_Database() { # import database
	echo
	echo 'Type the full path and filename of the database you want to import'
	echo 'or s to skip:'
	read -p ' :' IMPORTDB
	if [ $IMPORTDB = S -o $IMPORTDB = s ]
		then
		cf_Database
	elif [ -e $IMPORTDB ]
		then
		cp -f $IMPORTDB $INSTALLDIR/sickbeard.db
	else
		echo 'File does not exist, enter correct path as /path/to/sickbeard.db' &&
		import_Database
	fi
	}

	cf_Database () { # Confirm import database
	echo "Do you want to import your own database?"
	read -p "(yes/no): " REPLY
	case $REPLY in
		[Yy]*)
			import_Database
			;;
		[Nn]*)
			echo "Starting fresh"
			;;
		*)
			echo "Answer yes or no"
			cf_Database
			;;
	esac
	}
cf_Database
}


#### STARTING APP ####
start_App() {
echo "Now starting $APP..."
chown -R sickbeard:users $INSTALLDIR
/opt/etc/init.d/S99sickbeard.sh start

CONFIGPORT=$(grep web_port $INSTALLDIR/config.ini | sed 's/web_port = //g')
CONFIGIP=$(grep web_host $INSTALLDIR/config.ini | sed 's/web_host = //g')

echo "Point your webbrowser to http://$CONFIGIP:$CONFIGPORT and have fun!"
read -sn 1 -p "Press a key to return to menu."
}


#### UPDATE APP ####
git_Update () {
echo
echo "===="
echo "Checking for updates $APP"
cd $INSTALLDIR
if ! git pull | grep "Already up-to-date"
	then
	/opt/etc/init.d/S99sickbeard.sh stop &&
	chown -R sickbeard:users $INSTALLDIR &&
	/opt/etc/init.d/S99sickbeard.sh start
fi
read -sn 1 -p "Press a key to return to menu."
echo "===="
}

#### Call functions
ipkg_Test
LaSi_Logo
show_Menu
