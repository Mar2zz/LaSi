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
APP1_INST=couchpotatoinstall.sh;

APP2=SickBeard;
APP2_INST=sickbeardinstall.sh;

APP3=Periscope;
APP3_INST=periscopeinstall.sh;

APP4=AlbumIdentify;
APP4_INST=albumidentify.sh;

APP5=Spotweb;
APP5_INST=spotwebinstall.sh;

APP6=Headphones;
APP6_INST=headphonesinstall.sh;

APP7=Mediafrontpage;
APP7_INST=mediafrontpageinstall.sh;

APP8=Sabnzbdplus
APP8_INST=sabnzbdplusinstall.sh;

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
        echo "1. CouchPotato          5. Spotweb (dutch only)"
        echo "2. SickBeard            6. Headphones"
        echo "3. Periscope            7. Mediafrontpage"
        echo "4. AlbumIdentify        8. Sabnzbdplus"
        echo
        echo "Q. Quit"

        read SELECT
        case "$SELECT" in
            [1]*)
                info_Couch
                ;;
            [2]*)
                info_Sick
                ;;
            [3]*)
                info_Peris
                ;;
            [4]*)
                info_Album
                ;;
            [5]*)
                info_Spot
                ;;
            [6]*)
                info_Head
                ;;
            [7]*)
                info_Mediafp
                ;;
            [8]*)
                info_Sabnzbd
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
SET_INST=$APP1_INST
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
SET_INST=$APP2_INST
cf_Choice
}


#### PERISCOPE ####

info_Peris () {
clear
echo "
*###################### PERISCOPE ######################### 
#
# Periscope is a subtitles searching module written in python 
# that tries to find a correct match for a given video file. 
# The goal behind periscope is that it will only return only 
# correct subtitles so that you can simply relax and 
# enjoy your video without having to double-check that 
# the subtitles match your video before watching it.

# This is done by using as much info as available from your file
# and on the websites. Some websites allow you to use hash of the files,
# the size/length of the video or the exact file name.

# As a python module, periscope should be easily integrated in many 
# projects that allow plugins to be written in python. 
# The fact that the plugin is shared between all the applications 
# means that separate application and their plugin 
# (file browser, video player, media center application, ...) 
# don't have to maintain the code to search, parse and download 
# subtitles and the user preference about languages.
#"
echo
read -sn 1 -p "--- [more]---"
echo "
*############################################################
#
# Periscope is written by patrick@gmail.com...
# ..so buy him a coke to support him.
#
# Visit http://code.google.com/p/periscope/    
*#############################################################"
SET_APP=$APP3
SET_INST=$APP3_INST
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
SET_INST=$APP5_INST
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
SET_INST=$APP6_INST
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
SET_INST=$APP8_INST
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
        echo
        cf_Choice
        ;;
esac
}

#### INSTALL APPLICATION
inst_App () {

    get_Installer () {
    # remove any existing .deb files in tmp
    rm -f /tmp/*.deb
    case $SET_APP in
        CouchPotato)
            wget -P /tmp $DROPBOX/LaSi_Repo/couchpotato.deb || echo "Connection to dropbox failed, try again later"
            sudo dpkg -i /tmp/couchpotato.deb
            ;;
        SickBeard)
            sudo apt-get -y install python-cheetah
            wget -P /tmp $DROPBOX/LaSi_Repo/sickbeard.deb || echo "Connection to dropbox failed, try again later"
            sudo dpkg -i /tmp/sickbeard.deb
            ;;
        Headphones)
            wget -P /tmp $DROPBOX/LaSi_Repo/headphones.deb || echo "Connection to dropbox failed, try again later"
            sudo dpkg -i /tmp/headphones.deb
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
                    echo "Warning: All existing info in database Spotweb will be lost"
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
                    CREATE DATABASE spotweb
                    CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
                    GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"
                    echo "Database created named spotweb, user spotweb and password spotweb"
                }
            cf_SQL
            }

            config_SQL
            wget -P /tmp $DROPBOX/LaSi_Repo/spotweb.deb || echo "Connection to dropbox failed, try again later"
            sudo dpkg -i /tmp/spotweb.deb
            ;;
        *)
            wget -O $SET_INST $DROPBOX/$SET_APP/$SET_INST || echo "Connection to dropbox failed, try again later"
            sudo chmod +x $SET_INST &&
            ./$SET_INST
            rm -f $SET_INST
            ;;
    esac
LaSi_Menu
}

    Question() {
    echo
    echo "Are you sure you want to continue and install $SET_APP?"
    read -p "(yes/no)   :" REPLY
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






