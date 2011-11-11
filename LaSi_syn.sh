#!/bin/sh

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3
#
# This is the main script of "Lazy Admins Scripted Installers (LaSi) for Synology"
#
# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues
#  ___________________________________________________________________________________
# |
# | execute this script with the command: chmod +x LaSi_syn.sh 
# | then run with sh LaSi.sh
# |
# | LaSi will install the programs you choose
# | from the menu:
# | # Periscope
# | # Spotweb
# |___________________________________________________________________________________
#
#
#######################################################################################
#######################################################################################

#### v0.1 ####

#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

dropbox=http://dl.dropbox.com/u/18712538/Synology;    # dropbox-adres


#######################################################################################
#######################################################################################

#### ERROR MESSAGE ####
error_Msg () {
echo "
Failed! Installing $set_app didn't finish, try again or:
Copy the text above and report an issue at the following address:
https://github.com/Mar2zz/LaSi/issues
"
exit 1
}

#### BEST PRACTICE ####
check_Ipkg () {
if ! which ipkg; then
echo "
Bootstrap is not installed, please install it before using this script
Information on how to install bootstrap can be found at:
http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc#How_to_install_ipkg
"
    exit
fi
}

check_Git () {
if ! which git > /dev/null; then
    ipkg install git || error_Msg
fi
}

check_DSM () {
## do some stuff in the webinterface
echo "
# Go to your DSM:
# Control Panel -> Users -> Create user
# and create a user called \"$app_low\"
# Press the Ok button
#
# Press a button to continue this installer 
(if you have done all of the above settings)"
read -sn 1 -p '--- [continue]---'
}

check_DSM_web () {
echo "
# Go to your DSM:
# Control Panel -> Web Services -> Web Applications -> Check 'Enable Web Statio' and 'Enable MySQL'
# Control Panel -> Web Services -> PHP Settings:
#       Check 'Customize PHP open_basedir' and add ':/opt/share/pear' at the end
#       Under 'Select PHP extension': Make sure that the following items are checked: openssl, mysql, zlib, gd, mcrypt
# Press the Ok button"
read -sn 1 -p '--- [continue]---'
}

# check if fast install is enabled
option=$1
check_Variables () {
unattended=0
    case $option in
        --fast)
            unattended=1 ;;
        *)
            echo "Invalid variable $option"
            exit 1 ;;
    esac
}



LaSi_Menu () {
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
        echo "1. Beets          4. SickBeard"
        echo "2. CouchPotato    5. Spotweb"
        echo "3. Headphones     6. Subliminal"
        echo " "
        [ $unattended = 0 ] && echo "Tip: Type ./LaSi_syn.sh --fast for fast install!"
        echo "Q. Quit"
        echo " "

        read -p "Choose an option: " SELECT
        case "$SELECT" in
            1)
                set_app=Beets
                app_low=beets
                if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                ;;
            2)
                set_app=CouchPotato
                app_low=couchpotato
                if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                ;;
            3)
                set_app=Headphones
                app_low=headphones
                if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                ;;
            4)
                set_app=SickBeard
                app_low=sickbeard
                if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                ;;
            5)
                set_app=Spotweb
                app_low=spotweb
                if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                ;;
            6)
                set_app=Subliminal
                app_low=subliminal
                if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                ;;
            Qq*)
                exit
                ;;
            *)
                echo "Please make a selection..."
                echo 
                show_Menu
                ;;
        esac
        }
show_Menu
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
    # dependencys
    ipkg install textutils || error_Msg

    if ! [ -e /opt/bin/python2.6 ]; then
        ipkg install python26 || error_Msg
    fi

    if ! which easy_install > /dev/null; then
        ipkg install py26-setuptools || error_Msg
    fi

    if ! easy_install pip; then
        if ! which curl > /dev/null; then
            ipkg install curl || error_Msg
            curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python
        fi
    fi

    /opt/local/bin/pip install beets || error_Msg

    # Set configfile!

    Summ_Beets
    }

    Summ_Beets () {
    echo "
    Done! Installed $set_app.
    Type /opt/local/bin/beet --help for options or
    start importing music with /opt/local/bin/beet import /path/to/music.
    "
}


#####################
#### COUCHPOTATO ####
#####################

Info_CouchPotato () {
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
    cf_Choice
}

Install_CouchPotato () {
    check_Git

    # installpath
    app_path=/volume1/@appstore/$app_low
    cfg_path=/volume1/@appstore/.$app_low

    # dependencys
    ipkg install textutils || error_Msg

    if ! [ -e /opt/bin/python2.6 ]; then
        ipkg install python26 || error_Msg
    fi

    # create the new configdir
    mkdir -p /volume1/@appstore/.$app_low

    # before downloading source from git, save personal stuff if not in cfg_path allready
    # config.ini
    if ! [ -e $cfg_path/config.ini ]; then
        [ -e $app_path/config.ini ] && mv -f $app_path/config.ini $cfg_path/config.ini
    fi

    # database
    if ! [ -e $cfg_path/data.db ]; then
        [ -e $app_path/data.db ] && mv -f $app_path/data.db $cfg_path/data.db
    fi

    # cache (images and stuff)
    if ! [ -d $cfg_path/cache ]; then
        [ -d $app_path/cache ] && mv -f $app_path/cache $cfg_path/cache
    fi

    # download source from git
    if [ -d $app_path ]; then
        echo "Start fresh, removing $app_path ..."
        rm -Rf $app_path
    else
        git clone git://github.com/RuudBurger/CouchPotato.git $app_path || error_Msg
    fi

    # provide startupscript, thx to brickman
    echo "
    Downloading Brickman's modified startupscript for $set_app ...
    "
    wget -O /opt/etc/init.d/S99$app_low.sh $dropbox/$app_low/S99$app_low.sh || error_Msg
    chmod a+x /opt/etc/init.d/S99$app_low.sh || error_Msg

    # set config.ini, as couchpotato tries to run on 5000, set it to 5050 if none set allready
    if ! [ -e $cfg_path/config.ini ]; then
        wget -O $cfg_path/config.ini $dropbox/$app_low/config.ini || error_Msg
    fi

    /opt/etc/init.d/S99$app_low.sh start || error_Msg

    Summ_$set_app
}

Summ_CouchPotato () {
echo "
Done! Installed $set_app.
$set_app is by default located @ http://synology_ip:5050
"
}


####################
#### HEADPHONES ####
####################

Info_Headphones () {
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
    cf_Choice
}

Install_Headphones () {
    check_Git

    # installpath
    app_path=/volume1/@appstore/$app_low
    cfg_path=/volume1/@appstore/.$app_low

    # dependencys
    ipkg install textutils || error_Msg

    if ! [ -e /opt/bin/python2.6 ]; then
        ipkg install python26 || error_Msg
    fi

    # create the new configdir
    mkdir -p /volume1/@appstore/.$app_low

    # before downloading source from git, save personal stuff if not in cfg_path allready
    # config.ini
    if ! [ -e $cfg_path/config.ini ]; then
        [ -e $app_path/config.ini ] && mv -f $app_path/config.ini $cfg_path/config.ini
    fi

    # database
    if ! [ -e $cfg_path/headphones.db ]; then
        [ -e $app_path/headphones.db ] && mv -f $app_path/headphones.db $cfg_path/headphones.db
    fi

    # cache (images and stuff)
    if ! [ -d $cfg_path/cache ]; then
        [ -d $app_path/cache ] && mv -f $app_path/cache $cfg_path/cache
    fi

    # download source from git
    if [ -d $app_path ]; then
        echo "Start fresh, removing $app_path ..."
        rm -Rf $app_path
    else
        git clone https://github.com/rembo10/headphones.git || error_Msg
    fi

    # provide startupscript, thx to brickman
    echo "
    Downloading Brickman's modified startupscript for $set_app ...
    "
    wget -O /opt/etc/init.d/S99$app_low.sh $dropbox/$app_low/S99$app_low.sh || error_Msg
    chmod a+x /opt/etc/init.d/S99$app_low.sh || error_Msg

    /opt/etc/init.d/S99$app_low.sh start || error_Msg

    Summ_$set_app
}

Summ_Headphones () {
echo "
Done! Installed $set_app.
$set_app is by default located @ http://synology_ip:8181
"
}


###################
#### SICKBEARD ####
###################

Info_SickBeard () {
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
    cf_Choice
}

Install_SickBeard () {
    check_Git

    # installpath
    app_path=/volume1/@appstore/$app_low
    cfg_path=/volume1/@appstore/.$app_low

    # dependencys
    ipkg install textutils || error_Msg
    ipkg install py26-cheetah || error_Msg

    if ! [ -e /opt/bin/python2.6 ]; then
        ipkg install python26 || error_Msg
    fi

    # create the new configdir
    mkdir -p /volume1/@appstore/.$app_low

    # before downloading source from git, save personal stuff if not in cfg_path allready
    # config.ini
    if ! [ -e $cfg_path/config.ini ]; then
       [ -e $app_path/config.ini ] && mv -f $app_path/config.ini $cfg_path/config.ini
    fi

    # database
    if ! [ -e $cfg_path/sickbeard.db ]; then
        [ -e $app_path/sickbeard.db ] && mv -f $app_path/sickbeard.db $cfg_path/sickbeard.db
        [ -e $app_path/sickbeard.db.v0 ] && mv -f $app_path/sickbeard.db.v0 $cfg_path/sickbeard.db.v0
    fi

    # cache (images and stuff)
    if ! [ -d $cfg_path/cache ]; then
        [ -d $app_path/cache ] && mv -f $app_path/cache $cfg_path/cache
        [ -e $app_path/cache.db ] && mv -f $app_path/cache.db $cfg_path/cache.db
    fi

    # autoprocesstv.cfg
    if ! [ -e $cfg_path/autoProcessTV/autoProcessTV.cfg ]; then
        [ -e $app_path/autoProcessTV/autoProcessTV.cfg ] && mv -f $app_path/autoProcessTV/autoProcessTV.cfg $cfg_path/autoProcessTV/autoProcessTV.cfg
    fi

    # download source from git
    if [ -d $app_path ]; then
        echo "Start fresh, removing $app_path ..."
        rm -Rf $app_path
    else
        git clone git://github.com/midgetspy/Sick-Beard.git $app_path || error_Msg
    fi

    # set autoProcesstv.cfg
    [ -e $cfg_path/autoProcessTV/autoProcessTV.cfg ] && ln -s $cfg_path/autoProcessTV/autoProcessTV.cfg $app_path/autoProcessTV/autoProcessTV.cfg

    # provide startupscript, thx to brickman
    echo "
    Downloading Brickman's modified startupscript for $set_app ...
    "
    wget -O /opt/etc/init.d/S99$app_low.sh $dropbox/$app_low/S99$app_low.sh || error_Msg
    chmod a+x /opt/etc/init.d/S99$app_low.sh || error_Msg

    /opt/etc/init.d/S99$app_low.sh start || error_Msg

    Summ_$set_app
}

Summ_SickBeard () {
echo "
Done! Installed $set_app.
$set_app is by default located @ http://synology_ip:8081
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
    cf_Choice
}

Install_Spotweb () {
    # installpath
    app_path=/volume1/web/$app_low
    cfg_path=/volume1/@appstore/.$app_low

# enable webserver in DSM
check_DSM_web

check_Git

# dependencys
ipkg install textutils || error_Msg
ipkg install php-pear || error_Msg
pear config-set php_bin /usr/bin/php || error_Msg
sed -i 's#;include_path = ".:/php/includes"#include_path = ".:/php/includes:/opt/share/pear"#g' /usr/syno/etc/php.ini || error_Msg

    # before downloading source from git, save personal stuff if not in cfg_path allready
    # ownsettings.php
    if ! [ -e $cfg_path/ownsettings.php ]; then
        [ -e $app_path/ownsettings.php ] || mv -f $cfg_path/ownsettings.php
    fi

    # download source from git
    if [ -d $app_path ]; then
        echo "Start fresh, removing $app_path ..."
        rm -Rf $app_path
    else
        git clone git://github.com/spotweb/spotweb.git $app_path || error_Msg
    fi

    # symlink settingsfile if any, or create a new one
    if [ -e $cfg_path/ownsettings.php ]; then
        ln -s $cfg_path/ownsettings.php $app_path/ownsettings.php || error_Msg
    else
        wget -O $cfg_path/ownsettings.php $dropbox/$app_low/ownsettings.php || error_Msg
        ln -s $cfg_path/ownsettings.php $app_path/ownsettings.php || error_Msg
    fi

    config_SQL () {

        cf_SQL () {
            echo
            echo "Do you want to create a new database?"
            echo "Warning: All existing info in an existing spotwebdatabase will be lost!"
            read -p "[yes/no]: " DBREPLY
            case $DBREPLY in
                [YyJj]*)
                    cf_PW
                    ;;
                [Nn]*)
                    ;;
                *)
                    echo "Answer yes or no"
                    cf_SQL
                    ;;
            esac
        }

        # ask for mysql password
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

        cf_PW () {
        ## Change mysql password?
        echo "Do you know your mySQL password?"
        read -p "[ yes/no ]: " REPLY
        case $REPLY in
            [YyJj]*)
                input_PW
                ;;
            [Nn]*)
                set_Pass () { 
                    # hide password when typed
                    stty_orig=`stty -g`
                    echo 
                    stty -echo
                    read -p "Set a new password: " PASSWORD
                    read -p "Confirm new password: " PASSWORD2
                    stty $stty_orig

                    if [ "$PASSWORD" != "$PASSWORD2" ]; then
                        echo "Passwords do not match, try again"
                        set_Pass
                    else
                        SQLPASSWORD=$PASSWORD
                        create_DB
                    fi

                }
                set_Pass
                ;;
            *)
                echo "Answer yes or no"
                cf_PW
                ;;
        esac
        }

        create_DB () {
            MYSQL=/usr/syno/mysql/bin/mysql

            # check password
            if ! $($MYSQL --password="$SQLPASSWORD" -e "SHOW DATABASES;" > /dev/null); then
                echo "Password is wrong, try again"
                input_PW
            fi

            # drop DB if it exists
            if $($MYSQL --password="$SQLPASSWORD" -e "SHOW DATABASES;" | grep 'spotweb' > /dev/null); then
                $MYSQL --password="$SQLPASSWORD" -e "DROP DATABASE spotweb;" > /dev/null
            fi

            # drop USER if it exists
            if $($MYSQL --password="$SQLPASSWORD" -e "select user.user from mysql.user;" | grep 'spotweb' > /dev/null); then
                $MYSQL --password="$SQLPASSWORD" -e "DROP USER 'spotweb'@'localhost';" > /dev/null
            fi

            # create DB
            $MYSQL --password="$SQLPASSWORD" -e "
            CREATE DATABASE spotweb;
            CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
            GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"

            # check if database and user is created
            if ! $($MYSQL --password="$SQLPASSWORD" -e "SHOW DATABASES;" | grep 'spotweb' > /dev/null); then
                echo 
                echo "Creation of database failed, try again"
                error_Msg
            fi

            if ! $($MYSQL --password="$SQLPASSWORD" -e "select user.user from mysql.user;" | grep 'spotweb' > /dev/null); then
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

    # update database
    cd $app_path && /usr/bin/php upgrade-db.php 
    cd - > /dev/null

        cf_Retrieve () {
            echo 
            echo "Do you want to retrieve spots now?"
            read -p "[yes/no]: " RETRIEVE
            case $RETRIEVE in
                [YyJj]*)
                    echo "This will take a while!"
                    cd $app_path && /usr/bin/php retrieve.php
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

    Summ_Spotweb

}

Summ_Spotweb () {
echo "
Done! Installed $set_app.
$set_app is by default located @ http://synology_ip/spotweb
"
}


####################
#### SUBLIMINAL ####
####################

Info_Subliminal () {
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
    cf_Choice
}


Install_Subliminal () {
    # dependencys
    ipkg install textutils || error_Msg

    if ! [ -e /opt/bin/python2.6 ]; then
        ipkg install python26 || error_Msg
    fi

    if ! which easy_install > /dev/null; then
        ipkg install py26-setuptools || error_Msg
    fi

    if ! easy_install pip; then
        if ! which curl > /dev/null; then
            ipkg install curl || error_Msg
            curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python
        fi
    fi

    /opt/local/bin/pip install subliminal || error_Msg
    /opt/local/bin/pip install argparse || error_Msg

Summ_$set_app

}

Summ_Subliminal () {
echo "
Done! Installed $set_app.
Type /opt/local/bin/subliminal --help for options
"
}



#### BACKTOMENU OR INSTALL ####
cf_Choice () {
    echo 
    echo "Options:"
    echo "1. Install $set_app"
    echo "2. Back to menu"
    echo "Q. Quit"

    read -p "Choose an option: " SELECT
        case "$SELECT" in
            1)
                Install_$set_app
                ;;
            2)
                LaSi_Menu
                ;;
            [Qq]*)
                exit
                ;;
            *)
                echo "Please choose..."
                echo 
                cf_Choice
                ;;
        esac
}


### CONFIRM INSTALL ###
cf_Install () {
    echo 
    echo "Are you sure you want to continue and install $set_app?"
    read -p "[yes/no]: " REPLY
    case $REPLY in
        [YyJj]*)
            Install_$set_app
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


### RUN ALL FUNCTIONS ###
check_Ipkg
check_Variables
LaSi_Menu






