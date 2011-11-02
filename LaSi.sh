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
# | # Periscope
# | # AlbumIdentify 
# | # Spotweb
# | # Headphones
# |___________________________________________________________________________________
#
# Tested succesful on OS's:
# Ubuntu 9.10 and higher and XBMC Live Dharma
#
#######################################################################################
#######################################################################################

#### v1.5 ####

#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

DROPBOX=http://dl.dropbox.com/u/18712538/         # dropbox-adres
CONN2=dropbox.com                    # to test connections needed


#######################################################################################
#################### LIST APPS USED ###################################################

APP1=CouchPotato;

APP2=SickBeard;

APP3=Subliminal;

APP4=AlbumIdentify;
APP4_INST=albumidentify.sh;

APP5=Spotweb;

APP6=Headphones;

APP7=Mediafrontpage;
APP7_INST=mediafrontpageinstall.sh;

APP8=Sabnzbdplus;

APP9=XBMC;



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
        echo "1. CouchPotato          6. Headphones"
        echo "2. SickBeard            7. Mediafrontpage"
        echo "3. Subliminal           8. Sabnzbdplus"
        echo "4. AlbumIdentify        9. XBMC (desktop)"
        echo "5. Spotweb"
        echo
        echo "Q. Quit"

        read SELECT
        case "$SELECT" in
            1*)
                info_Couch
                ;;
            2*)
                info_Sick
                ;;
            3*)
                info_Subli
                ;;
            4*)
                info_Album
                ;;
            5*)
                info_Spot
                ;;
            6*)
                info_Head
                ;;
            7*)
                info_Mediafp
                ;;
            8*)
                info_Sabnzbd
                ;;
            9*)
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


#### COUCHPOTATO ####

info_Couch () {
clear
echo "
*###################### COUCHPOTATO ######################### 
#
# CouchPotato is an automatic NZB and torrent downloader. 
# You can keep a 'movies I want'-list and it will search 
# for NZBs/torrents of these movies every X hours.    
#
# Once a movie is found, it will send it to SABnzbd
# or download the .nzb or .torrent to a    # specified directory.
#
*############################################################
#
# CouchPotato is written by Ruud Burger in his spare time...
# ..so buy him a coke to support him.
#
# Visit http://www.couchpotatoapp.com
*#############################################################"
SET_APP=$APP1
cf_Choice
}


#### SICKBEARD ####

info_Sick () {
clear
echo "
*####################### SICKBEARD ######################### 
#
# Sick Beard is currently an alpha release. 
# There may be severe bugs in it and at any given time it may not work at all.
#
# Sick Beard is a PVR for newsgroup users (with limited torrent support). 
# It watches for new episodes of your favorite shows and when they are posted
# and it downloads them, sorts and renames them, and optionally generates 
# metadata for them. It currently supports NZBs.org, NZBMatrix, Bin-Req, 
# NZBs'R'Us,  EZTV.it, and any Newznab installation and retrieves 
# show information from theTVDB.com and TVRage.com.

#Features include:
* automatically retrieves new episode torrent or nzb files
* can scan your existing library and then download any old seasons 
  or episodes you're missing"
echo
read -sn 1 -p "--- [more]---"
echo
echo "
* can watch for better versions and upgrade your existing episodes 
  (to from TV DVD/BluRay for example)
* XBMC library updates, poster/fanart downloads, and NFO/TBN generation
* configurable episode renaming
* sends NZBs directly to SABnzbd, prioritizes and categorizes them properly
* available for any platform, uses simple HTTP interface
* can notify XBMC, Growl, or Twitter when new episodes are downloaded
* specials and double episode support
#
*############################################################
#
# SickBeard is written by midgetspy
#
# Visit http://www.sickbeard.com
*#############################################################"    
SET_APP=$APP2
cf_Choice
}


#### SUBLIMINAL ####

info_Subli () {
clear
echo "
*###################### SUBLIMINAL ######################### 
#
# Subliminal is a subtitles searching module written in python 
# that tries to find a correct match for a given video file. 
# The goal behind subliminal is that it will only return only 
# correct subtitles so that you can simply relax and 
# enjoy your video without having to double-check that 
# the subtitles match your video before watching it.
#
# Type subliminal --help in console after install to see options
# and learn how to search for subs.
#
# It works great in a sabnzbd-postprocessingscript or when set
# as a cronjob. Also checkout Sickbeards Subliminal branch!
#
# Subliminal is written by Diaoul and based on Patrick's Periscope.
#
# https://github.com/Diaoul/subliminal
*#############################################################"
SET_APP=$APP3
cf_Choice
}


#### ALBUMIDENTIFY ####

info_Album () {
clear
echo "
*################### ALBUMIDENTIFY ##########################
#
# Albumidentify description on github:
# Tools to identify and manage music albums.
#
*############################################################
#
# LaSi will enable one part of this powerfull toolset, the 
# 'renamealbum' part of it. Though the whole collection of
# tools will be downloaded, I am using just 1 or 2 of 'm.
# 
# I am adding a batchscript (for cronjobs or manual) and a
# sabnzbd postprocessingscript to it.
#
*############################################################
#
# AlbumIdentify is written by the albumidentify-team..
#
# Visit https://github.com/scottr/albumidentify    
*#############################################################"
SET_APP=$APP4
SET_INST=$APP4_INST
cf_Choice
}


#### SPOTWEB ####

info_Spot () {
clear
echo "
*################### SPOTWEB ##########################
#
# SpotWeb is een versie van SpotNed (http://twitter.com/spotned) 
# voor het web. 
# Het gebruikt PHP5 om de meeste functies te implementeren
# en is getest op Linux en FreeBSD
#
*############################################################
#
# Deze installer installeert alle benodigdheden voor Spotweb.
# en installeert en configureert een apache/mysql-server indien
# dat nodig is. 
# Als de installatie klaar is zal spotweb draaien op 
# http://$HOSTNAME/spotweb.
# 
# Indien je niet kiest voor het importeren van je eigen
# ownsettings.php dan wordt er een minimale ownsettings aan-
# gemaakt, zodat je gelijk aan de slag kunt.
#
*############################################################
#
# Spotweb is geschreven door Spotweb e.a.
#
# Visit https://github.com/spotweb/spotweb
*#############################################################"
SET_APP=$APP5
cf_Choice
}


#### HEADPHONES ####

info_Head () {
clear
echo "
*###################### HEADPHONES ########################## 
#
# Headphones is an automatic NZB downloader. 
# You can keep a 'musicalbums I want'-list and it will search 
# for NZBs of these albums every X hours.
#
# It is also possible to 'follow' artists for upcoming albums.    
#
# Once an album is found, it will send it to SABnzbd.
#
*############################################################
#
# Headphones is written by Rembo10 in his spare time...
#
# Visit https://github.com/rembo10/headphones    
*#############################################################"
SET_APP=$APP6
cf_Choice
}


#### MEDIAFRONTPAGE ####

info_Mediafp () {
clear
echo "
*###################### MEDIAFRONTPAGE ####################### 
#
# MediaFrontPage is a HTPC Web Program Organiser. Your HTPC 
# utilises a number of different programs to do certain tasks. 
# What MediaFrontPage does is creates a user specific web page 
# that will be your nerve centre for everything you will need.
#
*############################################################
#
# Mediafrontpage is written by Nick8888 and others
#
# Visit https://github.com/Mediafrontpage/mediafrontpage    
*#############################################################"
SET_APP=$APP7
SET_INST=$APP7_INST
cf_Choice
}



#### SABNZBDPLUS ####

info_Sabnzbd () {
clear
echo "
*###################### SABNZBDPLUS ######################### 
#
# SABnzbd is an Open Source Binary Newsreader written in Python.
#
# It's totally free, incredibly easy to use, and works practically everywhere.
#
# SABnzbd makes Usenet as simple and streamlined as possible by 
# automating everything we can. All you have to do is add an .nzb.
# SABnzbd takes over from there, where it will be automatically downloaded,
# verified, repaired, extracted and filed away with zero human interaction.
#
*############################################################
#
# Sabnzbdplus is written by the Sabnzbd-team...
# Donate if you like it.
#
# Visit http://sabnzbd.org
*#############################################################"
SET_APP=$APP8
cf_Choice
}


#### XBMC ####

info_XBMC () {
clear
echo "
*############################# XBMC ######################### 
#
# XBMC is an award-winning free and open source (GPL) software 
# media player and entertainment hub for digital media.
# 
# Created in 2003 by a group of like minded programmers, 
# XBMC is a non-profit project run and developed by volunteers 
# located around the world.
#
# More than 50 software developers have contributed to XBMC,
# and 100-plus translators have worked to expand its reach,
# making it available in more than 30 languages.
#
*############################################################
#
# XBMC is written by the XBMC-Team
#
# Visit http://www.xbmc.org
*#############################################################"
SET_APP=$APP9
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
        Qq*)
            exit
            ;;
        *)
            echo "Please choose..."
            cf_Choice
            ;;
    esac
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

    # install apps
    case $SET_APP in
        # Alphabetical ordered applist with installcommands.
        CouchPotato)
            wget -O /tmp/couchpotato.deb $DROPBOX/LaSi_Repo/couchpotato.deb || echo "Connection to dropbox failed, try again later"
            if sudo dpkg -i /tmp/couchpotato.deb | grep "/etc/default/couchpotato"; then
                sudo editor /etc/default/couchpotato &&
                sudo /etc/init.d/couchpotato start
            fi

            echo
            echo "Type couchpotato --help for options."
            ;;
        Headphones)
            wget -O /tmp/headphones.deb $DROPBOX/LaSi_Repo/headphones.deb || echo "Connection to dropbox failed, try again later"
            if sudo dpkg -i /tmp/headphones.deb | grep '/etc/default/headphones'; then
                sudo editor /etc/default/headphones &&
                sudo /etc/init.d/headphones start
            fi

            echo
            echo "Type headphones --help for options"
            ;;
        Sabnzbdplus)
            # Check if ppa is used as a source
            if ! ls /etc/apt/sources.list.d/jcfp-ppa* > /dev/null; then
                sudo add-apt-repository ppa:jcfp/ppa
            fi

            # Update list, install and configure
            echo "Checking for newest version..."
            sudo apt-get update > /dev/null
            if sudo apt-get -y install sabnzbdplus | grep '/etc/default/sabnzbdplus'; then
                sudo editor /etc/default/sabnzbdplus
                sudo /etc/init.d/sabnzbdplus start
            fi

            echo
            echo "Type sabnzbdplus --help for options"
            ;;
        SickBeard)
            sudo apt-get -y install python-cheetah
            wget -O /tmp/sickbeard.deb $DROPBOX/LaSi_Repo/sickbeard.deb || echo "Connection to dropbox failed, try again later"
            if sudo dpkg -i /tmp/sickbeard.deb | grep "/etc/default/sickbeard"; then
                sudo editor /etc/default/sickbeard &&
                sudo /etc/init.d/sickbeard start
            fi

            echo
            echo "Type headphones --help for options"
            ;;
        Spotweb)
            sudo apt-get -y install apache2 php5 php5-curl php5-mysql mysql-server php-pear
            sudo pear install Net_NNTP
            sudo sed -i "s#;date.timezone =#date.timezone = \"Europe/Amsterdam\"#g" /etc/php5/apache2/php.ini
            sudo sed -i "s#;date.timezone =#date.timezone = \"Europe/Amsterdam\"#g" /etc/php5/cli/php.ini

            # this function creates a mysql database for spotweb
            config_SQL () {

                cf_SQL () {
                    echo
                    echo "Do you want to create a new database?"
                    echo "Warning: All existing info in an existing spotwebdatabase will be lost!"
                    read -p "(yes/no): " DBREPLY
                    case $DBREPLY in
                    [YyJj]*)
                        input_PW
                        ;;
                    [Nn]*)
                        ;;
                    *)
                        echo "Answer yes or no"
                        ;;
                    esac
                }

                input_PW () {
                    echo
                    echo "What is your MySQL Password?"
                    read -p "Type password:" SQLPASSWORD
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
                    if $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "USE spotweb;" > /dev/null); then
                        $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "DROP DATABASE spotweb;")
                    fi

                    # create DB
                    $MYSQL mysql -u root --password="$SQLPASSWORD" -e "
                    CREATE DATABASE spotweb;
                    CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
                    GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"
                    echo "Database created named spotweb, user spotweb and password spotweb"
                }
            cf_SQL
            }

            config_SQL

            wget -O /tmp/spotweb.deb $DROPBOX/LaSi_Repo/spotweb.deb || echo "Connection to dropbox failed, try again later"
            sudo dpkg -i /tmp/spotweb.deb

            # change servername to hostname in ownsettings.
            sudo sed -i "s/mijnserver/$HOSTNAME/g" /etc/default/spotweb/ownsettings.php
            
            # update database
            cd /var/www/spotweb && /usr/bin/php /var/www/spotweb/upgrade-db.php
            cd - > /dev/null

            echo
            echo "Spotweb is now located @ http://$HOSTNAME/spotweb"
            echo "Run php /var/www/spotweb/retrieve.php to fill the database with spots"
            ;;
        Subliminal)
            sudo apt-get -y install python-pip
            wget -O /tmp/subliminal.deb $DROPBOX/LaSi_Repo/subliminal.deb || echo "Connection to dropbox failed, try again later"
            sudo dpkg -i /tmp/subliminal.deb

            echo "Type subliminal --help for options"
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
                        sudo add-apt-repository ppa:team-xbmc
                        distro=$(ls /etc/apt/sources.list.d/team-xbmc* | sed "s/.*ppa-\|\.list//g")
                        ;;
                    2*)
                        sudo add-apt-repository ppa:team-xbmc/unstable
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
                    sudo apt-get -y install xbmc xbmc-standalone
                    echo "XBMC can now be started from the menu"
                    echo "or can be set in the loginscreen as a desktopmanager."
                    ;;
                2*)
                    sudo apt-get -y install xbmc
                    echo "XBMC can now be started from the menu"
                    ;;
            esac
            ;;
        *)
            wget -O $SET_INST $DROPBOX/$SET_APP/$SET_INST || echo "Connection to dropbox failed, try again later"
            sudo chmod +x $SET_INST &&
            ./$SET_INST
            rm -f $SET_INST
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
    read -p "(yes/no): " REPLY
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






