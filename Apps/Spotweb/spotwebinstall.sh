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
# | execute this script with the command sudo chmod +x spotwebinstall.sh
# | and run with ./spotwebinstall.sh
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

APP=Spotweb; 		# name of app to install (also for Dropboxfolders)
APPLOW=spotweb;	# lowercase appname

CONN1=github.com; 	# to test connections needed to install apps
CONN2=dropbox.com;

GITHUB=https://github.com/spotweb/spotweb.git; 	#github-adres
DROPBOX=http://dl.dropbox.com/u/18712538/ 				#dropbox-adres


PACK1=git-core; 	#needed packages to run (using apt to check and install)
PACK1_EXE=git;		#EXE optional needed when packagename differs from executable
PACK2=apache2;
PACK3="php5 php5-curl php-pear";
PACK4="php5-sqlite sqlite3"
PACK5="php5-mysql mysql-server"

PHPPACK1="Net_NNTP"

INSTALLDIR=/var/www/$APPLOW; #directory you want to install to.
CONFIGFILE=ownsettings.php;	#name of default init-script


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
echo 'SPOTWEB IS CREATED BY SPOTWEB :P'
echo '---- https://github.com/spotweb/'
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


#### CONFIRM_CONTINUE ####
	cf_Continue () {
	echo '--------'
	echo 'You can take the blue pill if you want to, just answer no on the next question or press CTRL+C'
	echo '--------'
	echo ' '

		Question() {
		echo "Are you sure you want to continue and install $APP?"
		read -p "(yes/no)   :" REPLY
		case $REPLY in
     		[Yy]*)
     			echo "Into the rabbit hole..."
	    		;;
     		[Nn]*)
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


#######################################################################################
#### CHECK AND INSTALL PACKAGES #######################################################

#### CHECK SOFTWARE ####
	check_Packs () {

		check_Pack1 () {
		if ! which $PACK1_EXE
			then
			echo "Cannot find if $PACK1 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK1
			use_PM
		else
			echo "$PACK1 installed"
		fi
		}

		check_Pack2 () {
		if ! which $PACK2
			then
			echo
			echo "Cannot find if $PACK2 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK2
			use_PM
		else
			echo "$PACK2 installed"
		fi
		}

		check_Pack3 () {
		if ! which $PACK3
			then
			echo
			echo "Cannot find if $PACK3 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK3
			use_PM
		else
			echo "$PACK3 installed"
		fi
		}

		check_Pack4 () {
		if ! which $PACK4
			then
			echo
			echo "Cannot find if $PACK4 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK4
			use_PM
		else
			echo "$PACK4 installed"
		fi
		}

		check_Pack5 () {
		if ! which $PACK5
			then
			echo
			echo "Cannot find if $PACK5 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK5
			use_PM
		else
			echo "$PACK5 installed"
		fi
		}

		cf_Dbase () {
		echo "Choose databasetype"
		echo "1. mySQL (requires configuration that is not (yet) supported by this installer"
		echo "   but is slightly faster than SQLite"
		echo "2. SQLite (easiest, requires no configuration at all)"
		echo "Q. Quit"
		read -p "Press 1, 2 or Q to select an option    :" REPLY
		case $REPLY in
     		1)
			check_Pack5
     			;;
     		2)
			check_Pack4
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

	check_Pack1
	check_Pack3
	cf_Dbase
	check_Pack2
	}


#### DETERMINE PACKAGEMANAGER ####
	use_PM () {

		def_PM () {
		[ -x "$(which $1)" ]
		}

		use_Apt () {
		sudo apt-get install $INST_PACK ||
		use_Manual
		}

		use_Yum () {
		sudo yum install $INST_PACK ||
		use_Manual
		}

		use_Pac () {
		sudo pacman -S $INST_PACK ||
		use_Manual
		}

		use_Manual () {
		echo
		echo "Installing $INST_PACK failed"
		echo "Please install manually..."
		echo
		echo "Type the command to install $INST_PACK"
		echo "e.g. sudo apt-get install $INST_PACK"
		read -p "   :" MAN_INST
		if $MAN_INST
			then
			echo "Succes!"
		else
			echo "Failed! Solve this before continuing installation"
			echo "Try again or press CTRL+C to quit"
			use_Manual
		fi
		}

	if def_PM apt-get
		then
		use_Apt
	elif def_PM yum
		then
		use_Yum
	elif def_PM pacman
		then
		use_Pac
	else
	    echo 'No package manager found!'
	    use_Manual
	fi
	}


#### INSTALL Net_NNTP ####
	set_NNTP () {
	sudo pear install Net_NNTP
	}
	


#### CHOOSE INSTALLATION DIRECTORY ####
	set_Dir () {

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
     			echo "Backup $INSTALLDIR to /home/$USER/LaSi/$APP"
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
     		    echo "Deleting $INSTALLDIR."
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
			read -p "(yes/no)   :" REPLY
			case $REPLY in
     				[Yy]*)
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
	command git clone $GITHUB $HOME/temp_$APPLOW &&
	sudo mv -f $HOME/temp_$APPLOW $INSTALLDIR
	echo
	}


#### CREATE OR IMPORT CONFIGFILE ####
	new_Config(){

		import_Config() { # import config.ini
		echo
		echo 'Type the full path of ownsettings.php that you want to import'
		echo 'or s to skip:'
		read -p ' :' IMPORTCONFIG
     		if [ $IMPORTCONFIG = S -o $IMPORTCONFIG = s ]
     			then
     			cf_Import
     		elif [ -e $IMPORTCONFIG ]
			then
			cp -f -b $IMPORTCONFIG $INSTALLDIR/$CONFIGFILE
			echo "File imported to $INSTALLDIR/$CONFIGFILE"
		else
			echo 'File does not exist, enter correct path as /path/to/ownsettings.php' &&
			import_Config
		fi
		}

			cf_Edit () { # Edit clean configfile
			echo
			echo "Change ownsettings.php to your personal needs"
			echo "You can edit the configfile now in your terminal-editor or do it later"
			echo "If you use a fresh install with clean settings, you need to edit anyway"
			echo "Do you want to view them or edit now?"
			read -p "(yes/no)   :" REPLY
			case $REPLY in
				[Yy]*)
			   		command editor $INSTALLDIR/$CONFIGFILE
					;;
				[Nn]*)
					echo
					echo "Skipping this step"
					echo "Don't forget to edit it before using $APP"
					echo
					;;
				*)
					echo "Answer yes or no"
					cf_Edit
					;;
			esac
			}

		cf_Import () { # Confirm import
		echo "Do you want to import your own configurationfile (ownsettings.php)?"
		read -p "(yes/no)   :" IMPORTREPLY
		case $IMPORTREPLY in
     		[Yy]*)
     			import_Config
     			;;
     		[Nn]*)
     			echo "Using the default one"
			cp -f -b $INSTALLDIR/settings.php $INSTALLDIR/ownsettings.php
			echo "Clean config created in $INSTALLDIR/$CONFIGFILE"
			sed -i "s!if (file_exists!#if (file_exists!g" $INSTALLDIR/$CONFIGFILE
			cf_Edit
      		;;
      		*)
			echo "Answer yes or no"
			cf_Import
      		;;
			esac
		}
	cf_Import
	}


#### EDIT PHP.INI ####
	edit_PHP () {

		cf_PHP () { # Edit php.ini
		echo
		echo "PHP needs to know what timezone you are in"
		echo "You can edit the php.ini files later in your terminal-editor"
		echo "search for this part:"
		echo "-----------"
		echo "[Date]"
		echo "; Defines the default timezone used by the date functions"
		echo "; http://php.net/date.timezone"
		echo ";date.timezone ="
		echo "-----------"
		echo "and change:"
		echo ";date.timezone = \"\""
		echo "for example to"
		echo "date.timezone = \"Europe/Amsterdam\""
		echo "-----------"
		echo "Do you want me to change your timezone to Europe/Amsterdam??"
		read -p "(yes/no)   :" REPLY
		case $REPLY in
			[Yy]*)
		   		sudo sed -i "s#;date.timezone =#date.timezone = \"Europe/Amsterdam\"#g" /etc/php5/apache2/php.ini
				sudo sed -i "s#;date.timezone =#date.timezone = \"Europe/Amsterdam\"#g" /etc/php5/cli/php.ini
				;;
			[Nn]*)
				echo
				echo "Skipping this step"
				echo "Don't forget to edit it before using $APP"
				echo
				;;
			*)
				echo "Answer yes or no"
				cf_PHP
				;;
		esac
		}
		
	if [ -e /etc/php5/apache2/php.ini ]
		then
		cf_PHP
	else
		echo "Can't find php.ini, so you need to find and edit it yourself"
		echo "You can also ignore this error, but it's better to specify your timezone in there"
	fi
	}

######################################################

#### STARTING APP ####		
	start_App() {
		LOCATION=$(hostname)
		echo "Installation is done..."
		echo "Now restarting Apache to be sure everything new will be loaded..."
		sudo /etc/init.d/apache2 restart
		echo "Point your webbrowser to http://$LOCATION/spotweb/testinstall.php to confirm everything is working!"
		echo "After that edit ownsettings.php if you didn't do so allready"
		echo "Then do cd /var/www/spotweb and then execute php retrieve.php"
		echo "then go to http://$LOCATION/spotweb/ to browse your personal Spotweb."
		echo "Have fun!"
	}

#### RETURN TO MENU ####
	LaSi_Menu () {

	echo
	read -sn 1 -p "Press a key to continue."
	exit
	}



#### ALL FUNCTIONS ####

LaSi_Logo 		#some basic info about installer
show_Author		#creator of the app installed
conn_Test		#connection test for url's used in installation
cf_Continue		#let user confirm to continue
root_Test		#test user is not root but has sudo
check_Packs		#check dependencys
set_NNTP
set_Dir			#choose installation directory
clone_Git		#clone the git repo into $installdir
new_Config		#import or create configfile
edit_PHP
start_App
LaSi_Menu		#Return to main script


