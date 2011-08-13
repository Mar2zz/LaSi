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

VERSION=v0.4 ####

TESTOS1=Ubuntu_10.4_Desktop
TESTOS2=Ubuntu_10.4_Server
TESTOS3=XBMC_Live_Dharma

#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

APP=Spotweb;						# name of app to install (also for Dropboxfolders)
APPLOW=spotweb;						# lowercase appname

CONN1=github.com;					# to test connections needed to install apps
CONN2=dropbox.com;

GITHUB=https://github.com/spotweb/spotweb.git;		#github-adres
DROPBOX=http://dl.dropbox.com/u/18712538/;		#dropbox-adres

PACKAGES="git apache2 php5 php5-curl php-pear php5-mysql mysql-server";	# packages to install
PHPPACK1="Net_NNTP";

INSTALLDIR=/var/www/$APPLOW;				#directory you want to install to.
CONFIGFILE=ownsettings.php;				#name of default init-script


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

#### INSTALL Net_NNTP ####
set_NNTP () {
sudo pear install Net_NNTP
}



#### CHOOSE INSTALLATION DIRECTORY ####
set_Dir () {

	cf_Overwrite () {
	echo "1. Kies een andere map"
	echo "2. Backup $INSTALLDIR naar LaSi/$APP"
	echo "3. Delete $INSTALLDIR"
	echo "Q. Quit"
	read -p "Kies 1, 2, 3 of Q om te stoppen    :" REPLY
	case $REPLY in
		1)
			choose_Dir
			;;
		2)
			echo "Backup $INSTALLDIR naar /home/$USER/LaSi/$APP"
			if [ -d LaSi ]
				then
				mkdir -p LaSi
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
			echo "Kies 1, 2, 3 of Q om te stoppen"
			cf_Dir
			;;
	esac
	}

	choose_Dir() {
	read -p "Typ het pad waar je $APP wilt installeren...   :" INSTALLDIR
	if [ -d $INSTALLDIR ]
		then
		echo
		echo "$INSTALLDIR bestaat al, maak een keuze:"
		cf_Overwrite
	else
		echo "Installeert $APP in $INSTALLDIR."
	fi
	}

	cf_Dir () {
	if [ -d $INSTALLDIR ]
		then
		echo
		echo "$INSTALLDIR allready exists, please choose an option:"
		cf_Overwrite
	else
		echo "Standaard zal $APP in $INSTALLDIR gezet worden."
		echo "Wil je dit veranderen? (doe dat alleen als je weet waarmee je bezig bent)"
		read -p "(ja/nee): " REPLY
		case $REPLY in
			[YyJj]*)
				choose_Dir
				;;
			[Nn]*)
				echo "Installeert $APP in $INSTALLDIR"
				;;
			*)
				echo "Antwoord ja of nee"
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
echo "Download en installeer de meest recente $APP van GitHub"
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
	echo 'Typ het volledige pad in naar ownsettings.php'
	echo 'of typ s om over te slaan:'
	read -p ': ' IMPORTCONFIG
	if [ $IMPORTCONFIG = S -o $IMPORTCONFIG = s ]
		then
		cf_Import
	elif [ -e $IMPORTCONFIG ]
		then
		cp -f -b $IMPORTCONFIG $INSTALLDIR/$CONFIGFILE
		echo "Bestand geimporteerd naar $INSTALLDIR/$CONFIGFILE"
	else
		echo 'Bestand bestaat niet, voer het zo in /pad/naar/ownsettings.php' &&
		import_Config
	fi
	}

	cf_Import () { # Confirm import
	echo "Wil je je eigen configuratiefile (ownsettings.php) importeren?"
	read -p "(ja/nee): " IMPORTREPLY
	case $IMPORTREPLY in
		[YyJj]*)
			IMPORTSETTINGS=1
			import_Config
			;;
		[Nn]*)
			IMPORTSETTINGS=0
			echo "Een standaard configuratie wordt opgehaald"
			if [ -e $INSTALLDIR/$CONFIGFILE ]
				then
				echo "Backup ownsettings.php naar ownsettings.php.bak"
				mv -f $INSTALLDIR/$CONFIGFILE $INSTALLDIR/$CONFIGFILE.bak
			fi
			wget -P $INSTALLDIR $DROPBOX/$APP/$CONFIGFILE &&
			echo "Standaard configuratiefile gemaakt in $INSTALLDIR/$CONFIGFILE"
			;;
		*)
			echo "Antwoord ja of nee"
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
	if grep -i ";date.timezone =" /etc/php5/apache2/php.ini > /dev/null
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

	cf_SQL () {
	echo "Wil je dat ik een nieuwe database voor je aanmaak?"
	read -p "(ja/nee): " DBREPLY
	case $DBREPLY in
		[YyJj]*)
			input_PW
			;;
		[Nn]*)
			echo "Je hebt dus al een database"
			;;
		*)
			echo "Antwoord ja of nee"
			;;
	esac
	}

	input_PW () {
	echo
	echo "Welk wachtwoord heb je opgegeven tijdens de mySQL installatie?"
	read -p "wachtwoord:" SQLPASSWORD
	create_DB
	}

	create_DB () {
	MYSQL=$(which mysql)
	if $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "CREATE DATABASE spotweb;")
		then
		$MYSQL mysql -u root --password="$SQLPASSWORD" -e "
			CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
			GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"
		echo "Database aangemaakt met de naam spotweb, user spotweb en wachtwoord spotweb ;)"
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
	read -p "(ja/nee): " REPLY
	case $REPLY in
		[YyJj]*)
			read -p "Wat is het usenetadres (bv. news.ziggo.nl)?" USENET
			read -p "Wat is de gebruikersnaam (alleen enter voor blanco)?" USERNAME
			read -p "Wat is het wachtwoord (enter voor blanco)?" PASSWORD
			read -p "Welk poortnummer wil je gebruiken? 119 of 563 (encrypted)?" PORT
			#### check of encryptie
			if [ $PORT -eq 563 ]
				then
				ENC="'ssl'"
			else
				ENC="false"
			fi
			#### pas ownsettings aan
			sed -i "
				6 s/news.ziggo.nl/$USENET/
				7 s/xx/$USERNAME/
				8 s/yy/$PASSWORD/
				9 s/false;/$ENC;/
				10 s/119/$PORT/
			" $INSTALLDIR/$CONFIGFILE
			;;
		[Nn]*)
			echo "Er kunnen geen spots opgehaald worden tot je dit hebt aangepast"
			;;
		*)
			echo "Antwoord ja of nee"
			cf_Newsserver
			;;
	esac
fi
}


#### Optioneel headerserver ####
cf_Headerserver () {
if [ $IMPORTSETTINGS -eq 0 ]
	then
	echo "Wil je een aparte headerserver opgegeven?"
	echo "Let op: voor Eweka-gebruikers verplicht! Vul je hier dan textnews.eweka.nl in."
	read -p "(ja/nee): " REPLY
	case $REPLY in
		[YyJj]*)
			read -p "Wat is het usenetadres (bv. textnews.eweka.nl)?" USENET2
			read -p "Wat is de gebruikersnaam (alleen enter voor blanco)?" USERNAME2
			read -p "Wat is het wachtwoord (enter voor blanco)?" PASSWORD2
			read -p "Welk poortnummer wil je gebruiken? 119 of 563 (encrypted)?" PORT2
			#### check of encryptie
			if [ $PORT2 -eq 563 ]
				then
				ENC2="'ssl'"
			else
				ENC2="false"
			fi
			#### pas ownsettings aan
			sed -i "
				13 s/news.ziggo.nl/$USENET2/
				14 s/xx/$USERNAME2/
				15 s/yy/$PASSWORD2/
				16 s/false;/$ENC2;/
				17 s/119/$PORT2/
			" $INSTALLDIR/$CONFIGFILE
			;;
		[Nn]*)
			echo "Bij Eweka, en misschien meer providers, is dit wel een vereiste"
			;;
		*)
			echo "Antwoord ja of nee"
			cf_Headerserver
			;;
	esac
fi
}



######################################################


#### APACHESITE TOEVOEGEN ####
add_Spotweb () {
if [ -e /etc/apache2/sites-available/spotweb-site ]
	then
	echo "spotweb-site bestaat al in /etc/apache2/sites-available"
	echo "site-config importeren wordt overgeslagen"
else
	echo "Website configuratie importeren uit dropbox..."
	wget $DROPBOX/$APP/spotweb-site
	sudo cp spotweb-site /etc/apache2/sites-available/spotweb-site &&
	sudo a2ensite spotweb-site &&
	sudo a2enmod rewrite &&
	echo "Spotweb toegevoegd aan /etc/apache2/sites-enabled"
	echo "en de newznab-api toegankelijk gemaakt"
fi
}



#### HERSTART APACHE ####
restart_Ap() {
echo "Installation is klaar..."
echo "Herstart Apache om alle wijzigingen door te voeren..."
sudo /etc/init.d/apache2 restart
}


#### RETRIEVE SPOTS ####
cf_Retrieve () { # Confirm import
echo "Wil je alvast spots binnenhalen? Dit kan even duren maar is wel nodig @ first run"
read -p "(ja/nee)   :" REPLY
case $REPLY in
	[YyJj]*)
		PHP=$(which php)
		cd $INSTALLDIR &&
		$PHP upgrade-db.php &&
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
echo "Spotwebinstall klaar, ga naar: http://$HOSTNAME/spotweb en have fun"
read -sn 1 -p "Press a key to continue."
exit
}



#### ALL FUNCTIONS ####

LaSi_Logo 		#some basic info about installer
show_Author		#creator of the app installed
conn_Test		#connection test for url's used in installation
root_Test		#test user is not root but has sudo
install_Packages	#check dependencys
set_NNTP		# Pear install NNTP
set_Dir			#choose installation directory
clone_Git		#clone the git repo into $installdir
new_Config		#import or create configfile
edit_PHP        #timezone to europe/amsterdam
config_SQL      #configure mysql dbase
cf_Newsserver   #configure newsserver
cf_Headerserver #configure headerserver
add_Spotweb	#add spotweb-site to sites-available
restart_Ap      #restart apache for all changes to take effect
cf_Retrieve     #optional retrieve spots immediately
LaSi_Menu		#Return to main script


