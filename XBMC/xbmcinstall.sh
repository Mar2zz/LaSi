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
# | execute this script with the command sudo chmod +x xbmcinstall.sh
# | and run with ./xbmcinstall.sh
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

APP=XBMC;							# name of app to install (also for Dropboxfolders)
APPLOW=xbmc;							# lowercase appname

CONN1=google.com;						# to test connections needed to install apps
CONN2=dropbox.com;

DROPBOX=http://dl.dropbox.com/u/18712538/			#dropbox-adres

PACKAGES="$APPLOW";						#needed packages to run (using apt to check and install)

IPADRESS=0.0.0.0;						#default ipadress to listen on
PORT=8080;							#default port to listen on


#######################################################################################


LaSi_Logo (){
clear
echo
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

show_Author () {
echo '-------------------------------------'
echo 'XBMC IS CREATED BY THE XBMC-TEAM'
echo '------------------- www.xbmc.org'
echo 
echo "LaSi $VERSION"
}

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
echo "1. Install or update $APP as a desktop application"
echo "2. Install or update $APP as a standalone application"
echo "3. Completely remove $APP (this removes also $APPS's configfiles!)"
echo "4. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2, 3 or 4: " CHOICE
case $CHOICE in
	1)
		cf_Version
		install_Desktop
		show_Menu
		;;
	2)
		cf_Version
		install_Standalone
		show_Menu
		;;
		
	3)
		remove_App
		show_Menu
		;;
	4)
		LaSi_Menu		#Return to main script
		;;
	*)
		echo "Enter 1, 2, 3 or 4"
		show_Menu
		;;
esac
}



#### CHOOSE STABLE/UNSTABLE ####
cf_Version () {
echo
echo '-------'
echo "You can install $APP as a stable or unstable version..."
echo "The unstable version has more and new features, but also more bugs"
echo "Install unstable only if you want to test it. If you don't like it, rerun this"
echo "installer to install the stable version"
echo '-------'
echo

	Question() {
	echo "Choose a version to install"
	echo "1. Stable"
	echo "2. Unstable"
	read -p ": " VERSION
	case $DAEMON in
		[1]*)
			echo 'Installing the stable version'
			add_Stable
			;;
		[2]*)
			echo 'Installing the unstable version'
			add_Unstable
			;;
		*)
			echo "Answer 1 or 2"
			Question
			;;
		esac
	}
Question
}


#### ADD SOURCE ####
#### STABLE
add_Stable () {
echo

# Check if ppa is used as a source
if ls /etc/apt/sources.list.d | grep team-xbmc-unstable > /dev/null
	then
	sudo rm -f /etc/apt/sources.list.d/team-xbmc-unstable*
fi
if ! ls /etc/apt/sources.list.d | grep team-xbmc-ppa > /dev/null
	then
	echo
	echo "Adding Team XBMC ppa-repo..."
	sudo add-apt-repository ppa:team-xbmc
	echo
	echo "XBMC Repo added"
	echo
fi
# Now update it
echo "Updating sources.list..."
sudo apt-get update > /dev/null
echo "Updated all sources"
echo
}

#### UNSTABLE
add_Unstable () {
# Check if ppa is used as a source
if ls /etc/apt/sources.list.d | grep team-xbmc-ppa > /dev/null
	then
	sudo rm -f /etc/apt/sources.list.d/team-xbmc-ppa*
fi
if ! ls /etc/apt/sources.list.d | grep team-xbmc-unstable > /dev/null
	then
	echo
	echo "Adding Team XBMC ppa-repo..."
	sudo add-apt-repository ppa:team-xbmc/unstable
	echo
	echo "XBMC Repo added"
	echo
fi
# Now update it
echo "Updating sources.list..."
sudo apt-get update > /dev/null
echo "Updated all sources"
echo
}

install_Desktop () {
if sudo apt-get install $APPLOW
	then
	echo
	echo "XBMC can now be started from the startmenu > Audio and Video"
	echo
	read -sn 1 -p "Press a key to return to menu."
	echo
fi
}

install_Standalone () {
if sudo apt-get install $APPLOW $APPLOW-standalone
	then
	echo
	echo "XBMC can now be selected in the login-screen as a desktop-manager"
	echo
	read -sn 1 -p "Press a key to return to menu."
	echo
fi
}


#### COMPLETELY REMOVE XBMC ####
remove_App () {
sudo apt-get purge $APPLOW $APPLOW-standalone
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
