#!/usr/bin/env bash

# Author: Mar2zz
# Email: lasi.mar2zz@gmail.com
# Blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3
#
# Forked: Kriss1981
# Email : KrissGit@gmail.com
#
# This is the main script of "Lazy Admins Scripted Installers (LaSi)"
# FreeBSD Edition
#
# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues
#  ___________________________________________________________________________________
# |
# | execute this script with the command: sudo chmod +x LaSi.sh
# | then run with ./LaSi.sh
# | 
# |
# | LaSi will install the programs you choose
# | from the menu:
# |
# | - AutoSub
# | - Beets
# | - CouchPotato
# | - Headphones
# | - LazyLibrarian (alpha stage)
# | - SABnzbd
# | - Sickbeard
# | - SpotWeb
# |
# | ############## _
# | #               \
# | # Subliminal    /_ Not available, yet!
# | # Transmission  \
# | #              _/
# | ##############
# |___________________________________________________________________________________
#
#######################################################################################
#######################################################################################

#### v0.1 ####

#######################################################################################
#######################################################################################

#####################
##### LaSi Menu #####
#####################
LaSi_Logo () {
	clear
    echo "Lazy admin Scripted installers ----------------- Mar2zz"
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
    echo "FreeBSD Edition------------------------------ Kriss1981"
}

LaSi_Menu (){
	LaSi_Logo
	echo
	echo "Make a choice to see info or install these apps..."
	echo
	echo "1. SABnzbd+  (it's recommended to first install SABnzbd+)"
	echo
	echo "2. AutoSub        6. LazyLibrarian (alpha stage)"
	echo "3. Beets          7. Sick Beard"
	echo "4. CouchPotato    8. SpotWeb"
    echo "5. Headphones     9. Transmission (incl. webinterface)"
    echo
    # tell about commandline options
    #if [ $unattended != 0 ]; then
    #    echo "Unattended installation enabled"
    #else
    #    echo "Tip: Type LaSi.sh --help for more install options!"
    #fi

    #if [ $ask_schedule = 1 ]; then
    #    echo "Cronjobs set to 'ask'."
    #elif [ $schedule != 0 ]; then
    #    echo "Cronjobs set to $schedule."
    #fi

    #echo
    echo "Q. Quit"

    read SELECT

     # create array
     items=( $SELECT )

     # go through array one by one
     for item in ${items[@]}; do

        # first check if sources need an update
        #if [ $unattended = 1 ]; then [ $update_apt = 1 ] || update_Apt; fi

        case "$item" in
        
        # Sabnzbd
        1)
			SETAPP=Sabnzbd
			APPLOW=sabnzbd
			set_port=8080
            if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
            #if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
            ;;
        # Auto-Sub
        2)
			SETAPP=AutoSub
			APPLOW=autosub
			if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
        	;;
		# beets
        3)
			SETAPP=Beets
			APPLOW=beets
			if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
			#if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
			;;
		# Couchpotato
        4)
			SETAPP=CouchPotato
			APPLOW=couchpotato
        	set_port=5000
        	if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
           	#if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
			;;
        # Headphones
        5)
			SETAPP=Headphones
			APPLOW=headphones
			set_port=8181
			if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
            #if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
            ;;
        # LazyLibrarian
        6)
			SETAPP=LazyLibrarian
			APPLOW=lazylibrarian
			set_port=5299
			if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
            #if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
            ;;
		# Sickbeard
        7)
			SETAPP=SickBeard
			APPLOW=sickbeard
        	set_port=8081
            if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
            #if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
            ;;
        # Spotweb
        8)
			SETAPP=Spotweb
            if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
            #if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
            ;;
		# subliminal
		10)
			echo
			echo "Subliminal  COMING SOON"
			sleep 2
			LaSi_Menu
			#set_app=Subliminal
			#if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
			#if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
			;;
		# transmission
		9)
			SETAPP=Transmission
			APPLOW=transmission
			set_port=9091
			if [ $unattended = 1 ]; then Install_$SETAPP; else Info_$SETAPP; fi
			;;

		[Qq]) exit ;;

		*)
			echo "Please make a selection (e.g. 1)"
			#echo "Or select multiple (e.g. 1 4 5 7 10)"
			LaSi_Menu
			;;
		esac
	done

    # see if install summary is needed, so count items in array
    if [ ${#items[@]} -gt 1 ]; then
        echo "*###############################################################*"
        echo "*################### INSTALL SUMMARY ###########################*"
        cat /tmp/LaSi/lasi_install.log
        echo "*###############################################################*"
    fi

    # give time to read output from above installprocess before returning to menu
    echo
    read -sn 1 -p "Press a key to continue"
    LaSi_Menu
}

####################
##### Auto-Sub #####
####################
Info_AutoSub () {
    clear
    echo "
*###############################################################*
*####################### Auto-Sub ##############################*
#                                                               #
# Auto-Sub is a subtitles searching module written in python    #
# that tries to find a correct match for a given video file.    #
#                                                               #
# It uses Bierdopje.com to find the correct subtitles and it    #
# runs as a daemon, checking for new subtitles every X hours.   #
#                                                               #
# Soon there will be a webinterface available                   #
#                                                               #
*###############################################################*
#                                                               #
# Auto-Sub project homepage                                     #
# https://code.google.com/p/auto-sub/                           #
#                                                               #
*###############################################################*"
    cf_Choice
}

Install_AutoSub () {
	check_App
	check_mercurial
	sudo hg clone https://code.google.com/p/auto-sub/ $USRDIR/$APPLOW &&
	sudo sed -i ".backup" 's/path = \/home\/user\/auto-sub/path = \/usr\/local\/autosub/' /usr/local/autosub/config.properties &&
    chown -R $APPUSER $USRDIR/$APPLOW
    
    if ! grep 'AutoSub.py' /etc/crontab > /dev/null; then
		sudo echo "@reboot share cd /usr/local/autosub/ && /usr/local/bin/python AutoSub.py > /dev/null" >> /etc/crontab
    fi
    
    echo
    echo "Now set your defaults in AutoSub config"
    echo "You need to change the rootpath to the path where"
    echo "your series are located"
    echo
    read -sn 1 -p "Press a key to continue"
    ee $USRDIR/$APPLOW/config.properties
    
Summ_$SETAPP
Summ_$SETAPP >> /tmp/lasi_install.log
}

Summ_AutoSub () {
clear
echo
echo "
Done! Installed $SETAPP.
Auto-Sub will automatically start at boot.
"
}

###################
##### SABnzbd #####
###################
Info_Sabnzbd () {
    clear
    echo "
*###############################################################*
*###################### SABnzbdplus ############################*
#                                                               #
# SABnzbd is an Open Source Binary Newsreader written in Python.#
#                                                               #
# It's totally free, incredibly easy to use, and works          #
# practically everywhere.                                       #
#                                                               #
# SABnzbd makes Usenet as simple and streamlined as possible by #
# automating everything we can. All you have to do is add an    #
# nzb.file and SABnzbd takes over from there, where it will be  #
# automatically downloaded, verified, repaired, extracted and   #
# filed away with zero human interaction.                       #
#                                                               #
*###############################################################*
#                                                               #
# Sabnzbdplus is written by the Sabnzbd-team                    #
#                                                               #
# Visit http://sabnzbd.org                                      #
*###############################################################*"
    cf_Choice
}

Install_Sabnzbd () {
	if ls /usr/local/bin/SABnzbd.py > /dev/null; then
		clear
		echo
		echo "SABnzbd is already installed"
		echo
		sleep 3
		Info_Sabnzbd
	else
		pkg_Choice
		if [ "$SETPKG" = "ports" ]; then
			cd /usr/ports/news/sabnzbdplus &&
			sudo make -DBATCH install clean || error_Msg
		else
			sudo pkg_add -r sabnzbdplus || error_Msg
		fi
		sudo chown -R $APPUSER $USRDIR/$APPLOW
		set_RCD
	fi

Summ_$SETAPP
Summ_$SETAPP >> /tmp/LaSi/lasi_install.log
}

Summ_Sabnzbd () {
clear
echo
echo "
Done! Installed $SETAPP.
Type sabnzbdplus --help for options
Sabnzbdplus is by default located @ http://$HOSTNAME:$set_port
"
}

#####################
##### SickBeard #####
#####################
Info_SickBeard () {
    clear
    echo "
*###############################################################*
*####################### SickBeard #############################*
#                                                               #
# Sick Beard is a PVR for newsgroup and torrent users. It       #
# watches for new episodes of your favorite shows and when they #
# are posted it downloads them, sorts and renames them, and     #
# optionally generates metadata for them.                       #
#                                                               #
# Features include:                                             #
#   - automatically retrieves new episode torrent or nzb files  #
#   - can scan your existing library and then download any      #
#     old seasons or episodes you're missing                    #
#   - can watch for better versions and upgrade your existing   #
#     episodes (from TV to DVD/BluRay for example)              #
#                                                               #
*###############################################################*
#                                                               #
# SickBeard is written by midgetspy                             #
#                                                               #
# Visit http://www.sickbeard.com                                #
*###############################################################*"
    cf_Choice
}

Install_SickBeard () {
	check_App
	check_git
    check_wget
    check_python
    sudo git clone https://github.com/midgetspy/Sick-Beard.git $USRDIR/$APPLOW &&
    sudo cp $USRDIR/$APPLOW/autoProcessTV/autoProcessTV.cfg.sample $USRDIR/$APPLOW/autoProcessTV/autoProcessTV.cfg &&
    sudo chown -R $APPUSER $USRDIR/$APPLOW &&
    sudo chmod -R 555 $USRDIR/$APPLOW/autoProcessTV &&
    sudo sed -i ".backup" 's/script_dir = ""/script_dir = \/usr\/local\/sickbeard\/autoProcessTV/' $USRDIR/sabnzbd/sabnzbd.ini
    set_RCD

Summ_$SETAPP
Summ_$SETAPP >> /tmp/LaSi/lasi_install.log
}

Summ_SickBeard () {
clear
echo
echo "
Done! Installed $SETAPP

Type sickbeard --help for options
SickBeard is by default located @ http://$HOSTNAME:$set_port

Also configured SABnzbd+ to look in the Sick Beard script folder and
created an autoProcessTV.cfg file. 

The remaining configuration is up to you and can be done using the webinterface.
"
}

#######################
##### CouchPotato #####
#######################
Info_CouchPotato () {
    clear
    echo "
*###############################################################*
*###################### CouchPotato ############################*
#                                                               #
# CouchPotato is an automatic NZB and torrent downloader.       #
# You can keep a 'movies I want'-list and it will search        #
# for NZBs/torrents of these movies every X hours.              #
#                                                               #
# Once a movie is found, it will send it to SABnzbd             #
# or download the .nzb or .torrent to a specified directory.    #
#                                                               #
*###############################################################*
#                                                               #
# CouchPotato is written by Ruud Burger in his spare time...    #
# ..so buy him a coke to support him.                           #
#                                                               #
# Visit http://www.couchpotatoapp.com                           #
*###############################################################*"
    cf_Choice
}

Install_CouchPotato () {
	check_App
	check_git
	check_wget
	check_python
    sudo git clone https://github.com/RuudBurger/CouchPotato.git $USRDIR/$APPLOW &&
    chown -R $APPUSER $USRDIR/$APPLOW
    set_RCD

Summ_$SETAPP
Summ_$SETAPP >> /tmp/LaSi/lasi_install.log
}

Summ_CouchPotato () {
clear
echo
echo "
Done! Installed $SETAPP.
Type couchpotato --help for options.
CouchPotato is by default located @ http://$HOSTNAME:$set_port
"
}

######################
##### Headphones #####
######################
Info_Headphones () {
    clear
    echo "
*###############################################################*
*###################### Headphones #############################*
#                                                               #
# Headphones is an automatic NZB downloader.                    #
# You can keep a 'musicalbums I want'-list and it will search   #
# for NZBs of these albums every X hours.                       #
#                                                               #
# It is also possible to 'follow' artists for upcoming albums.  #
#                                                               #
# Once an album is found, it will send it to SABnzbd.           #
#                                                               #
*###############################################################*
#                                                               #
# Headphones is written by Rembo10 in his spare time...         #
#                                                               #
# Visit https://github.com/rembo10/headphones                   #
*###############################################################*"
    cf_Choice
}

Install_Headphones () {
    check_App
    check_git
    check_python
    sudo git clone https://github.com/rembo10/headphones.git $USRDIR/$APPLOW &&
    chown -R $APPUSER $USRDIR/$APPLOW
    set_RCD

Summ_$SETAPP
Summ_$SETAPP >> /tmp/LaSi/lasi_install.log
}

Summ_Headphones () {
clear
echo
echo "
Done! Installed $SETAPP.
Type headphones --help for options
Headphones is by default located @ http://$HOSTNAME:$set_port
"
}

#########################
##### LazyLibrarian #####
#########################
Info_LazyLibrarian () {
    clear
    echo "
*###############################################################*
*#################### LazyLibrarian ############################*
#                                                               #
# LazyLibrarian is an automatic NZB downloader.                 #
# You can keep a 'Books I like to read'-list and it will        #
# search for NZBs of these books every X hours.                 #
#                                                               #
# Once an book is found, it will send it to SABnzbd.            #
#                                                               #
*###############################################################*
#                                                               #
# Headphones is written by Mar2zz in his spare time...          #
#                                                               #
# Visit https://github.com/Mar2zz/LazyLibrarian                 #
*###############################################################*"
    cf_Choice
}

Install_LazyLibrarian () {
    check_App
    check_git
    check_python
    sudo git clone https://github.com/Mar2zz/LazyLibrarian.git $USRDIR/$APPLOW
    chown -R $APPUSER $USRDIR/$APPLOW
    set_RCD

Summ_$SETAPP
Summ_$SETAPP >> /tmp/LaSi/lasi_install.log
}

Summ_LazyLibrarian () {
clear
echo
echo "
Done! Installed $SETAPP.

LazyLibrarian is by default located @ http://$HOSTNAME:$set_port
"
}

###############
#### BEETS ####
###############
Info_Beets () {
    clear
    echo "
*###############################################################*
*################### BEETS #####################################*
#                                                               #
# Beets is the media library management system for              #
# obsessive-compulsive music geeks.                             #
#                                                               #
# The purpose of beets is to get your music collection right    #
# once and for all. It catalogs your collection, automatically  #
# improving its metadata as it goes using the MusicBrainz       #
# database. It then provides a bouquet of tools for             #
# manipulating and accessing your music.                        #
#                                                               #
*###############################################################*
#                                                               #
# Beets is written by Adrian Sampson..                          #
#                                                               #
# Visit http://beets.radbox.org/                                #
*###############################################################*"
    cf_Choice
}

Install_Beets () {
	check_App
	check_python
    sudo git clone https://github.com/sampsyo/beets.git $USRDIR/$APPLOW &&
    cd $USRDIR/$APPLOW && /usr/local/bin/python setup.py install

    # create a configfile and databasefile
    if ! [ -e $USRDIR/$APPLOW/.beetsconfig ]; then
        echo "[beets]
        library: $USRDIR/beets/musiclibrary.blb
        directory: /home/Music
        import_copy: yes
        import_delete: yes
        import_write: yes
        import_resume: no
        import_art: yes
        import_quiet_fallback: skip
        import_timid: no
        import_log: $USRDIR/beets/beetslog.txt
        art_filename: folder
        pluginpath: $USRDIR/beets/plugins/
        plugins:
        threaded: yes
        color: yes

        [paths]
        default: \$albumartist/\$album (\$year)/\$track. \$artist - \$title
        soundtrack: Soundtracks/\$album/\$track. \$artist - \$title
        comp: Various \$genre/\$album (\$year)/\$track. \$artist - \$title
        " > $USRDIR/$APPLOW/.beetsconfig
        sed -i "" 's/^[ \t]*//' $USRDIR/$APPLOW/.beetsconfig

        echo
        echo "Now set the path to your music (directory:) in Beets config"
        read -sn 1 -p "Press a key to continue"
        ee $USRDIR/$APPLOW/.beetsconfig
    fi

Summ_$SETAPP
Summ_$SETAPP > /tmp/LaSi/lasi_install.log
}

Summ_Beets () {
clear
echo
echo "
Done! Installed $SETAPP.
Type beet --help for options
or start importing music with the following command:
# beet import /path/to/new_music
"
}

#################
#### SPOTWEB ####
#################
Info_Spotweb () {
    clear
    echo "
*###############################################################*
*####################### SPOTWEB ###############################*
#                                                               #
# SpotWeb is a webbased version of SpotNet.                     #
# It uses PHP5 to deploy most functions and has been tested on  #
# Linux and FreeBSD.                                            #
# This installer will install everything needed for Spotweb     #
# and install and configure lighttpd (webserver) and            #
# mysql-server if necessary.                                    #
#                                                               #
# Recently the application itself has been translated to the    #
# Englisch language, but the main userbase is still using Dutch.#
#                                                               #
*###############################################################*
#                                                               #
# Spotweb is created by: Spotweb e.a.                           #
# Visit https://github.com/spotweb/spotweb                      #
*###############################################################*"
    cf_Choice
}

Install_Spotweb () {
	
	install_Spotweb () {
		if [ "$WEBSRV" = "lighttpd" ]; then
			DOCUROOT=`sed -ne '/^server.document-root =/p' /usr/local/etc/lighttpd/lighttpd.conf | awk -F '"' '{ print $2 }'`
			SPOTDIR=$DOCUROOT/spotweb
		elif [ "$WEBSRV" = "apache22" ]; then
			DOCUROOT=`sed -ne '/^var.server_root =/p' /usr/local/etc/apache22/httpd.conf | awk -F '"' '{ print $2 }'`
			SPOTDIR=$DOCUROOT/spotweb
		fi
		
		if [ "$(ls -A $SPOTDIR)" ]; then
			clear
			echo
			echo "Installation folder for SpotWeb is not empty"
			echo "Assuming SpotWeb is already installed"
			echo
			sleep 3
			Info_Spotweb
		fi

		sudo git clone https://github.com/spotweb/spotweb.git $SPOTDIR &&
		sudo chown -R www:www $SPOTDIR &&
		sudo sed -i ".backup" 's/;date.timezone =/date.timezone = "Europe\/Amsterdam"/g' /usr/local/etc/php.ini &&
		sudo $RCPATH/$WEBSRV restart
	}

	config_SQL () {

        cf_SQL () {
            echo
            echo "Do you want to create a new database?"
            echo "Warning: All existing info in an existing spotwebdatabase will be lost!"
            read -p "[yes/no]: " DBREPLY
            case $DBREPLY in
                [YyJj]*)
                    input_PW
                    new_database=1
                    ;;
                [Nn]*)
                    new_database=0
                    ;;
                *)
                    echo "Answer yes or no"
                    cf_SQL
                    ;;
            esac
        }

        input_PW () {
			if [ "$SQLPASSWORD" != "" ]; then
				stty_orig=`stty -g`
				echo
				echo "What is your mySQL password?"
				stty -echo
                echo "[mysql] password:"
                read SQLPASSWORD
                stty $stty_orig
                create_DB
			else
				create_DB
			fi
        }

        create_DB () {
            MYSQL=$(which mysql)

            # check password
            if ! $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "SHOW DATABASES;" > /dev/null); then
                echo "Password is wrong, try again"
                input_PW
            fi

            # drop DB if it exists
            if $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "SHOW DATABASES;" | grep 'spotweb' > /dev/null); then
                $MYSQL mysql -u root --password="$SQLPASSWORD" -e "DROP DATABASE spotweb;" > /dev/null
            fi

            # drop USER if it exists
            if $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "select user.user from mysql.user;" | grep 'spotweb' > /dev/null); then
                $MYSQL mysql -u root --password="$SQLPASSWORD" -e "DROP USER 'spotweb'@'localhost';" > /dev/null
            fi

            # create DB
            $MYSQL mysql -u root --password="$SQLPASSWORD" -e "
            CREATE DATABASE spotweb;
            CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
            GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"

            # check if database and user is created
            if ! $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "SHOW DATABASES;" | grep 'spotweb' > /dev/null); then
                echo
                echo "Creation of database failed, try again"
                error_Msg
            fi

            if ! $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "select user.user from mysql.user;" | grep 'spotweb' > /dev/null); then
                echo
                echo "Creation of user failed, try again"
                error_Msg
            fi

            echo
            echo "Created a database named spotweb for user spotweb with password spotweb"
            echo
        }

	cf_SQL
	# Upgrade spotweb database
	cd $SPOTDIR && /usr/local/bin/php $SPOTDIR/upgrade-db.php

	Summ_Spotweb
	Summ_Spotweb >> /tmp/LaSi/lasi_install.log
	}

	cf_CronRetrieve () {
		echo
		echo "Do you want to set a hourly cronjob for retrieving spots?"
		read -p "[yes/no]: " CRONRETRIEVE
		case $CRONRETRIEVE in
			[YyJj]*)
				# check if another cronjob for this exists and remove it
				[ -e /etc/cron.hourly/spotweb_spots ] && sudo rm -f /etc/cron.hourly/spotweb_spots

				# create lasi file in correct location
				# would like to use sed for this, but can't figure out how...
echo "#!/bin/sh

# Author: Mar2zz
# Email: lasi.mar2zz@gmail.com
# Blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3

# This job is set by the Lazy admin Scripted installer

set -e

[ -x /usr/local/bin/php ] || exit 0
[ -e $SPOTDIR/retrieve.php ] || exit 0

/usr/local/bin/php $SPOTDIR/retrieve.php || exit 1
" > /tmp/LaSi/spotweb_spots

                sudo mv -f /tmp/LaSi/spotweb_spots /etc/cron.hourly/spotweb_spots
                sudo chmod +x /etc/cron.hourly/spotweb_spots

                echo
                echo "Cronjob set."
                echo "See /etc/cron.hourly/spotweb_spots."
                echo
                ;;

            [Nn]*)
                echo "You can set cronjobs yourself if you want to."
                echo "Type crontab -e for personal jobs or sudo crontab -e for root jobs."
                echo
                ;;
            *)
                echo "Answer yes or no."
                cf_CronRetrieve
                ;;
        esac
	}

	cf_Retrieve () {
		echo
		echo "Do you want to retrieve spots now?"
		read -p "[yes/no]: " RETRIEVE
		case $RETRIEVE in
			[YyJj]*)
				if [ $new_database = 1 ]; then
					echo
					echo "You need to set your newsserver and other options first in spotweb."
					echo "Go to http://$HOSTNAME/spotweb/?page=editsettings"
					echo "Login with admin / admin"
					echo "and set it at the Nieuwsserver-tab, after that, continue ..."
					read -sn 1 -p "Press a key to continue"
				fi
					echo "This will take a while!"
					sleep 2
					/usr/local/bin/php $SPOTDIR/retrieve.php
					;;
			[Nn]*)
					;;
				*)
					echo "Answer yes or no"
					cf_Retrieve
					;;
		esac
	}

	check_git
	check_WEBSRV
	check_php
	check_phpext
	check_mysql
	install_Spotweb
	config_SQL
	cf_CronRetrieve
}

Summ_Spotweb () {
clear
echo
echo "
Done! Installed SpotWeb.

SpotWeb is now located @ http://$HOSTNAME/spotweb
Go there to configure SpotWeb. Login admin:admin

After configuring run $SPOTDIR/retrieve.php to fill the database with spots
"
}

######################
#### TRANSMISSION ####
######################
Info_Transmission () {
    clear
    echo "
*###############################################################*
*##################### TRANSMISSION ############################*
#                                                               #
# Transmission is a powerfull torrentclient which can run as    #
# a daemon with a webinterface. It has a very small footprint,  #
# so it can run on devices with low cpu power and low memory.   #
#                                                               #
# Transmission has the features you want from a Torrent client: #
# encryption, a webinterface, peer exchange, magnet links, DHT, #
# µTP, UPnP and NAT-PMP port forwarding, webseed support, watch #
# directories, tracker editing, global and per-torrent          #
# speedlimits, and more.                                        #
#                                                               #
*###############################################################*
#                                                               #
# Transmission is written by volunteers.                        #
#                                                               #
# Visit http://www.transmissionbt.com/                          #
*###############################################################*"
    cf_Choice
}

Install_Transmission () {
	
	set_DOWNDIR () {
		clear
		echo
		echo "Where do you like Transmission to store your downloads?"
		echo "Enter the full path e.g. /tank/download/torrents"
		echo
		read -p 'PATH : ' DOWNDIR
		if ! ls $DOWNDIR > /dev/null; then
			sudo mkdir $DOWNDIR
			sudo chown -R $APPUSER $DOWNDIR
		fi
		echo
		echo
		echo
		echo "Last question; What is the IP-range of your network?"
		echo "Something like: 192.168.10.128"
		echo "Replace the last number with an asterix, e.g. 192.168.10.*"
		echo
		read -p 'IP-range : ' IPRANGE
		
	}

	if which transmission-daemon > /dev/null; then
		clear
		echo
		echo "Transmission is already installed on this system"
		echo
		sleep 3
		Info_$SETAPP
	else
		pkg_Choice
		if [ "$SETPKG" = "ports" ]; then
			cd /usr/ports/net-p2p/transmission-daemon &&
			sudo make -DBATCH install clean || error_Msg
		else
			sudo pkg_add -r transmission-daemon || error_Msg
		fi
		
		if ! ls $USRDIR/$APPLOW > /dev/null; then
			sudo mkdir $USRDIR/$APPLOW
		fi
		
		sudo chown -R $APPUSER $USRDIR/$APPLOW
		set_DOWNDIR
		set_RCD
	fi

Summ_$SETAPP
Summ_$SETAPP >> /tmp/lasi_install.log
}

Summ_Transmission () {
echo "
Done! Installed $SETAPP.

Transmission is by default located @ http://$HOSTNAME:9091
"
}

###############################################
######## Check System and Requirements ########
###############################################
check_Portstree() {
	
	install_Portstree() {
		clear
		LaSi_Logo
		echo
		echo
		echo "There's no Ports Tree present. It needs to be downloaded"
		echo "This operation will take a minute or five!"
		echo
		sleep 2
		echo
		echo "Are you sure you want to continue and install the Ports Tree?"
		echo "If NO, you are going back to the LaSi Menu"
		echo
		read -p "(yes/no)   :" REPLY
		case $REPLY in
			[Yy]*)
				SETPKG=ports
				echo
				echo "Let's GO!"
				echo
				sleep 2
				clear
				sudo portsnap fetch extract
				;;
			[Nn]*)
				LaSi_Menu
				;;
			[Qq]*)
				exit
				;;
			*)
				echo "Answer y to install"
				echo "n for menu"
				echo "or Q to quit"
				sleep 2
				install_Portstree
				;;
		esac
	}

	if ! ls /usr/ports > /dev/null; then
		install_Portstree
	elif find /var/db/portsnap -iname "INDEX" -mtime -1 > /dev/null; then
		SETPKG=ports
		echo
        echo "Ports Tree is up to date"
        sleep 2
	else
		SETPKG=ports
		clear
        echo
        echo "Going to update the Ports Tree"
        echo
        sleep 2
        sudo portsnap fetch update
	fi
}

install_REQ () {
	clear
	LaSi_Logo
	echo
	echo "Can't find if $REQ is installed"
	echo "This is needed to properly run $SETAPP"
	echo
	echo "Install $REQ now?"
	echo
	read -p "(yes/no)   :" REPLY
		case $REPLY in
			[Yy]*)
				if [ $REQ = "php5-extensions" ]; then
					pkg_Choice
					install_phpext
				else
					pkg_Choice
					if [ "$SETPKG" = "ports" ]; then
						if [ "$REQ" = "php" ] && [ "$WEBSRV" = "apache22" ]; then
							cd /usr/ports/lang/php5 &&
							sudo make WITH_APACHE=yes BATCH=yes install clean
						else							
							cd $REQPATH &&
							sudo make -DBATCH install clean || error_REQ
						fi
					else
						sudo pkg_add -r $REQ || error_REQ
					fi
				fi
				;;
			[Nn]*)
				Info_$SETAPP
				;;
			[Qq]*)
				exit
				;;
			*)
				echo "Answer y to install"
				echo "n for menu"
				echo "or Q to quit"
				sleep 2
				install_REQ
				;;
		esac
}

install_phpext () {
	if [ "$SETPKG" = "ports" ]; then
		clear
		echo
		echo "You're about to install php-extensions with the"
		echo "Ports Collection. This means you have to configure"
		echo "the make process to add the extensions required by Spotweb"
		echo
		echo "In the following menu add these extensions to the default"
		echo "selection by checking them:"
		echo
		echo "$PHPEXT"
		echo
		echo "After checking(space) the extensions press enter(OK)"
		echo "Then, go drink some coffee, cause this will take a while"
		echo
		read -sn 1 -p "Press a key to continue to the config menu"
		cd /usr/ports/lang/php5-extensions &&
		sudo make config &&
		sudo make BATCH=yes install clean || error_REQ
	else
		PHPEXT1=`sed -n '1p' /tmp/LaSi/php.ext`
		PHPEXT2=`sed -n '2p' /tmp/LaSi/php.ext`
		PHPEXT3=`sed -n '3p' /tmp/LaSi/php.ext`
		PHPEXT4=`sed -n '4p' /tmp/LaSi/php.ext`
		PHPEXT5=`sed -n '5p' /tmp/LaSi/php.ext`
		PHPEXT6=`sed -n '6p' /tmp/LaSi/php.ext`
		PHPEXT7=`sed -n '7p' /tmp/LaSi/php.ext`
		PHPEXT8=`sed -n '8p' /tmp/LaSi/php.ext`
		sudo pkg_add -r php5-extensions $PHPEXT1 $PHPEXT2 $PHPEXT3 $PHPEXT4 $PHPEXT5 $PHPEXT6 $PHPEXT7 $PHPEXT8 || error_REQ
	fi
}

check_git () {
	if ! which git > /dev/null; then
	REQ=git
	REQPATH=/usr/ports/devel/git
	install_REQ
	fi
}

check_wget () {
	if ! which wget > /dev/null; then
	REQ=wget
	REQPATH=/usr/ports/ftp/wget
	install_REQ
	fi
}

check_mercurial () {
	if ! which hg > /dev/null; then
	REQ=mercurial
	REQPATH=/usr/ports/devel/mercurial
	install_REQ
	fi
}

check_python () {
	if ! which python > /dev/null; then
	REQ=python
	REQPATH=/usr/ports/lang/python
	install_REQ
	fi
	
	if [ "$APPLOW" = "sickbeard" ]; then
		if ! which cheetah > /dev/null; then
		REQ=py27-cheetah
		REQPATH=/usr/ports/devel/py-cheetah
		intall_REQ
		fi
	fi
	
	if [ "$APPLOW" = "beets" ]; then
		if ! ls /usr/local/lib/python2.7/site-packages/setuptools* > /dev/null; then
		REQ=py27-setuptools
		REQPATH=/usr/ports/devel/py-setuptools
		intall_REQ
		fi
	fi
}

check_mysql () {
	set_MYSQLPW () {
		stty_orig=`stty -g`
		clear
		echo
		echo "You need to set a password for the MYSQL root user"
		echo
		stty -echo
		echo "[mysql] password:"
		read SQLPASSWORD
		stty $stty_orig
		mysqladmin -u root password $SQLPASSWORD
	}
	
	if ! which mysql > /dev/null; then
	APPLOW=mysql
	REQ=mysql55-server
	REQPATH=/usr/ports/databases/mysql55-server
	install_REQ
	set_RCD
	set_MYSQLPW
	fi
}

check_php () {
	if ! which php > /dev/null; then
	REQ=php5
	REQPATH=/usr/ports/lang/php5
	intall_REQ
	fi
}

check_phpext () {
	sudo rm -f /tmp/LaSi/php.ext &&
	sudo rm -f /tmp/LaSi/php.dext
	## Check php-extensions needed for Spotweb
	if ! grep ctype /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "CTYPE" >> /tmp/LaSi/php.dext
		fi
	if ! grep curl /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-curl" >> /tmp/LaSi/php.ext
		fi
	if ! grep dom /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "DOM" >> /tmp/LaSi/php.dext
		fi
	if ! grep gd.so /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-gd" >> /tmp/LaSi/php.ext
		fi
	if ! grep gettext /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-gettext" >> /tmp/LaSi/php.ext
		fi
	if ! grep mbstring /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-mbstring" >> /tmp/LaSi/php.ext
		fi
	if ! grep mysql /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-mysql" >> /tmp/LaSi/php.ext
		fi
	if ! grep openssl /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-openssl" >> /tmp/LaSi/php.ext
		fi
	if ! grep xml /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "XML" >> /tmp/LaSi/php.dext
		fi
	if ! grep zip /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-zip" >> /tmp/LaSi/php.ext
		fi
	if ! grep zlib /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-zlib" >> /tmp/LaSi/php.ext
		fi
	## any ?
	if ls /tmp/LaSi/php.ext > /dev/null; then
		PHPEXT=`cat /tmp/LaSi/php.ext`
		REQ=php5-extensions
		REQPATH=/usr/ports/lang/php5-extensions
		install_REQ
		fi
}

check_WEBSRV () {
	
	cf_Webserver () {
		clear
		LaSi_Logo
		echo
		echo "There's is NO webserver installed on this system"
		echo "A webserver is needed to run $SETAPP"
		echo
		echo "Which webserver do you like to install?"
		echo
		echo "Options:"
		echo
		echo "1. Lighttpd"
		echo "2. Apache"
		echo
		echo "B. Back to Info"
		echo "Q. Quit"
		read SELECT
		case "$SELECT" in
			1)
				WEBSRV=lighttpd
				APPLOW=lighttpd
				cf_Installweb
				;;
			2)
				WEBSRV=apache22
				APPLOW=apache22
				cf_Installweb
				;;
			[Bb]*)
				Info_$SETAPP
				;;
			[Qq]*)
				exit
				;;
			*)
				echo "Please choose..."
				cf_Webserver
				;;
		esac
	}

	cf_Installweb () {
		echo
		echo "Are you sure you want to continue and install $APPLOW?"
		read -p "[yes/no]: " REPLY
		echo
		case $REPLY in
			[Yy]*)
				Install_WEBSRV
				;;
			[Nn]*)
				Info_$SETAPP
				;;
			[Qq]*)
				exit
				;;
			*)
				echo "Answer yes to install"
				echo "no for menu"
				echo "or Q to quit"
				cf_Installweb
				;;
		esac
	}

	install_WEBSRV () {
		pkg_Choice
		if [ "$SETPKG" = "ports" ]; then
			cd /usr/ports/www/$WEBSRV &&
			sudo make -DBATCH install clean || error_REQ
		else
			sudo pkg_add -r $WEBSRV || error_REQ
		fi
		
		if [ "$WEBSRV" = "apache22" ]; then
			check_php
			sed -i ".backup" 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /usr/local/etc/apache22/httpd.conf &&
			echo AddType application/x-httpd-php .php > /usr/local/etc/apache22/Includes/php5.conf &&
			echo AddType application/x-httpd-php-source .phps >> /usr/local/etc/apache22/Includes/php5.conf
		fi
		set_RCD
	}

	if which lighttpd > /dev/null; then
		WEBSRV=lighttpd
	elif which apache > /dev/null; then
		WEBSRV=apache22
	else
		cf_Webserver
	fi
}

check_Log () {
    # remove any previous lasi_install logs
    rm -f /tmp/LaSi/lasi_install.log
}

check_App () {
	if pgrep -f $SETAPP.py > /dev/null; then
		clear
		echo
		echo "$SETAPP is already running on this system"
		echo
		sleep 3
		LaSi_Menu
	elif [ "$(ls -A $USRDIR/$APPLOW)" ]; then
		clear
		echo
		echo "Installation folder for $SETAPP is not empty"
		echo "Assuming $SETAPP is already installed"
		echo
		sleep 3
		LaSi_Menu
	fi
}

check_Port () {
    #check if ports are in use before starting
    if lsof -i tcp@0.0.0.0:$set_port > /dev/null; then
        # ask if user want's to set another port
        echo
        echo "$SETAPP runs on http://$HOSTNAME:$set_port by default,"
        echo "but that is in use allready."
        echo "Trying other ports to run on..."

        # starting a +100 loop to find next availabe port
        while lsof -i tcp@0.0.0.0:$set_port > /dev/null; do
            set_port=$(($set_port +100))
        done

        # new port found, now set it
        echo "$set_port is free, $SETAPP wil be set to use it."

        # uncapitalize programname
        SETAPPLOWer=$(echo $SETAPP | tr '[A-Z]' '[a-z]')

        # edit configfile to set new port
        sudo sed -i "
            /=/s/PORT.*/PORT=$set_port/
        " /etc/default/$SETAPPLOWer
        echo "Port $set_port is set in /etc/default/$SETAPPLOWer..."
        echo "This will always override ports set in config.ini or webinterface!"
    fi
}

##### HELP MESSAGE #####
Print_Help () {
    echo '
usage: ./LaSi.sh --options

OPTIONS:
    --fast | -f         : install unattended (no info shown and no confirmations needed)
                          (note: Beets, Spotweb and XBMC can ask questions)
    --purge | -p        : instead of removing an application purge it. Purge also
                          removes the daemon and deamon-settingsfile and cronjobs if set.

    --cronjob=value     : value can be ask|hourly|daily|weekly|monthly

                          ask; for every installed app ask how often to check for updates

                          hourly|daily|weekly|monthly; set cronjobs unattended during install
                          to check for updates hourly|daily|weekly|monthly

    --help | -h         : Print this helpmessage'
    exit
}

check_Variables () {
    # check if input is correct and set them
    for option in ${options[@]}; do

        case $option in

            --help|-h)
                    Print_Help
                    ;;

            --fast|-f)
                    unattended=1
                    ;;

            --purge|-p)
                uninstaller=purge
                ;;

            --cronjob*)
                crontime=$(echo $option | sed 's/--cronjob=//')

                case $crontime in
                    ask)
                        ask_schedule=1 ;;
                    hourly)
                        schedule=hourly ;;
                    daily)
                        schedule=daily ;;
                    weekly)
                        schedule=weekly ;;
                    monthly)
                        schedule=monthly ;;
                    *)
                        echo "Incorrect value: echo $schedule."
                        Print_Help
                        ;;
                esac
                ;;

            *)
                echo "Incorrect value: $option"
                Print_Help
                ;;

        esac
    done
}

Select_USER () {

	local CUSER=`whoami`
	LaSi_Logo
	echo
	echo "WELCOME!  First you have to choose which user will be running"
	echo "the apps, then you'll be forwarded to the actual menu"
	echo
	echo "Options (1,2,3,Q + enter):"
	echo
	echo "1. share    (recommended for ZFSguru with FreeBSD 9 core)"

	if [ "$(id -u)" = "0" ]; then
		echo "2. $CUSER     (current user)"
		echo "3. Other user"
		echo
		echo "It's NOT recommended to run these programs as root"

	else
		echo "2. $CUSER   (current user)"
		echo "3. Other user"
	fi
	echo
	echo "Q. Quit"
	read SELECT
	case "$SELECT" in
		[1]*)
			APPUSER=share
			;;
		[2]*)
			APPUSER=$CUSER
			;;
		[3]*)
			echo
			read -p 'User : ' APPUSER
			;;
		[Qq]*)
			clear
			exit
			;;
		*)
			echo
			echo "Please make a selection"
			Select_USER
			;;
	esac
}

#######################################
######## BACKTOMENU OR INSTALL ########
#######################################
cf_Choice () {
	case $SETAPP in
	Sabnzbdplus|Transmission)
		echo
		echo "Options:"
		echo "1. Install $SETAPP"
		echo "2. Uninstall $SETAPP"
		echo
		echo "B. Back to menu"
		echo "Q. Quit"
		;;
	*)
		echo
		echo "Options:"
		echo "1. Install $SETAPP"
		echo "2. Remove $SETAPP"
		echo "3. Set cronjob for $SETAPP  <= not available, YET"
		echo
		echo "B. Back to menu"
		echo "Q. Quit"
		;;
	esac

    read SELECT
    case "$SELECT" in
        1)
            cf_Install
            ;;
        2)
			if [ "$SETAPP" = "Spotweb" ] || [ "$SETAPP" = "AutoSub" ]; then
				echo
				echo "Uninstaller for $SETAPP is not available, yet!"
				Info_$SETAPP
			else
				Uninstaller
			fi
            ;;
        3)
            case $SETAPP in
                Sabnzbdplus|Transmission)
                    cf_Choice ;;
                *)
                    cf_Cronjob ;;
            esac
            ;;
        [Bb]*)
            LaSi_Menu
            ;;
        [Qq]*)
            exit
            ;;
        *)
            echo "Please choose..."
            cf_Choice
            ;;
    esac
}

cf_Install () {
    echo
    echo "Are you sure you want to continue and install $SETAPP?"
    read -p "[yes/no]: " REPLY
    echo
    case $REPLY in
    [Yy]*)
        Install_$SETAPP
        # give time to read output from above installprocess before returning to menu
        echo
        read -sn 1 -p "Press a key to continue"
        # for multiple install continue in next item, else back to info
        if [ "${#items[@]}" = 1 ]; then
        LaSi_Menu
        fi
        ;;
    [Nn]*)
        LaSi_Menu
        ;;
    [Qq]*)
        exit
        ;;
    *)
        echo "Answer yes to install"
        echo "no for menu"
        echo "or Q to quit"
        cf_Install
        ;;
    esac
}

##### Chose Ports Tree or PKG system #####
pkg_Choice() {
	if ! [ "$SETPKG" = "pkg" ] || [ "$SETPKG" = "ports" ]; then
	clear
	LaSi_Logo
	echo
	echo "How do you like to install your software?"
	echo "Use the Ports Collection or the Packages System"
	echo
	echo "If you don't know what I'm talking about, take a look at:"
	echo "http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/ports-overview.html"
	echo
	echo "Options:"
	echo
	echo "1. Ports Collection  <= RECOMMENDED"
	echo "2. Package System    <= Faster installation than Ports"
	echo
	echo "B. Back to menu"
	echo "Q. Quit"
	read SELECT
		case "$SELECT" in
			[1]*)
				check_Portstree
				;;
			[2]*)
				SETPKG=pkg
				;;
			[Bb]*)
				LaSi_Menu
				;;
			[Qq]*)
				exit
				;;
			*)
				echo "Please choose..."
				echo
				pkg_Choice
				;;
		esac
	fi
}

##### Un-Installer #####
Uninstaller () {
	echo 
    echo "Are you sure you want to continue and remove/uninstall $SETAPP?"
    read -p "[yes/no]: " REPLY
    echo
    case $REPLY in
    [Yy]*)
        case $SETAPP in
            Sabnzbd|Transmission)
				sudo $RCPATH/$APPLOW stop
				sudo sed -i ".backup" "/$APPLOW/d" /etc/rc.conf
				pkg_delete "$APPLOW*" || error_Msg
				;;
            *)
				if ls $RCPATH/$APPLOW > /dev/null; then
					if pgrep -f $SETAPP.py > /dev/null; then
						$RCPATH/$APPLOW stop
						sudo sed -i ".backup" "/$APPLOW/d" /etc/rc.conf
					fi					
					APPDIR=`sed -n "/"$APPLOW"_dir:=/p" $RCPATH/$APPLOW | awk -F '"' '{ print $2 }'`
				fi 
				
				if ls $APPDIR > /dev/null; then
					sudo rm -rf $APPDIR
				else
					echo "Can't find $SETAPP installation folder"
					error_Msg
				fi
            ;;
        esac
        # give time to read output from above installprocess before returning to menu
        echo 
		echo "$SETAPP has been removed from this system"
		echo
        read -sn 1 -p "Press a key to continue"
        # for multiple install continue in next item, else back to info
        if [ "${#items[@]}" = 1 ]; then
            Info_$SETAPP
        fi
        ;;
    [Nn]*)
        Info_$SETAPP
        ;;
    [Qq]*)
        exit
        ;;
    *)
        echo "Answer yes to $uninstaller" 
        echo "no for menu"
        echo "or Q to quit"
        cf_Install
        ;;
    esac
}

##### CRONJOBS #####
cf_Cronjob () {
	clear
	echo
	echo "Set cronjob NOT available, Yet!"
	sleep 3
	Info_$SETAPP
}

##### FreeBSD rc.d Script #####
set_RCD () {
	if ! [ "$APPLOW" = "apache" ] || [ "$APPLOW" = "lighttpd" ] || [ "$APPLOW" = "mysql" ]; then
		if ! ls $RCPATH/$APPLOW > /dev/null; then
			cd $RCPATH &&
			sudo fetch $DROPBOX/$SETAPP/$APPLOW &&
			sudo sed -i "" "s/USERNAME/$APPUSER/g" $RCPATH/$APPLOW
			if [ "$APPLOW" = "transmission" ]; then
				sudo sed -i "" "s|DOWNDIR|$DOWNDIR|g" $RCPATH/$APPLOW &&
				sudo sed -i "" "s|IPRANGE|$IPRANGE|g" $RCPATH/$APPLOW
			fi
			sudo chmod 555 $RCPATH/$APPLOW
		else
			cd $RCPATH &&
			sudo mv -f $APPLOW $APPLOW.backup &&
			sudo fetch $DROPBOX/$SETAPP/$APPLOW &&
			sudo sed -i "" "s/USERNAME/$APPUSER/g" $RCPATH/$APPLOW
			if [ "$APPLOW" = "transmission" ]; then
				sudo sed -i "" "s|DOWNDIR|$DOWNDIR|g" $RCPATH/$APPLOW &&
				sudo sed -i "" "s|IPRANGE|$IPRANGE|g" $RCPATH/$APPLOW
			fi
			sudo chmod 555 $RCPATH/$APPLOW
		fi
	fi

	if ! grep ''$APPLOW'_enable="YES"' /etc/rc.conf > /dev/null; then
		sudo echo ''$APPLOW'_enable="YES"' >> /etc/rc.conf
			if [ "$APPLOW" = "mysql" ]; then
				APPLOW=mysql-server
			fi
		sudo $RCPATH/$APPLOW start || error_Msg
	elif [ "$APPLOW" = "mysql" ]; then
		APPLOW=mysql-server
		sudo $RCPATH/$APPLOW restart || error_Msg
	else
		sudo $RCPATH/$APPLOW restart || error_Msg
	fi
}

#########################
##### ERROR HANDLING ####
#########################
error_Msg () {
# show error message
echo "
Failed! Installing $SETAPP didn't finish, try again or:
Copy the text above and report an issue at the following address:
https://github.com/Mar2zz/LaSi/issues
"
# log error message
echo "
Failed! Installing $SETAPP had errors, try again or:
Copy the text with errors above and report an issue at the following address:
https://github.com/Mar2zz/LaSi/issues
" >> /tmp/LaSi/lasi_install.log

# for fast install continue in next item, else quit installer
if [ "${#items[@]}" > 1 ]; then continue; else break; fi
}

error_REQ () {
# failed requirements
echo
echo "Failed! Installing $REQ didn't finish, try again or:
Copy the text above and report an issue at the following address:
https://github.com/Mar2zz/LaSi/issues"
# log error message
echo "
Failed! Installing $REQ had errors" >> /tmp/LaSi/lasi_install.log
exit
}

######################################
######### Start Running LaSi #########
######################################

##### Set Variables and Defaults #####

DROPBOX=http://dl.dropbox.com/u/36835219/LaSi/FreeBSD

USRDIR=/usr/local			# Installation folder
RCPATH=/usr/local/etc/rc.d

# defaults
unattended=0
ask_schedule=0
schedule=0

# create array
options=( $@ )


##### Check if user can sudo #####
if [ "$(id -u)" != "0" ]; then
	if [ "`whoami`" = "ssh" ];then
		su
	else
		echo "Provide sudo password to continue with this installation..."
		if [ "$(sudo id -u)" != "0" ]; then
			clear
			echo
			echo "The current user can't sudo,"
			echo
			echo "this installer needs to sudo to install applications"
			echo "You need to perform this command: "EDITOR=ee visudo""
			echo "and uncomment the following line: %wheel ALL=(ALL) ALL"
			echo
			sleep 2
			exit
		fi
	fi
fi

##### check if OS is FreeBSD #####
if [ "`uname`" != "FreeBSD" ]; then
	clear
	echo
	echo "I'm Sorry,"
	echo "This installer is written for FreeBSD based distros only!"
	echo
	sleep 2
	exit
fi

##### RUN ALL FUNCTIONS #####
check_Variables	# checks for fast install and cronjob options which can be set @ commandline
check_Log		# Shows an installsummary if multiple programs were installed.
Select_USER		# Select which user runs the apps
LaSi_Menu		# Show menu
