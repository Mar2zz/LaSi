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
# | execute this script with the command sudo chmod +x mediafrontpageinstall.sh
# | and run with ./mediafrontpageinstall.sh
# |
# | answer all questions the terminal asks,
# | and albumidentify will be running in no time!
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

APP=Mediafrontpage;						# name of app to install (also for Dropboxfolders)
APPLOW=mediafrontpage;						# lowercase appname

CONN1=github.com;						# to test connections needed to install apps
CONN2=dropbox.com;

GITHUB=https://github.com/MediaFrontPage/mediafrontpage.git;	#github-adres
DROPBOX=http://dl.dropbox.com/u/18712538/ 			#dropbox-adres

PACKAGES="git apache2 php5 php5-curl"				#packages that must be installed
INSTALLDIR=/var/www/$APPLOW;					#directory you want to install to.


#######################################################################################


#######################################################################################

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

show_Author () {
echo '---------------------------------'
echo 'MEDIAFRONTPAGE IS CREATED BY NICK8888 AND OTHERS'
echo '------------- https://github.com/Mediafrontpage/'
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


#### PRESENT OPTIONS IN A MENU ####
show_Menu (){
LaSi_Logo 				#some basic info about installer
show_Author				#creator of the app installed
echo
echo "1. (re)Install $APP"
echo "2. Update $APP"
echo "3. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2 or 3: " CHOICE
case $CHOICE in
	1)
		check_Packs		#check dependencys
		set_Dir			#choose installation directory
		clone_Git		#clone the git repo into $installdir
		#add_MFP		#add mfp-site to sites-available (not done yet, using apache defaultsite)
		restart_Ap		#reload apache for all changes to take effect
		show_Menu
		;;
	2)
		git_Update
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


#######################################################################################
#### CHECK AND INSTALL PACKAGES #######################################################

#### DEFINE PACKAGEMANAGER
def_PM () {
[ -x "$(which $1)" ]
}

#### INSTALL NEEDED PACKAGES ####
install_Packages() {
echo
for PACKAGE in $PACKAGES
do
	if ! which $PACKAGE > /dev/null
		then
		if def_PM apt-get
			then
			sudo apt-get install $PACKAGE
		elif def_PM yum
			then
			sudo yum install $PACKAGE
		elif def_PM pacman
			then
			sudo pacman -S $SPACKAGE
		elif def_PM emerge
			then
			sudo emerge $PACKAGE
		else
			echo "Could not determine packagemanager or packagename for your distro"
			echo "Type the command to install $PACKAGE"
			echo "e.g. sudo apt-get install $PACKAGE"
			use_Manual () {
			read -p ": " MAN_INST
			if ! $MAN_INST 
				then
				echo "Failed! Solve this before continuing installation"
				echo "Try command again or press CTRL+C to quit"
				use_Manual
			fi
			}
			use_Manual
		fi
	fi
done
}


#### CHOOSE INSTALLATION DIRECTORY ####
set_Dir () {

	cf_Overwrite () {
	echo "1. Choose another folder"
	echo "2. Backup $INSTALLDIR to LaSi/$APP"
	echo "3. Delete $INSTALLDIR"
	echo "Q. Quit"
	read -p "Choose 1, 2, 3 or Q to quit: " REPLY
	case $REPLY in
		1)
			choose_Dir
			;;
		2)
			echo "Backup $INSTALLDIR naar /home/$USER/LaSi/$APP"
			sudo chown -R $USER $INSTALLDIR
			if [ -d LaSi ]
				then
				cp -af $INSTALLDIR /home/$USER/LaSi/$APP &&
				sudo rm -Rf $INSTALLDIR
			else
				mkdir LaSi
				cp -af $INSTALLDIR /home/$USER/LaSi/$APP &&
				sudo rm -Rf $INSTALLDIR
			fi
			;;
		3)
			echo "Delete $INSTALLDIR."
			sudo rm -Rf $INSTALLDIR
			;;
		[Qq]*)
			echo "Fini..."
			LaSi_Menu
			;;
		*)
			echo "Choose 1, 2, 3 or Q to quit"
			cf_Dir
			;;
	esac
	}

	choose_Dir() {
	read -p "Enter the path you want to install $APP in: " INSTALLDIR
	if [ -d $INSTALLDIR ]
		then
		echo
		echo "$INSTALLDIR allready exists, choose an option"
		cf_Overwrite
	else
		echo "Installing $APP in $INSTALLDIR."
	fi
	}

	cf_Dir () {
	if [ -d $INSTALLDIR ]
		then
		echo
		echo "$INSTALLDIR allready exists, please choose an option:"
		cf_Overwrite
	else
		echo "By default $APP will be installed in $INSTALLDIR."
		echo "Do you want to change this? (only change when you know what you are doing)"
		read -p "(yes/no): " REPLY
		case $REPLY in
			[YyJj]*)
				choose_Dir
				;;
			[Nn]*)
				echo "Installing $APP in $INSTALLDIR"
				;;
			*)
				echo "Answer yes or no"
				cf_Dir
				;;
		esac
	fi
	}

cf_Dir
}


#### CLONING INTO GIT ####
clone_Git () {
echo
echo '-------'
echo "Download and install most recent $APP from GitHub"
echo '-------'
echo
command git clone $GITHUB $HOME/temp_$APPLOW &&
sudo mv -f $HOME/temp_$APPLOW $INSTALLDIR
echo "Changing ownership of /var/www/mediafrontpage to www-data"
sudo chown -R www-data $INSTALLDIR
sudo chmod -R 774 $INSTALLDIR
echo
}

######################################################


##### APACHESITE TOEVOEGEN ####
#add_MFP () {
#if [ -e /etc/apache2/sites-available/mfp-site ]
#	then
#	echo "mfp-site bestaat al in /etc/apache2/sites-available"
#	echo "skipping website-config import"
#else
#	echo "Importing website config from dropbox..."
#	wget $DROPBOX/$APP/mfp-site
#	sudo cp mfp-site /etc/apache2/sites-available/mfp-site &&
#	sudo a2ensite mfp-site &&
#	echo "Added mfp-site to /etc/apache2/sites-enabled"
#fi
#}



#### HERSTART APACHE ####
restart_Ap() {
echo "Installation is ready..."
echo "Reload Apache for all changes..."
sudo /etc/init.d/apache2 reload
}


git_Update () {
echo
echo "===="
echo "Checking for updates $APP"
cd $INSTALLDIR &&
git pull
read -sn 1 -p "Press a key to return to menu."
echo "===="
}



#### RETURN TO MENU ####
LaSi_Menu () {

echo
echo "
Mediafrontpage installation is ready, 
go to: http://$HOSTNAME/mediafrontpage and have fun!
"
read -sn 1 -p "Press a key to continue."
exit
}



#### ALL FUNCTIONS ####
conn_Test		#connection test for url's used in installation
root_Test		#test user is not root but has sudo
show_Menu


