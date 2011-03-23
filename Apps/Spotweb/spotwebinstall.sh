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
			    DBCHOICE=mySQL
			    check_Pack5
			    echo ""
			    ;;
     		2)
			    check_Pack4
			    DBCHOICE=SQLite
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

		cf_Import () { # Confirm import
		echo "Do you want to import your own configurationfile (ownsettings.php)?"
		read -p "(yes/no)   :" IMPORTREPLY
		case $IMPORTREPLY in
     		[Yy]*)
     		    IMPORTSETTINGS=1
     			import_Config
     			;;
     		[Nn]*)
     		    IMPORTSETTINGS=0
     			echo "Een standaard configuratie wordt opgehaald"
     			if [ -e $INSTALLDIR/$CONFIGFILE ]
			        then
			        echo "Backup ownsettings.php naar ownsettings.php.bak"
			        mv -f $INSTALLDIR/$CONFIGFILE $INSTALLDIR/$CONFIGFILE.bak &&
			        wget -P $INSTALLDIR $DROPBOX/$APP/$CONFIGFILE &&
			        sed -i "s/mijnuniekeservernaam/$HOSTNAME/g" $INSTALLDIR/$CONFIGFILE
			        echo "Standaard configuratiefile gemaakt in $INSTALLDIR/$CONFIGFILE"
		        else
			        wget -P $INSTALLDIR $DROPBOX/$APP/$CONFIGFILE &&
			        echo "Standaard configuratiefile gemaakt in $INSTALLDIR/$CONFIGFILE"
			        sed -i "s/mijnuniekeservernaam/$HOSTNAME/g" $INSTALLDIR/$CONFIGFILE
		        fi
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
		if grep -i ";date.timezone =" /etc/php5/apache2/php.ini
		    then
		    echo "Datum/tijdzone wordt aangepast naar Europe/Amsterdam in php.ini"
		    sudo sed -i "s#;date.timezone =#date.timezone = \"Europe/Amsterdam\"#g" /etc/php5/apache2/php.ini
		    sudo sed -i "s#;date.timezone =#date.timezone = \"Europe/Amsterdam\"#g" /etc/php5/cli/php.ini
		fi
		}
		
	if [ -e /etc/php5/apache2/php.ini ]
		then
		cf_PHP
	else
		echo "Kan php.ini niet vinden, je moet deze zelf aanpassen met je timezone"
		echo "Deze fout kun je ook negeren, maar het is beter om het wel aan te passen"
	fi
	}
	
#### CONFIGURE MYSQL DB ####
    config_SQL () {
    if [ $DBCHOICE=mySQL ]
        then
        echo ""
        echo "Je hebt gekozen voor een mySQL database"
        
        cf_SQL () {
        echo "Wil je dat ik een nieuwe database voor je aanmaak?"
		read -p "(ja/nee)   :" DBREPLY
		case $DBREPLY in
     		[YyJj]*)
     		    input_PW
     			;;
     		[Nn]*)
     			echo "Je hebt dus al een database"
     			echo "Check even ownsettings of je wachtwoord en user goed staan"
     			editor $INSTALLDIR/$CONFIGFILE
      		    ;;
      		*)
			    echo "Antwoord ja of nee"
			    ;;
		esac
		}
		
		    input_PW () {
		    echo ""
		    echo "Welk wachtwoord heb je opgegeven tijdens de mySQL installatie?"
		    read -p "wachtwoord:" SQLPASSWORD
		    }
		    
		    create_DB () {
		    MYSQL=$(which mysql)
		    if $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "CREATE DATABASE spotweb;")
		        then
		        $MYSQL mysql -u root --password="$SQLPASSWORD" -e "CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';"
                $MYSQL mysql -u root --password="$SQLPASSWORD" -e "GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"
                echo "Database aangemaakt met de naam spotweb, user spotweb en wachtwoord spotweb ;)"
                sed -i "
                    s/$settings['db']['engine'] = 'sqlite3';/$settings['db']['engine'] = 'mysql';/g
                    s!$settings['db']['path'] = './nntpdb.sqlite3';!#$settings['db']['path'] = './nntpdb.sqlite3';!g
                    s/#$settings['db']['engine'] = 'mysql';/$settings['db']['engine'] = 'mysql';/g
                    s/#$settings['db']['host'] = 'localhost';/$settings['db']['host'] = 'localhost';/g
                    s/#$settings['db']['dbname'] = 'spotweb';/$settings['db']['dbname'] = 'spotweb';/g
                    s/#$settings['db']['user'] = 'spotweb';/$settings['db']['user'] = 'spotweb';/g
                    s/#$settings['db']['pass'] = 'spotweb';/$settings['db']['pass'] = 'spotweb';/g
                    " $INSTALLDIR/$CONFIGFILE
            else
                echo "Je hebt een verkeerd wachtwoord opgegeven, probeer het nog een keer"
                input_PW
            fi
            }
    cf_SQL
    }
    
    
#### NOG WAT CONFIGURATIE ####
		cf_Newsserver () {
		if [ $IMPORTSETTINGS -eq 0 ]
		    then
		    echo "Wil je alvast een nieuwsserver opgegeven?"
		    read -p "(ja/nee)   :" REPLY
		    case $REPLY in
     		    [Yy]*)
     		    	read -p "Wat is het usenetadres (bv. news.ziggo.nl)?" USENET
     		    	read -p "Wat is de gebruikersnaam (alleen enter voor blanco)?" USERNAME
     		    	read -p "Wat is het wachtwoord (enter voor blanco)?" PASSWORD
     		    	read -p "Welk poortnummer wil je gebruiken? 119 of 563 (encrypted)?" PORT
     		    	#### check of encryptie
     		    	if [ $PORT -eq 563 ]
     		    	    then
     		    	    ENC="\'ssl\'"
     		    	else
     		    	    ENC="false"
     		    	fi
     		    	#### pas ownsettings aan
     		    	sed -i "
                        s/news.ziggo.nl/$USENET/g
                        s/\$settings[\'nntp_nzb\'][\'user\'] = \'xx\';/\$settings[\'nntp_nzb\'][\'user\'] = \'$USERNAME\';/g
                        s/\$settings[\'nntp_nzb\'][\'pass\'] = \'yy\';/\$settings[\'nntp_nzb\'][\'pass\'] = \'$PASSWORD\';/g
                        s/\$settings[\'nntp_nzb\'][\'enc\'] = false;/\$settings[\'nntp_nzb\'][\'enc\'] = $ENC;/g
                        s/\$settings[\'nntp_nzb\'][\'port\'] = 119;/\$settings[\'nntp_nzb\'][\'port\'] = $PORT;/g
     		    	" $INSTALLDIR/$CONFIGFILE
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
                 
        
		
	

######################################################

#### HERSTART APACHE ####		
	restart_Ap() {
		LOCATION=$(hostname)
		echo "Installation is done..."
		echo "Now restarting Apache to be sure everything new will be loaded..."
		sudo /etc/init.d/apache2 restart
	}
	

#### HERSTART APACHE ####	
		cf_Retrieve () { # Confirm import
		echo "Wil je alvast spots binnenhalen? Dit kan even duren maar is wel nodig @ first run"
		read -p "(ja/nee)   :" REPLY
		case $REPLY in
     		[YyJj]*)
     		    PHP=$(which php)
     		    cd $INSTALLDIR
     		    $PHP retrieve.php
     			;;
     		[Nn]*)
     		    echo "Spotweb zonder spots is alleen maar web"
      		    ;;
      		*)
			echo "Antwoord ja of nee"
				cf_Retrieve
      		    ;;
		esac
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
config_SQL
cf_Newsserver
restart_Ap
cf_Retrieve
LaSi_Menu		#Return to main script


