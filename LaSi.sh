#!/usr/bin/env bash

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3
#
# This is the main script of "Lazy Admins Scripted Installers (LaSi)"
#
# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues
#  ___________________________________________________________________________________
# |
# | execute this script with the command: sudo chmod +x LaSi.sh 
# | then run with ./LaSi.sh
# |
# | LaSi will install the programs you choose
# | from the menu:
# | # Sickbeard
# | # CouchPotato
# | # Subliminal
# | # AlbumIdentify 
# | # Spotweb
# | # Headphones
# | # Transmission
# | # XBMC
# |___________________________________________________________________________________
#
# Tested succesful on OS's:
# Ubuntu 9.10 and higher and XBMC Live Dharma
# 32bit and 64bit OS compatible
#
#######################################################################################
#######################################################################################

#### v1.9 ####

#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

DROPBOX=http://dl.dropbox.com/u/18712538/           # dropbox-adres
CONN2=dropbox.com                                   # to test connections needed


#######################################################################################
#######################################################################################
#######################################################################################

LaSi_Menu (){
    
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


    show_Menu () {
        echo "Make a choice to see info or install these apps..."

        echo "1. Beets                  6. SickBeard"
        echo "2. CouchPotato            7. Spotweb"
        echo "3. Headphones             8. Subliminal"
        echo "4. Mediafrontpage         9. Tranmission"
        echo "5. Sabnzbdplus           10. XBMC (desktop)"
        echo
        echo "Q. Quit"

        read SELECT

        case "$SELECT" in
            1)
                info_Beets
                ;;
            2*)
                info_CouchPotato
                ;;
            3*)
                info_Headphones
                ;;
            4*)
                info_Mediafrontpage
                ;;
            5*)
                info_Sabnzbdplus
                ;;
            6*)
                info_SickBeard
                ;;
            7*)
                info_Spotweb
                ;;
            8*)
                info_Subliminal
                ;;
            9*)
                info_Transmission
                ;;
            10*)
                info_XBMC
                ;;
            [Qq]*)
                exit
                ;;
            *)
                echo "Please make a selection (e.g. 1)"
                echo
                show_Menu
                ;;
        esac
    }
    show_Menu
}



#### BEETS ####

info_Beets () {
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
    SET_APP=Beets
    cf_Choice
}


#### COUCHPOTATO ####

info_CouchPotato () {
    clear
    echo "
*###############################################################*
*###################### COUCHPOTATO ############################*
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
    SET_APP=CouchPotato
    cf_Choice
}


#### HEADPHONES ####

info_Headphones () {
    clear
    echo "
*###############################################################*
*###################### HEADPHONES #############################* 
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
    SET_APP=Headphones
    cf_Choice
}


#### MEDIAFRONTPAGE ####

info_Mediafrontpage () {
    clear
    echo "
*###############################################################*
*###################### MEDIAFRONTPAGE #########################*
#                                                               #
# MediaFrontPage is a HTPC Web Program Organiser. Your HTPC     #
# utilises a number of different programs to do certain tasks.  #
# What MediaFrontPage does is creates a user specific web page  #
# that will be your nerve centre for everything you will need.  #
#                                                               #
*###############################################################*
#                                                               #
# Mediafrontpage is written by Nick8888 and others              #
#                                                               #
# Visit https://github.com/Mediafrontpage/mediafrontpage        #
*###############################################################*"
    SET_APP=Mediafrontpage
    cf_Choice
}


#### SABNZBDPLUS ####

info_Sabnzbdplus () {
    clear
    echo "
*###############################################################*
*###################### SABNZBDPLUS ############################*
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
    SET_APP=Sabnzbdplus
    cf_Choice
}


#### SICKBEARD ####

info_SickBeard () {
    clear
    echo "
*###############################################################*
*####################### SICKBEARD #############################*
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
    SET_APP=SickBeard
    cf_Choice
}


#### SPOTWEB ####

info_Spotweb () {
    clear
    echo "
*###############################################################*
*####################### SPOTWEB ###############################*
#                                                               #
# SpotWeb is een versie van SpotNed voor een webserver          #
# Het gebruikt PHP5 om de meeste functies te implementeren      #
# en is getest op Linux en FreeBSD.                             #
#                                                               #
# Deze installer installeert alle benodigdheden voor Spotweb.   #
# en installeert en configureert een apache/mysql-server indien #
# dat nodig is.                                                 #
#                                                               #
*###############################################################*
#                                                               #
# Spotweb is geschreven door Spotweb e.a.                       #
#                                                               #
# Visit https://github.com/spotweb/spotweb                      #
*###############################################################*"
    SET_APP=Spotweb
    cf_Choice
}


#### SUBLIMINAL ####

info_Subliminal () {
    clear
    echo "
*###############################################################*
*###################### SUBLIMINAL #############################*
#                                                               #
# Subliminal is a subtitles searching module written in python  #
# that tries to find a correct match for a given video file.    #
# The goal behind subliminal is that it will only return only   #
# correct subtitles so that you can simply relax and            #
# enjoy your video without having to double-check that          #
# the subtitles match your video before watching it.            #
#                                                               #
# It works great in a sabnzbd-postprocessingscript or when set  #
# as a cronjob. Also checkout Sickbeards Subliminal branch!     #
#                                                               #
*###############################################################*
#                                                               #
# Subliminal is written by Diaoul and based on Patrick's        #
# Periscope. (http://code.google.com/p/periscope/)              #
#                                                               #
# https://github.com/Diaoul/subliminal                          #
*###############################################################*"
    SET_APP=Subliminal
    cf_Choice
}


#### TRANSMISSION ####

info_Transmission () {
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
    SET_APP=Transmission
    cf_Choice
}


#### XBMC ####

info_XBMC () {
clear
echo "
*###############################################################*
*############################# XBMC ############################*
#                                                               #
# XBMC is an award-winning free and open source (GPL) software  #
# media player and entertainment hub for digital media.         #
#                                                               #
# Created in 2003 by a group of like minded programmers,        #
# XBMC is a non-profit project run and developed by volunteers  #
# located around the world.                                     #
#                                                               #
# More than 50 software developers have contributed to XBMC,    #
# and 100-plus translators have worked to expand its reach,     #
# making it available in more than 30 languages.                #
#                                                               #
*###############################################################*
#                                                               #
# XBMC is written by the XBMC-Team                              #
#                                                               #
# Visit http://www.xbmc.org                                     #
*###############################################################*"
SET_APP=XBMC
cf_Choice
}


#### BACKTOMENU OR INSTALL ####
cf_Choice () {
    echo
    echo "Options:"
    echo "1. Install $SET_APP"
    echo "2. Back to menu"
    echo "Q. Quit"

    read SELECT
    case "$SELECT" in
        1*)
            inst_App
            ;;
        2*)
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


### ERROR HANDLING ####
error_Msg () {
    echo 
    echo "########################################################################"
    echo "#  Fail! Installation didn't finish, try again or:                     #"
    echo "#  Copy the text above and report an issue at the following address:   #"
    echo "#  https://github.com/Mar2zz/LaSi/issues                               #"
    echo "########################################################################"
    exit 1
}


#### INSTALL APPLICATION
inst_App () {

    get_Installer () {
    # remove any existing .deb files in tmp
    rm -f /tmp/*.deb
    
    # install git for benefits like updating from commandline
    if ! which git > /dev/null; then
        sudo apt-get -y install git
    fi

    # install apps: Alphabetical ordered applist with installcommands.
    case $SET_APP in

        Beets)

            sudo apt-get -y install python-pip || error_Msg
            sudo pip install beets || error_Msg
            sudo pip install rgain || echo "Fail!"

            # Enable replaygain which is healthy for ears and speakers (TEMP DISABLED)
            if ! [ -d $HOME/.beets/plugins ]; then
                mkdir -p $HOME/.beets/plugins || echo "Fail, could not create $HOME/.beets/plugins!"
                # git clone https://github.com/Lugoues/beets-replaygain.git $HOME/.beets/plugins/replaygain || echo "git clone for replaygain failed, install manual" commented because it doesn't work
            fi

            # create a configfile and databasefile
            if ! [ -e $HOME/.beetsconfig ]; then
                echo "[beets]
                library: $HOME/.beets/musiclibrary.blb
                directory: $HOME/Music
                import_copy: yes
                import_delete: yes
                import_write: yes
                import_resume: no
                import_art: yes
                import_quiet_fallback: skip
                import_timid: no
                import_log: $HOME/.beets/beetslog.txt
                art_filename: folder
                pluginpath: $HOME/.beets/plugins/
                plugins:
                threaded: yes
                color: yes

                [paths]
                default: \$albumartist/\$album (\$year)/\$track. \$artist - \$title
                soundtrack: Soundtracks/\$album/\$track. \$artist - \$title
                comp: Various \$genre/\$album (\$year)/\$track. \$artist - \$title

                [replaygain]
                reference_loundess: 89
                mp3_format: mp3gain " > $HOME/.beetsconfig
                sed -i 's/^[ \t]*//' $HOME/.beetsconfig

                echo
                echo "Now set your defaults in Beets config"
                read -sn 1 -p "Press a key to continue"
                editor $HOME/.beetsconfig
            fi

            echo 
            echo "Done!"
            echo "Type beet --help for options"
            echo "or start importing with beet import -q /path/to/new_music"
            ;;

        CouchPotato)

            wget -O /tmp/couchpotato.deb $DROPBOX/LaSi_Repo/couchpotato.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
            if sudo dpkg -i /tmp/couchpotato.deb || error_Msg | grep "/etc/default/couchpotato"; then
                sudo sed -i "
                    s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
                    s/RUN_AS.*/RUN_AS=$USER/
                    s/WEB_UPDATE=0/WEB_UPDATE=1/g
                " /etc/default/couchpotato
                echo "Changed daemon settings..."
                sudo /etc/init.d/couchpotato start || error_Msg
            fi

            echo 
            echo "Done!"
            echo "Type couchpotato --help for options."
            echo "CouchPotato is by default located @ http://$HOSTNAME:5000"
            ;;

        Headphones)
            wget -O /tmp/headphones.deb $DROPBOX/LaSi_Repo/headphones.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
            if sudo dpkg -i /tmp/headphones.deb || error_Msg | grep '/etc/default/headphones'; then
                sudo sed -i "
                    s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
                    s/RUN_AS.*/RUN_AS=$USER/
                    s/WEB_UPDATE=0/WEB_UPDATE=1/g
                " /etc/default/headphones
                echo "Changed daemon settings..."
                sudo /etc/init.d/headphones start || error_Msg
            fi

            echo 
            echo "Done!"
            echo "Type headphones --help for options"
            echo "Headphones is by default located @ http://$HOSTNAME:8181"
            ;;

        Mediafrontpage)
            wget -O /tmp/mediafrontpage.deb $DROPBOX/LaSi_Repo/mediafrontpage.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
            sudo dpkg -i /tmp/mediafrontpage.deb || error_Msg

            echo 
            echo "Mediafrontpage is now located @ http://$HOSTNAME/mediafrontpage"
            ;;

        Sabnzbdplus)
            # Check if ppa is used as a source
            if ! ls /etc/apt/sources.list.d/jcfp-ppa* > /dev/null; then
                sudo add-apt-repository ppa:jcfp/ppa
            fi

            # Update list, install and configure
            echo "Checking for newest version..."
            sudo apt-get update > /dev/null
            if sudo apt-get -y install sabnzbdplus || error_Msg| grep '/etc/default/sabnzbdplus'; then
                sudo sed -i "
                    /=/s/USER.*/USER=$USER/
                    /=/s/HOST.*/HOST=0.0.0.0/
                " /etc/default/sabnzbdplus
                echo "Changed daemon settings..."
                sudo /etc/init.d/sabnzbdplus start || error_Msg
            fi

            echo 
            echo "Done!"
            echo "Type sabnzbdplus --help for options"
            echo "Sabnzbdplus is by default located @ http://$HOSTNAME:8080"
            ;;

        SickBeard)
            sudo apt-get -y install python-cheetah || error_Msg
            wget -O /tmp/sickbeard.deb $DROPBOX/LaSi_Repo/sickbeard.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
            if sudo dpkg -i /tmp/sickbeard.deb || error_Msg | grep "/etc/default/sickbeard"; then
                sudo sed -i "
                    s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
                    s/RUN_AS.*/RUN_AS=$USER/
                    s/WEB_UPDATE=0/WEB_UPDATE=1/g
                " /etc/default/sickbeard
                echo "Changed daemon settings..."
                sudo /etc/init.d/sickbeard start || error_Msg
            fi

            echo 
            echo "Done!"
            echo "Type sickbeard --help for options"
            echo "SickBeard is by default located @ http://$HOSTNAME:8081"
            ;;

        Spotweb)
            sudo apt-get -y install apache2 php5 php5-curl php5-mysql mysql-server php-pear || error_Msg
            sudo pear install Net_NNTP
            sudo sed -i "s#;date.timezone =#date.timezone = \"Europe/Amsterdam\"#g" /etc/php5/apache2/php.ini
            sudo sed -i "s#;date.timezone =#date.timezone = \"Europe/Amsterdam\"#g" /etc/php5/cli/php.ini

            # this function creates a mysql database for spotweb
            config_SQL () {

                cf_SQL () {
                    echo
                    echo "Do you want to create a new database?"
                    echo "Warning: All existing info in an existing spotwebdatabase will be lost!"
                    read -p "[yes/no]: " DBREPLY
                    case $DBREPLY in
                        [YyJj]*)
                            input_PW
                            ;;
                        [Nn]*)
                            ;;
                        *)
                            echo "Answer yes or no"
                            cf_SQL
                            ;;
                    esac
                }

                input_PW () {
                    stty_orig=`stty -g`
                    echo
                    echo "What is your mySQL password?"

                    # hide password when typed
                    stty -echo
                        echo "[mysql] password:"
                        read SQLPASSWORD
                    stty $stty_orig

                    create_DB
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
            }

            config_SQL

            wget -O /tmp/spotweb.deb $DROPBOX/LaSi_Repo/spotweb.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
            sudo dpkg -i /tmp/spotweb.deb || error_Msg

            # change servername to hostname in ownsettings if it's still default.
            sudo sed -i "s/mijnserver/$HOSTNAME/g" /etc/default/spotweb/ownsettings.php

            # update database
            cd /var/www/spotweb && /usr/bin/php /var/www/spotweb/upgrade-db.php
            cd - > /dev/null

            echo 
            echo "Done!"
            echo "Spotweb is now located @ http://$HOSTNAME/spotweb"
            echo "Run /var/www/spotweb/retrieve.php to fill the database with spots"

            cf_Retrieve () {
                echo
                echo "Do you want to retrieve spots now?"
                read -p "[yes/no]: " RETRIEVE
                case $RETRIEVE in
                    [YyJj]*)
                        echo "This will take a while!"
                        cd /var/www/spotweb && /usr/bin/php /var/www/spotweb/retrieve.php
                        cd - > /dev/null
                        ;;
                    [Nn]*)
                        ;;
                    *)
                        echo "Answer yes or no"
                        cf_Retrieve
                        ;;
                esac
            }
            cf_Retrieve
            ;;

        Subliminal)
            sudo apt-get -y install python-pip || error_Msg
            sudo pip install subliminal || error_Msg
            sudo pip install argparse || error_Msg

            echo 
            echo "Done!"
            echo "Type subliminal --help for options"
            ;;

        Transmission)
            sudo apt-get -y install transmission-daemon || error_Msg
            sudo /etc/init.d/transmission-daemon stop > /dev/null || error_Msg

            # replace running user to user and configdir with home-dir (default dir sucks for configs)
            sudo sed -i "s/USER=debian-transmission/USER=$USER/g" /etc/init.d/transmission-daemon
            sudo sed -i "s#CONFIG_DIR=\"/var/lib/transmission-daemon/info\"#CONFIG_DIR=\"$HOME/.transmission\"#g" /etc/default/transmission-daemon

            # start-stop to create config at new location
            sudo /etc/init.d/transmission-daemon start > /dev/null || error_Msg
            sudo /etc/init.d/transmission-daemon stop > /dev/null || error_Msg

            # download a blocklist to hide from nosy capitalists
            wget -O $HOME/.transmission/blocklists/level1.gz http://rps8755.ovh.net/blocklists/level1.gz || echo "Downloading blocklist failed, try again later"
            if [ -e $HOME/.transmission/blocklists/level1.gz ]; then
                gunzip -f $HOME/.transmission/blocklists/level1.gz
            fi

            # edit settings.json
            echo "You need to change these options in the settingsfile"
            echo "to gain access to the webinterface."
            echo "Credentials:"
            echo "\"rpc-password\": \"password_webinterface\","
            echo "\"rpc-username\": \"username_webinterface\","
            echo
            echo "IP-adresses from which you want to connect from"
            echo "\"rpc-whitelist\": \"127.0.0.1,192.168.1.*\","
            # give time to read output from above installprocess before returning to menu
            echo
            read -sn 1 -p "Press a key to edit the $HOME/.transmission/settings.json"
            editor $HOME/.transmission/settings.json

            # start with all new settings
            sudo /etc/init.d/transmission-daemon start || error_Msg

            echo 
            echo "Done!"
            echo "Type tranmission-daemon --help for options"
            echo "Transmission is by default located @ http://$HOSTNAME:9091"
            ;;

        XBMC)
            # remove source to prevent installing wrong version
            if ls /etc/apt/sources.list.d | grep "team-xbmc*" > /dev/null; then
                sudo rm -f /etc/apt/sources.list.d/team-xbmc*
            fi

            # ask which source to use
            Question () {
                echo "Choose a version to install"
                echo "1. Stable"
                echo "2. Unstable, but has newer features"
                read -p ": " VERSION
                case $VERSION in
                    1*)
                        sudo add-apt-repository ppa:team-xbmc || error_Msg
                        distro=$(ls /etc/apt/sources.list.d/team-xbmc* | sed "s/.*ppa-\|\.list//g")
                        ;;
                    2*)
                        sudo add-apt-repository ppa:team-xbmc/unstable || error_Msg
                        distro=$(ls /etc/apt/sources.list.d/team-xbmc* | sed "s/.*unstable-\|\.list//g")
                        ;;
                    *)
                        echo "Answer 1 or 2"
                        Question
                        ;;
                esac
            }
            Question

            # Highest available distro is Maverick, change oneiric, natty and precise to maverick
            ppa=$(ls /etc/apt/sources.list.d/team-xbmc*)
            case $distro in
                oneiric|natty|precise)
                sudo sed -i "s/$distro/maverick/g" $ppa
                ;;
            esac

            # Update list, install and configure
            echo "Checking for newest version..."
            sudo apt-get update > /dev/null
            case $VERSION in
                1*)
                    sudo apt-get -y install xbmc xbmc-standalone || error_Msg
                    echo
                    echo "Done!"
                    echo "XBMC can now be started from the menu"
                    echo "or can be set in the loginscreen as a desktopmanager."
                    ;;
                2*)
                    sudo apt-get -y install xbmc || error_Msg
                    echo
                    echo "Done!"
                    echo "XBMC can now be started from the menu"
                    ;;
            esac
            ;;

        *)
            echo "Oops, something wen't wrong. Please report @ https://github.com/Mar2zz/LaSi/issues?sort=created&direction=desc&state=open"
            return 1
            ;;
    esac

    # give time to read output from above installprocess before returning to menu
    echo 
    read -sn 1 -p "Press a key to continue"

LaSi_Menu
}

    Question() {
    echo 
    echo "Are you sure you want to continue and install $SET_APP?"
    read -p "[yes/no]: " REPLY
    echo
    case $REPLY in
    [Yy]*)
        get_Installer
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
        Question
        ;;
    esac
    }

Question
}

LaSi_Menu

