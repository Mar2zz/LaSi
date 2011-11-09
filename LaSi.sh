#!/usr/bin/env bash

# Author: Mar2zz
# Email: lasi.mar2zz@gmail.com
# Blogs: mar2zz.tweakblogs.net
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
# | # Or ./LaSi.sh hourly|daily|weekly|monthly to set cronjobs for updating on the fly
# |
# | LaSi will install the programs you choose
# | from the menu:
# | # Beets
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

DROPBOX=http://dl.dropbox.com/u/18712538/                               # dropbox-adres

#######################################################################################
#######################################################################################
#######################################################################################


### ERROR HANDLING ####
error_Depends () {
    # solve dependency problems
    echo 
    echo "Solving dependencys..."
    sudo apt-get -fy install || error_Msg
    echo 
}

error_Msg () {
    # show error message and exit 1
    echo 
    echo "########################################################################"
    echo "#  Fail! Installation didn't finish, try again or:                     #"
    echo "#  Copy the text above and report an issue at the following address:   #"
    echo "#  https://github.com/Mar2zz/LaSi/issues                               #"
    echo "########################################################################"
    exit 1
}


### BEST PRACTICE ###
check_Git () {
    # install git for benefits like updating from commandline
    if ! which git > /dev/null; then
        sudo apt-get -y install git
    fi
}

check_Deb () {
    # remove any existing .deb files in tmp
    rm -f /tmp/*.deb
}


### SET CRONJOBS ON THE FLY ###
periodic=$1
check_Crontime () {
    case $periodic in
        hourly) 
            schedule=hourly ;;
        daily)
            schedule=daily ;;
        weekly)
            schedule=weekly ;;
        monthly)
            schedule=monthly ;;
        *)
            echo "Incorrect value, usage:"
            echo "./LaSi.sh hourly|daily|weekly|monthly"
            return 1
    esac
}


### PRESENT MENU ###
LaSi_Menu (){
    
    clear
    echo "Lazy admin Scripted installers ------------------------"
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
    echo "------------------------------------------------ Mar2zz"

    show_Menu () {
        echo "Make a choice to see info or install these apps..."

        echo "1. Beets                  6. SickBeard"
        echo "2. CouchPotato            7. Spotweb"
        echo "3. Headphones             8. Subliminal"
        echo "4. Mediafrontpage         9. Tranmission"
        echo "5. Sabnzbdplus           10. XBMC (desktop)"
        echo 
        echo "Use f[n] for fast install (e.g. f1 f2 5 f6)"
        if [ -z $periodic ]; then
        echo "Autoset cronjobs for fast installs with:"
        echo "./LaSi.sh hourly|daily|weekly|monthly"
        fi
        echo 
        echo "Q. Quit"

        read SELECT
        items=( $SELECT )

        for item in ${items[@]}
        do
            case "$item" in

                # beets
                1) Info_Beets ;;
                [Ff]1)
                    set_app=Beets
                    Install_Beets && { [ -n $periodic ] && check_Crontime && set_Cronjob; }
                    ;;

                # couchpotato
                2) Info_CouchPotato ;;
                [Ff]2)
                    set_app=CouchPotato
                    Install_CouchPotato && { [ -n $periodic ] && check_Crontime && set_Cronjob; }
                    ;;

                # headphones
                3) Info_Headphones ;;
                [Ff]3)
                    set_app=Headphones
                    Install_Headphones && { [ -n $periodic ] && check_Crontime && set_Cronjob; }
                    ;;

                # mediafrontpage
                4) Info_Mediafrontpage ;;
                [Ff]4)
                    set_app=Mediafrontpage
                    Install_Mediafrontpage && { [ -n $periodic ] && check_Crontime && set_Cronjob; }
                    ;;

                # sabnzbdplus
                5) Info_Sabnzbdplus ;;
                [Ff]5) 
                    Install_Sabnzbdplus && Summ_Sabnzbdplus
                    ;;

                # sickbeard
                6) Info_SickBeard ;;
                [Ff]6)
                    set_app=SickBeard
                    Install_SickBeard && { [ -n $periodic ] && check_Crontime && set_Cronjob; }
                    ;;

                # spotweb
                7) Info_Spotweb ;;
                [Ff]7)
                    set_app=Spotweb
                    Install_Spotweb && { [ -n $periodic ] && check_Crontime && set_Cronjob; }
                    ;;

                # subliminal
                8) Info_Subliminal ;;
                [Ff]8)
                    Install_Subliminal && { [ -n $periodic ] && check_Crontime && set_Cronjob; }
                    ;;

                # transmission
                9) Info_Transmission ;;
                [Ff]9) Install_Transmission && Summ_Transmission
                    ;;

                # xbmc
                10) Info_XBMC ;;
                [Ff]10) Install_XBMC && Summ_XBMC
                    ;;

                [Qq]) exit ;;

                *)
                    echo "Please make a selection (e.g. 1)"
                    echo "Or select multiple (e.g. 1 4 5 7 10)"
                    echo "or with f[n] for fast installs, like f1 3 f10 f8"
                    show_Menu
                    ;;
            esac
        done

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
    set_app=Beets
    cf_Choice
}


Install_Beets () {

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

Summ_Beets

}

Summ_Beets () {
    echo 
    echo "Done!"
    echo "Type beet --help for options"
    echo "or start importing with beet import -q /path/to/new_music"
    echo 
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
    set_app=CouchPotato
    cf_Choice
}


Install_CouchPotato () {

    # best practice
    check_Deb
    check_Git

    wget -O /tmp/couchpotato.deb $DROPBOX/LaSi_Repo/couchpotato.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }

    sudo dpkg -i /tmp/couchpotato.deb || error_Depends

    if ! pgrep -f CouchPotato.py > /dev/null; then
        sudo sed -i "
            s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
            s/RUN_AS.*/RUN_AS=$USER/
            s/WEB_UPDATE=0/WEB_UPDATE=1/g
        " /etc/default/couchpotato
        echo "Changed daemon settings..."
        sudo /etc/init.d/couchpotato start || error_Msg
    fi

Summ_CouchPotato

}

Summ_CouchPotato () {
    echo 
    echo "Done!"
    echo "Type couchpotato --help for options."
    echo "CouchPotato is by default located @ http://$HOSTNAME:5000"
    echo 
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
    set_app=Headphones
    cf_Choice
}


Install_Headphones () {

    # best practice
    check_Deb
    check_Git

    wget -O /tmp/headphones.deb $DROPBOX/LaSi_Repo/headphones.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }

    sudo dpkg -i /tmp/headphones.deb || error_Depends

    if ! pgrep -f Headphones.py > /dev/null; then
        sudo sed -i "
            s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
            s/RUN_AS.*/RUN_AS=$USER/
            s/WEB_UPDATE=0/WEB_UPDATE=1/g
        " /etc/default/headphones
        echo "Changed daemon settings..."
        sudo /etc/init.d/headphones start || error_Msg
    fi

Summ_Headphones

}

Summ_Headphones () {
    echo 
    echo "Done!"
    echo "Type headphones --help for options"

    echo "Headphones is by default located @ http://$HOSTNAME:8181"
    echo 
}

########################
#### MEDIAFRONTPAGE ####
########################

Info_Mediafrontpage () {
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
    set_app=Mediafrontpage
    cf_Choice
}

Install_Mediafrontpage () {

    # best practice
    check_Deb
    check_Git

    wget -O /tmp/mediafrontpage.deb $DROPBOX/LaSi_Repo/mediafrontpage.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
    sudo dpkg -i /tmp/mediafrontpage.deb || error_Depends

Summ_Mediafrontpage

}

Summ_Mediafrontpage () {
    echo 
    echo "Mediafrontpage is now located @ http://$HOSTNAME/mediafrontpage"
    echo 
}

#####################
#### SABNZBDPLUS ####
#####################

Info_Sabnzbdplus () {
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
    set_app=Sabnzbdplus
    cf_Choice
}


Install_Sabnzbdplus () {

    # Check if ppa is used as a source
    if ! ls /etc/apt/sources.list.d/jcfp-ppa* > /dev/null; then
        sudo add-apt-repository ppa:jcfp/ppa
    fi

    # Update list, install and configure
    echo "Checking for newest version..."
    sudo apt-get update > /dev/null
    if sudo apt-get -y install sabnzbdplus || error_Msg | grep '/etc/default/sabnzbdplus'; then
        sudo sed -i "
            /=/s/USER.*/USER=$USER/
            /=/s/HOST.*/HOST=0.0.0.0/
        " /etc/default/sabnzbdplus
        echo "Changed daemon settings..."
        sudo /etc/init.d/sabnzbdplus start || error_Msg
    fi

Summ_Sabnzbdplus

}

Summ_Sabnzbdplus () {
    echo 
    echo "Done!"
    echo "Type sabnzbdplus --help for options"
    echo "Sabnzbdplus is by default located @ http://$HOSTNAME:8080"
    echo 
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
    set_app=SickBeard
    cf_Choice
}


Install_SickBeard () {

    # best practice
    check_Deb
    check_Git

    wget -O /tmp/sickbeard.deb $DROPBOX/LaSi_Repo/sickbeard.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
    sudo dpkg -i /tmp/sickbeard.deb || error_Depends

    if ! pgrep -f SickBeard.py > /dev/null; then
        sudo sed -i "
            s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
            s/RUN_AS.*/RUN_AS=$USER/
            s/WEB_UPDATE=0/WEB_UPDATE=1/g
        " /etc/default/sickbeard
        echo "Changed daemon settings..."
        sudo /etc/init.d/sickbeard start || error_Msg
    fi

Summ_SickBeard

}

Summ_SickBeard () {
    echo 
    echo "Done!"
    echo "Type sickbeard --help for options"
    echo "SickBeard is by default located @ http://$HOSTNAME:8081"
    echo 
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
    set_app=Spotweb
    cf_Choice
}


Install_Spotweb () {

    # best practice
    check_Deb
    check_Git

    wget -O /tmp/spotweb.deb $DROPBOX/LaSi_Repo/spotweb.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
    sudo dpkg -i /tmp/spotweb.deb || error_Depends

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

    # change servername to hostname in ownsettings if it's still default.
    sudo sed -i "s/mijnserver/$HOSTNAME/g" /etc/default/spotweb/ownsettings.php

    # update database
    cd /var/www/spotweb && /usr/bin/php /var/www/spotweb/upgrade-db.php
    cd - > /dev/null

    Summ_Spotweb


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

[ -x /usr/bin/php ] || exit 0
[ -e /var/www/spotweb/retrieve.php ] || exit 0

/usr/bin/php /var/www/spotweb/retrieve.php || exit 1
" > /tmp/spotweb_spots

                sudo mv -f /tmp/spotweb_spots /etc/cron.hourly/spotweb_spots
                sudo chmod +x /etc/cron.hourly/spotweb_spots

                echo 
                echo "Cronjob set."
                echo "See /etc/cron.hourly/spotweb_spots."
                echo 
                ;;

            [Nn]*)
                echo "You can set cronjobs yourself if you want to."
                echo "Type crontab -e for personal jobs or sudo crontab -e for root jobs."
                echo "See: https://help.ubuntu.com/community/CronHowto for help and info"
                echo 
                ;;
            *)
                echo "Answer yes or no."
                cf_CronRetrieve
                ;;
        esac
    }
    cf_CronRetrieve


    cf_Retrieve () {
        echo 
        echo "Do you want to retrieve spots now?"
        read -p "[yes/no]: " RETRIEVE
        case $RETRIEVE in
            [YyJj]*)
                echo "This will take a while!"
                /usr/bin/php /var/www/spotweb/retrieve.php
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

}

Summ_Spotweb () {
    echo 
    echo "Done!"
    echo "Spotweb is now located @ http://$HOSTNAME/spotweb"
    echo "Run /var/www/spotweb/retrieve.php to fill the database with spots"
    echo 
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
    set_app=Subliminal
    cf_Choice
}


Install_Subliminal () {

    sudo apt-get -y install python-pip || error_Msg
    sudo pip install subliminal || error_Msg
    sudo pip install argparse || error_Msg

Summ_Subliminal

}

Summ_Subliminal () {
    echo 
    echo "Done!"
    echo "Type subliminal --help for options"
    echo 
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
    set_app=Transmission
    cf_Choice
}


Install_Transmission () {

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

Summ_Transmission

}

Summ_Transmission () {
    echo 
    echo "Done!"
    echo "Type tranmission-daemon --help for options"
    echo "Transmission is by default located @ http://$HOSTNAME:9091"
    echo 
}


##############
#### XBMC ####
##############

Info_XBMC () {
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
    set_app=XBMC
    cf_Choice
}


Install_XBMC () {

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
            echo 
            ;;
        2*)
            sudo apt-get -y install xbmc || error_Msg
            echo
            echo "Done!"
            echo "XBMC can now be started from the menu"
            echo 
            ;;
    esac

}

Summ_XBMC () {
    echo
    echo "Done!"
    echo "XBMC can now be started from the menu"
    echo 
}


###############################
#### BACKTOMENU OR INSTALL ####
###############################

cf_Choice () {

    case $set_app in
        Sabnzbdplus|Transmission|XBMC)
            echo 
            echo "Options:"
            echo "1. Install $set_app"
            echo 
            echo "B. Back to menu"
            echo "Q. Quit"
            ;;
        *)
            echo 
            echo "Options:"
            echo "1. Install $set_app"
            echo "2. Set cronjob for $set_app"
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
            case $set_app in
                Sabnzbdplus|Transmission|XBMC) ;;
                *) cf_Cronjob ;;
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
    echo "Are you sure you want to continue and install $set_app?"
    read -p "[yes/no]: " REPLY
    echo
    case $REPLY in
    [Yy]*)
        Install_$set_app &&
        Summ_$set_app

        # give time to read output from above installprocess before returning to menu
        echo 
        read -sn 1 -p "Press a key to continue"
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



##################
#### CRONJOBS ####
##################

set_Cronjob () {

    # set updaters
    set_app_lower=$(echo $set_app | tr '[A-Z]' '[a-z]')

    case $set_app in
        CouchPotato|Headphones|SickBeard)

            cron_exe=$(which git)
            cron_dir="[ -d /opt/$set_app_lower/.git ] || exit 0"
            cron_chk="if $cron_exe --git-dir=/opt/$set_app_lower/.git pull | grep 'files changed'; then"
            cron_act="    etc/init.d/$set_app_lower restart || exit 1; fi"
            ;;

        Mediafrontpage)

            cron_exe='[ -x /usr/bin/git ] || exit 0'
            cron_dir="[ -d /var/www/$set_app_lower/.git ] || exit 0"
            cron_chk="if $cron_exe --git-dir=/var/www/$set_app_lower pull | grep 'files changed'; then"
            cron_act="    chown -R www-data /var/www/$set_app_lower || exit 1; fi"
            ;;

        Spotweb)

            cron_exe=$(which git)
            cron_dir="[ -d /var/www/$set_app_lower/.git ] || exit 0"
            cron_chk="if $cron_exe --git-dir=/var/www/$set_app_lower/.git pull | grep 'files changed'; then"
            cron_act="    cd /var/www/$set_app_lower && php upgrade-db.php; fi"
            ;;

        Beets|Subliminal)
            cron_exe='[ -x /usr/bin/easy_install ] || exit 0'
            cron_dir=
            cron_chk="/usr/bin/easy_install --upgrade $set_app_lower || exit 1"
            cron_act=
            ;;

    esac


    # check if another cronjob for this exists and remove it
    [ -e /etc/cron.hourly/$set_app_lower ] && sudo rm -f /etc/cron.hourly/$set_app_lower
    [ -e /etc/cron.daily/$set_app_lower ] && sudo rm -f /etc/cron.daily/$set_app_lower
    [ -e /etc/crond.weekly/$set_app_lower ] && sudo rm -f /etc/cron.weekly/$set_app_lower
    [ -e /etc/crond.monthly/$set_app_lower ] && sudo rm -f /etc/cron.monthly/$set_app_lower


    # create lasi file in correct location
    # would like to use sed for this, but can't figure out how...
echo "#!/bin/sh

# Author: Mar2zz
# Email: lasi.mar2zz@gmail.com
# Blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3

# This job is set by the Lazy admin Scripted installer

set -e

[ -x $cron_exe ] || exit 0
$cron_dir

$cron_chk
$cron_act
" > /tmp/$set_app_lower

    sudo mv -f /tmp/$set_app_lower /etc/cron.$schedule/$set_app_lower
    sudo chmod +x /etc/cron.$schedule/$set_app_lower

    echo 
    echo "Cronjob set."
    echo "See /etc/cron.$schedule/$set_app_lower."
    echo 

}


cf_Cronjob () {
    clear
    echo "Set a cronjob for updating $set_app"
    echo 
    echo "1. Check hourly"
    echo "2. Check daily"
    echo "3. Check weekly"
    echo "4. Check monthly"
    echo 
    echo "Q. Quit"

    read CRON_SELECT
    echo 

    case $CRON_SELECT in
        1)
            schedule=hourly
            set_Cronjob
            ;;
        2)
            schedule=daily 
            set_Cronjob
            ;;
        3)
            schedule=weekly 
            set_Cronjob
            ;;
        4)
            schedule=monthly 
            set_Cronjob
            ;;
        [Qq]*)
            Info_$set_app ;;
        *)
            echo "Please choose... (e.g. 2)"
            cf_Cronjob
            ;;
    esac

    # give time to read output from above installprocess before returning to menu
    echo 
    read -sn 1 -p "Press a key to continue"
    Info_$set_app

}

LaSi_Menu

