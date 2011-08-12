#!/usr/bin/env bash

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3
#
# This installer is part of "Lazy admins Scripted installers (LaSi)"
# Download main script @
# http://dl.dropbox.com/u/18712538/LaSi/LaSi.sh
#
# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues
#  ___________________________________________________________________________________
# |
# | When not using LaSi's Menuscript:
# | execute this script with the command sudo chmod +x sabnzbdplusinstall.sh
# | and run with ./sabnzbdplusinstall.sh
# |
# | answer all questions the terminal asks,
# | and sabnzbdplus will be running in no time!
# |___________________________________________________________________________________
#
# Tested succesful on OS's:
# Ubuntu 10.4 Desktop, Ubuntu 10.4 Minimal server, XBMC Live Dharma
#
#######################################################################################
#######################################################################################

VERSION=v0.1 ####

TESTOS1=Ubuntu_10.4_Desktop
TESTOS2=Ubuntu_10.4_Server
TESTOS3=XBMC_Live_Dharma

#######################################################################################
#################### LIST OF VARIABLES USED ###########################################

#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

APP=Sabnzbdplus;						# name of app to install (also for Dropboxfolders)
APPLOW=sabnzbdplus;						# lowercase appname

CONN1=google.com;						# to test connections needed to install apps
CONN2=dropbox.com;

DROPBOX=http://dl.dropbox.com/u/18712538/			#dropbox-adres

IPADRESS=0.0.0.0;						#default ipadress to listen on
PORT=8080;							#default port to listen on

#######################################################################################
####################### TEST IF USER CAN COMPLETE THIS INSTALL ########################


#### 1ST TEST IF USER CAN SUDO ####
	root_Test() {
	if [ "$(id -u)" = "0" ]
		then
		echo "Do not use this installer when logged in as root, it will mess things up!"
		LaSi_Menu
	fi
	echo "Provide password to continue with this installation..."
	if [ "$(sudo id -u)" != "0" ]
		then
		echo "...but that's not gonna work, you need to sudo to install $APP, now exiting" &&
		LaSi_Menu
	fi
	}

#### 2ND TEST IF USER IS ONLINE ####
	conn_Test () {

		git_test () {
		if ! ping -c 1 $CONN1 > /dev/null 2>&1
			then
			echo "Hmmm $CONN1 seems down..." &&
			echo "Need $CONN1 to install... Now exiting" &&
			LaSi_Menu
		fi
		}

		dropbox_test () {
		if ! ping -c 1 $CONN2 > /dev/null 2>&1
			then
			echo "Hmmm $CONN2 seems down..."
			echo "Need $CONN2 to install... Now exiting"
			LaSi_Menu
		fi
		}
	git_test
	dropbox_test
	}


#######################################################################################
####################### INSTALLATION ##################################################


#### PRESENT OPTIONS IN A MENU ####
show_Menu (){
LaSi_Logo 				#some basic info about installer
show_Author				#creator of the app installed
echo
echo "1. Install or update $APP"
echo "2. Completely remove $APP (this removes also sabs' configfiles!)"
echo "3. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2 or 3: " CHOICE
case $CHOICE in
	1)
		add_Source
		edit_Startup
		own_Config
		start_App
		show_Menu
		;;
	2)
		remove_App
		show_Menu
		;;
	3)
		LaSi_Menu		#Return to main script
		;;
	*)
		echo "Enter 1, 2 or 3"
		show_Menu
		;;
esac
}


#### ADD SOURCE ####
add_Source () {
echo

# Check if ppa is used as a source
if ! grep -i jcfp/ppa /etc/apt/sources.list
	then
	sudo add-apt-repository ppa:jcfp/ppa &&
fi
# Now install (or update) it
sudo apt-get update &&
sudo apt-get install $APPLOW
}


#### EDIT /ETC/DEFAULT/SABNZBDPLUS ####
edit_Startup () {
echo

	#### EDIT WITH RESULTS
	edit_File () {
	echo "Adding $NEW_PORT to /etc/default/sabnzbdplus..."
	sudo sed -i "
		s/HOST=/HOST=0.0.0.0/g
		s/PORT=/PORT=$NEW_PORT/g 
		s/USER=/USER=$USER/g
	" /etc/default/sabnzbdplus
	echo "$APP will run as $USER on http://$HOSTNAME:$NEW_PORT"
	echo "Configfiles are now located in $HOME/.sabnzbd"
	}

	#### CONFIRM PORT IS OK
	cf_Port () {
	echo "You entered $NEW_PORT, is this correct?: "
	read -p "(yes/no): " REPLY
	case $REPLY in
		[Yy]*)
			edit_File
			;;
		[Nn]*)
			set_Port
			;;
		*)
			echo "Answer yes or no"
			cf_Port
			;;
	esac
	}

	#### SET A PORT IF DEFAULT IS NOT CHOSEN
	set_Port () {
	read -p "Enter port sabnzbdplus should be running on, default is $PORT: " NEW_PORT
	cf_Port
	}

	#### CONFIRM TO CHANGE DEFAULT PORT
	Question() {
	echo "Do you want change the default port $APP will run on?"
	echo "Default port = $PORT"
	read -p "(yes/no): " REPLY
	case $REPLY in
		[Yy]*)
			set_Port
			;;
		[Nn]*)
			NEW_PORT=$PORT
			edit_File
			;;
		*)
			echo "Answer yes or no"
			Question
			;;
	esac
	}

Question
}


#### IMPORT OWN CONFIGURATIONFILE ####
own_Config () {
echo

	#### Import sabnzbd.ini
	import_Config() {
	echo
	echo 'Type the full path and filename of the configurationfile you want to import'
	echo 'or s to skip:'
	read -p ' :' IMPORTCONFIG
	if [ $IMPORTCONFIG = S -o $IMPORTCONFIG = s ]
		then
		cf_Import
	elif [ -e $IMPORTCONFIG ]
		then
		cp -f --suffix=.bak $IMPORTCONFIG $HOME/.sabnzbd/sabnzbd.ini &&
	else
		echo 'File does not exist, enter correct path as /path/to/sabnzbd.ini' &&
		import_Config
	fi
	}

	#### Confirm import of own configurationfile
	cf_Import () { 
	echo "Do you want to import your own configurationfile?"
	read -p "(yes/no): " REPLY
	case $REPLY in
		[Yy]*)
			import_Config
			;;
		[Nn]*)
			echo "Starting fresh"
			;;
		*)
			echo "Answer yes or no"
			cf_Import
			;;
	esac
	}

cf_Import
}

#### START SABNZBD ####
start_App () {
echo "Now starting $APP..."
if sudo /etc/init.d/$APPLOW start
	then
	echo "Point your webbrowser to http://$HOSTNAME:$NEW_PORT and have fun!"
else
	echo "Can't start $APP, try starting manually..."
	echo "Execute sudo /etc/init.d/$APPLOW stop | start | restart | force-reload"
fi
read -sn 1 -p "Press a key to return to menu."
}

#### COMPLETELY REMOVE SABNZBDPLUS AND ALL CONFIGFILES ####
remove_App () {
sudo apt-get purge sabnzbdplus &&
sudo apt-get autoremove
}


#### RETURN TO MENU ####
	LaSi_Menu () {
	echo
	read -sn 1 -p "Press a key to exit."
	exit
	}


#### ALL FUNCTIONS ####	
conn_Test		#connection test for url's used in installation
root_Test		#test user is not root but has sudo
show_Menu		#present choices for installation
