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
# | execute this script with the command sudo chmod +x couchpotatoinstall.sh
# | and run with ./couchpotatoinstall.sh 
# |            
# | answer all questions the terminal asks,
# | and couchpotato will be running in no time!
# |___________________________________________________________________________________
#
# Tested succesful on OS's:
# Ubuntu 10.4 Desktop, Ubuntu 10.4 Minimal server, XBMC Live Dharma
#
#######################################################################################
#######################################################################################

VERSION=v0.8


#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

APP=CouchPotato;					# name of app to install 
							# APP needs to be exactly the same (caps) as on Github (App.git, without .git)
APPLOW=couchpotato;					# lowercase appname

CONN1=github.com;					# to test connections needed to install apps
CONN2=dropbox.com;

GITHUB=https://github.com/RuudBurger/CouchPotato.git;	#github-adres
DROPBOX=http://dl.dropbox.com/u/18712538/;		#dropbox-adres

PACKAGES="git python python-cheetah";			#needed packages to run (use a space as delimiter)

INSTALLDIR=/home/$USER/.$APPLOW;			#directory you want to install to.
INITD=initd;						#name of default init-script

IPADRESS=0.0.0.0; 					#default ipadress to listen on
PORT=5000; 						#default port to listen on





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
echo '-------------------------------------'
echo 'COUCHPOTATO IS CREATED BY RUUD BURGER'
echo '-------------- www.couchpotatoapp.com'
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
		clone_Git		#clone the git repo and mv to $installdir
		cf_Daemon 		#let user confirm to daemonize
		new_Config		#import or download configurationfile
		use_Database		#Import old database
		start_App		#Start the application and gl!
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
echo
	cf_Overwrite () {
	echo "1. Choose another directory"
	echo "2. Backup $INSTALLDIR to LaSi/$APP"
	echo "3. Delete $INSTALLDIR"
	echo "Q. Quit"
	read -p "Press 1, 2, 3 or Q to select an option    :" REPLY
	case $REPLY in
		1)
			choose_Dir
			;;
		2)
			echo "Backup $INSTALLDIR to LaSi/$APP"
			mkdir -p LaSi
			mv -f $INSTALLDIR /home/$USER/LaSi/$APP
			;;
		3)
			echo "Deleting $INSTALLDIR."
			rm -Rf $INSTALLDIR
			;;
		[Qq]*)
			echo "Fini..."
			show_Menu
			;;
		*)
			echo "Choose 1, 2, 3 or Q to quit"
			cf_Dir
			;;
	esac
	}

	choose_Dir() { 
	read -p 'Type the path of the directory you want to install in...   :' INSTALLDIR
	if [ -d $INSTALLDIR ]
		then
		echo
		echo "$INSTALLDIR allready exists, please choose an option:"
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
		echo "Do you want to change this?"
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
echo "Download and install the most recent version of $APP from GitHub"
echo '-------'
echo
git clone $GITHUB $INSTALLDIR
echo
}


#### CONFIRM DAEMON INSTALL ####
cf_Daemon () {
echo
echo '-------'
echo "You can install $APP as a daemon, so it will start when your pc starts..."
echo "daemoninstall works only Ubuntu or Debian, I need commands for other OS's"
echo "So if you want this script to work on your *nix, email me the commands needed"
echo '-------'
echo

	Question() {
	echo "Do you want to install $APP as a daemon?"
	read -p "(yes/no): " DAEMON
	case $DAEMON in
		[YyJj]*)
			echo 'As you wish, master...'
			adj_Initscript		#change values to match installscripts
			cp_Initscript		#copy initscript to /etc/init.d/$applow
			;;
		[Nn]*)
			echo "You can start app manually by executing python $INSTALLDIR/$APP.py..."
			;;
		*)
			echo "Answer yes or no"
			Question
			;;
		esac
	}
Question
}


#### CHANGE VALUES IN INITSCRIPT ####
adj_Initscript () {
PATH_PYTHON=$(which python)
cp -f $INSTALLDIR/$INITD $INSTALLDIR/$INITD.bak
sed -i "
	s#/usr/bin/python#$PATH_PYTHON#g
	s#/usr/local/sbin/couchpotato#$INSTALLDIR#g
	s#root#$USER#g
" $INSTALLDIR/$INITD
}


#### COPY INITSCRIPT TO /ETC/INIT.D/ ####
cp_Initscript () {
echo
if [ -e /etc/init.d/$APPLOW ]
	then
	echo "Making backup of /etc/init.d/$APPLOW to $APPLOW.bak"
fi
echo "Copying $INSTALLDIR/$INITD to /etc/init.d/$APPLOW..."
sudo cp -f --suffix=.bak $INSTALLDIR/$INITD /etc/init.d/$APPLOW &&
sudo chmod +x /etc/init.d/$APPLOW &&
sudo update-rc.d $APPLOW defaults
}



#### HANDLE CONFIGFILE ####
new_Config(){
echo

	get_Config () { #download new config.ini
	if [ -e $INSTALLDIR/config.ini ]
		then
		mv -f $INSTALLDIR/config.ini $INSTALLDIR/config.ini.bak &&
		echo "Copied config.in to $INSTALLDIR/config.ini.bak"
	fi
	wget -P $INSTALLDIR $DROPBOX/$APP/config.ini
	}

	import_Config() { # import config.ini
	echo
	echo 'Type the full path and filename of the configurationfile you want to import'
	echo 'or s to skip:'
	read -p ': ' IMPORTCONFIG
	if [ $IMPORTCONFIG = S -o $IMPORTCONFIG = s ]
		then
		cf_Import
	elif [ -e $IMPORTCONFIG ]
		then
		cp -f --suffix=.bak $IMPORTCONFIG $INSTALLDIR/config.ini &&
		echo "Copied $IMPORTCONFIG to $INSTALLDIR/config.ini"
	else
		echo 'File does not exist, enter correct path as /path/to/file.ext' &&
		import_Config
	fi
	}

	cf_Import () { # Confirm import
	echo "Do you want to import your own configurationfile?"
	read -p "(yes/no): " REPLY
	case $REPLY in
		[YyJj]*)
			import_Config
			;;
		[Nn]*)
			echo "Downloading fresh config from dropbox.com"
			get_Config
			cf_Config
			;;
		*)
			echo "Answer yes or no"
			cf_Import
			;;
	esac
	}
cf_Import
}


#### LET USER CONFIRM CONFIGURATION ####
cf_Config() {
echo
echo
echo "Now you can start $APP with a clean configuration..."
echo "By default $APP's webinterface adress is: http://$IPADRESS:$PORT."
echo "That's the same as http://localhost:$PORT or http://127.0.0.1:$PORT."
echo "It will not ask for a username and password."
echo

	Question() {
	echo "Do you want change the defaults?"
	read -p "(yes/no): " REPLY
	case $REPLY in
		[YyJj]*)
			set_IP			#Set Ipadress:Port
			set_UP			#Set Username:Password
			;;
		[Nn]*)
			echo "Starting fresh"
			;;
		*)
			echo "Answer yes or no"
			Question
			;;
	esac
	}
Question
}

#### CHANGE DEFAULTS IN CONFIGFILE ####

#### CHANGE IPADRESS AND PORT ####
set_IP () {
echo
read -p "Enter new ipadress, default is $IPADRESS: " NEW_IP
read -p "Enter new port, default is $PORT: " NEW_PORT

	cf_IP () {
	echo "You entered $NEW_IP:$NEW_PORT, is this correct?: "
	read -p "(yes/no): " REPLY
	case $REPLY in
		[YyJj]*)
			echo "Adding $NEW_IP:$NEW_PORT to config.ini and autoProcessTV.cfg..."
			IP=$NEW_IP
			PORT=$NEW_PORT
			sed -i "
				s/host = 0.0.0.0/host = $NEW_IP/g
				s/port = 5000/port = $NEW_PORT/g 
			" $INSTALLDIR/config.ini
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
echo
read -p 'Enter new username, leave blank for none : ' NEW_USER
read -p 'Enter new password, leave blank for none : ' NEW_PASS

	cf_UP () {
	echo "You entered username '$NEW_USER' and password '$NEW_PASS', is this correct?: "
	read -p "(yes/no or skip): " REPLY
	case $REPLY in
		[YyJj]*)
			echo "Adding username and password to config.ini..."
			sed -i "
				s/username = /username = $NEW_USER/g
				s/password = /password = $NEW_PASS/g
			" $INSTALLDIR/config.ini
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


#### IMPORT DATABASE
use_Database () {
echo
	import_Database() { # import database
	echo
	echo 'Type the full path and filename of the database you want to import'
	echo 'or s to skip:'
	read -p ' :' IMPORTDB
	if [ $IMPORTDB = S -o $IMPORTDB = s ]
		then
		cf_Import
	elif [ -e $IMPORTDB ]
		then
		cp -f $IMPORTDB $INSTALLDIR/data.db
	else
		echo 'File does not exist, enter correct path as /path/to/data.db' &&
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
start_App () {
echo
case $DAEMON in
	[YyJj]*)
		if sudo /etc/init.d/$APPLOW start
			then
			echo "Point your webbrowser to http://$NEW_IP:$NEW_PORT and have fun!"
		else
			echo "Can't start $APP, try starting manually..."
			echo "Execute sudo /etc/init.d/$APPLOW stop | start | restart | force-reload"
		fi
		read -sn 1 -p "Press a key to return to menu."
		;;
	[Nn]*)
		if $PATH_PYTHON $INSTALLDIR/$APP.py
			then
			echo "Point your webbrowser to http://$NEW_IP:$NEW_PORT and have fun!"
		else
			echo "Can't start $APP, try starting manually..."
			echo "Type $PATH_PYTHON $INSTALLDIR/$APP.py"
		fi
		read -sn 1 -p "Press a key to return to menu."
		;;
esac
}


#### UPDATE APP ####
git_Update () {
echo
echo "===="
echo "Checking for updates $APP"
cd $INSTALLDIR
if ! git pull | grep "Already up-to-date"
	then
	sudo /etc/init.d/$APPLOW restart
fi
read -sn 1 -p "Press a key to return to menu."
echo "===="
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

