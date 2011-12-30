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
# show error message
echo "
Failed! Installing $set_app didn't finish, try again or:
Copy the text above and report an issue at the following address:
https://github.com/Mar2zz/LaSi/issues
"
# log error message
echo "
Failed! Installing $set_app had errors, try again or:
Copy the text with errors above and report an issue at the following address:
https://github.com/Mar2zz/LaSi/issues
" >> /tmp/lasi_install.log

# for fast install continue in next item, else quit installer
if [ "${#items[@]}" > 1 ]; then continue; else break; fi
}


### BEST PRACTICE ###
check_Apt () {
    # check if distro with apt is used
    if ! which apt-get > /dev/null; then
        echo "This installer is written for Debian-based distro's using Apt"
        exit
    fi
}

update_Apt () {
    # update sources list and tell script its done
    if [ -e "/tmp/lasi_apt_update.log" ]; then
        today=$(date +%Y-%m-%d)
        yatod=$(cat /tmp/lasi_apt_update.log)
        if [ "$today" = "$yatod" ]; then
            echo 
            echo "Packagelist is up to date"
            update_apt=1
        else
            echo
            echo "Checking for newest packages..."
            echo $(date +%Y-%m-%d) > /tmp/lasi_apt_update.log
            sudo apt-get update > /dev/null
            update_apt=1
        fi
    else
            echo 
            echo "Checking for newest packages..."
            echo $(date +%Y-%m-%d) > /tmp/lasi_apt_update.log
            sudo apt-get update > /dev/null
            update_apt=1
    fi
}

check_PPA () {
    if ! which apt-add-repository > /dev/null; then
        echo "Installing python-software-properties to install ppa's"
        sudo apt-get install -y python-software-properties || { echo "Need this to install $set_app, exiting ..." && exit; }
    fi
}

check_Git () {
    # install git for benefits like updating from commandline
    if ! which git > /dev/null; then
        sudo apt-get -y install git || { sudo apt-get install -y git-core || error_Msg; }
    fi
}

check_Pip () {
    if ! which pip > /dev/null; then
        sudo apt-get -y install python-pip || check_Easy
    fi
    pip=`which pip`
    pip="$pip -q"
}

check_Easy () {
    if ! which easy_install > /dev/null; then
        sudo apt-get -y install python-setuptools || error_Msg
    fi
    easy_install=`which easy_install`
}

check_Deb () {
    # remove any existing .deb files in tmp
    rm -f /tmp/*.deb
}

check_Log () {
    # remove any previous lasi_install logs
    rm -f /tmp/lasi_install.log
}

check_Port () {
    #check if ports are in use before starting
    if lsof -i tcp@0.0.0.0:$set_port > /dev/null; then
        # ask if user want's to set another port
        echo 
        echo "$set_app runs on http://$HOSTNAME:$set_port by default,"
        echo "but that is in use allready."
        echo "Trying other ports to run on..."

        # starting a +100 loop to find next availabe port
        while lsof -i tcp@0.0.0.0:$set_port > /dev/null; do
            set_port=$(($set_port +100))
        done

        # new port found, now set it
        echo "$set_port is free, $set_app wil be set to use it."

        # uncapitalize programname
        set_app_lower=$(echo $set_app | tr '[A-Z]' '[a-z]')

        # edit configfile to set new port
        sudo sed -i "
            /=/s/PORT.*/PORT=$set_port/
        " /etc/default/$set_app_lower
        echo "Port $set_port is set in /etc/default/$set_app_lower..."
        echo "This will always override ports set in config.ini or webinterface!"
    fi
}


### HELP MESSAGE ###
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


### CHECK COMMANDLINE STUFF ###

# set defaults
unattended=0
ask_schedule=0
schedule=0
uninstaller=remove

# create array
options=( $@ )

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
        echo "4. Maraschino             9. Tranmission"
        echo "5. Sabnzbdplus           10. XBMC (desktop)"
        echo 
        # tell about commandline options
        if [ $unattended != 0 ]; then
            echo "Unattended installation enabled"
        else
            echo "Tip: Type LaSi.sh --help for more install options!"
        fi
        if [ $ask_schedule = 1 ]; then
            echo "Cronjobs set to 'ask'."
        elif [ $schedule != 0 ]; then
            echo "Cronjobs set to $schedule."
        fi

        echo 
        echo "Q. Quit"

        read SELECT

        # create array
        items=( $SELECT )

        # go through array one by one
        for item in ${items[@]}; do

            # first check if sources need an update
            if [ $unattended = 1 ]; then [ $update_apt = 1 ] || update_Apt; fi

            case "$item" in

                # beets
                1)
                    set_app=Beets
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
                    ;;

                # couchpotato
                2)
                    set_app=CouchPotato
                    set_port=5000
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
                    ;;

                # headphones
                3)
                    set_app=Headphones
                    set_port=8181
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
                    ;;

                # mediafrontpage
                mfp)
                    set_app=Mediafrontpage
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
                    ;;

                # maraschino
                4)
                    set_app=Maraschino
                    set_port=7000
                    packages="flask flask-sqlalchemy cherrypy jsonrpclib"
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
                    ;;

                # sabnzbdplus
                5)
                    set_app=Sabnzbdplus
                    set_port=8080
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    ;;

                # sickbeard
                6)
                    set_app=SickBeard
                    set_port=8081
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
                    ;;

                # spotweb
                7)
                    set_app=Spotweb
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
                    ;;

                # subliminal
                8)
                    set_app=Subliminal
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    if [ $ask_schedule = 1 ]; then cf_Cronjob; elif [ $schedule != 0 ]; then set_Cronjob; fi
                    ;;

                # transmission
                9)
                    set_app=Transmission
                    set_port=9091
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    ;;

                # xbmc
                10)
                    set_app=XBMC
                    if [ $unattended = 1 ]; then Install_$set_app; else Info_$set_app; fi
                    ;;

                [Qq]) exit ;;

                *)
                    echo "Please make a selection (e.g. 1)"
                    echo "Or select multiple (e.g. 1 4 5 7 10)"
                    show_Menu
                    ;;
            esac
        done

    # see if install summary is needed, so count items in array
    if [ ${#items[@]} -gt 1 ]; then
        echo "*###############################################################*"
        echo "*################### INSTALL SUMMARY ###########################*"
        cat /tmp/lasi_install.log
        echo "*###############################################################*"
    fi

    # give time to read output from above installprocess before returning to menu
    echo 
    read -sn 1 -p "Press a key to continue"
    LaSi_Menu
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

    check_Pip
    sudo $pip install beets || { sudo $easy_install beets || error_Msg; }
    sudo $pip install rgain || { sudo $easy_install rgain || echo "Fail!"; }

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

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_Beets () {
echo "
Done! Installed $set_app.
Type beet --help for options
or start importing with beet import /path/to/new_music
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
    wget -nv -O /tmp/couchpotato.deb $DROPBOX/LaSi_Repo/couchpotato.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }

    sudo dpkg -i /tmp/couchpotato.deb || error_Depends

    if ! pgrep -f CouchPotato.py > /dev/null; then
        #check_Port
        sudo sed -i "
            s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
            s/RUN_AS.*/RUN_AS=$USER/
            s/WEB_UPDATE=0/WEB_UPDATE=1/g
        " /etc/default/couchpotato
        echo "Changed daemon settings..."
        sudo /etc/init.d/couchpotato start || error_Msg
    fi

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_CouchPotato () {
echo "
Done! Installed $set_app.
Type couchpotato --help for options.
CouchPotato is by default located @ http://$HOSTNAME:$set_port
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
    wget -nv -O /tmp/headphones.deb $DROPBOX/LaSi_Repo/headphones.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }

    sudo dpkg -i /tmp/headphones.deb || error_Depends

    if ! pgrep -f Headphones.py > /dev/null; then
        #check_Port
        sudo sed -i "
            s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
            s/RUN_AS.*/RUN_AS=$USER/
            s/WEB_UPDATE=0/WEB_UPDATE=1/g
        " /etc/default/headphones
        echo "Changed daemon settings..."
        sudo /etc/init.d/headphones start || error_Msg
    fi

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_Headphones () {
echo "
Done! Installed $set_app.
Type headphones --help for options
Headphones is by default located @ http://$HOSTNAME:$set_port
"
}


####################
#### MARASCHINO ####
####################

Info_Maraschino () {
    clear
    echo "
*###############################################################*
*###################### MARASCHINO #############################* 
#                                                               #
# Maraschino is a webpage that overviews a XBMC-mediacenter     #
# and serverapplications like Sabnzbd, Sickbeard and others.    #
#                                                               #
# Some of it's features are:                                    #
#   - Customizable applications module with:                    #
#   - recently added media                                      #
#   - Currently playing bar                                     #
#   - Sabnzbd module                                            #
#   - SickBeard coming episodes                                 #
#   - Trakt.tv recommendations                                  #
#   - Diskspace info                                            #
#                                                               #
*###############################################################*
#                                                               #
# Maraschino is written by Mr. Kipling and others               #
#                                                               #
# Visit http://www.maraschinoproject.com/                       #
*###############################################################*"
    cf_Choice
}


Install_Maraschino () {

    check_Git
    wget -nv -O /tmp/maraschino.deb $DROPBOX/LaSi_Repo/maraschino.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }

    Question () {
        echo 
        echo "Choose a branch to install"
        echo "1. Master"
        echo "2. Experimental"
        read -p ": " VERSION
        echo 
        case $VERSION in
            1*)
                check_Pip
                echo 
                echo "Python-setuptools will now install the following packages:"
                echo "$packages ..."
                sudo $pip install $packages > /dev/null || { sudo $easy_install $packages > /dev/null || error_Msg; }
                sudo dpkg -i /tmp/maraschino.deb || error_Depends
                ;;
            2*)
                sudo dpkg -i /tmp/maraschino.deb || error_Depends
                cd /opt/maraschino && sudo git checkout experimental > /dev/null; cd - >/dev/null
                ;;
            *)
                echo "Answer 1 or 2"
                Question
                ;;
        esac
    }
    Question

    if ! pgrep -f "maraschino.py -q" > /dev/null; then
        #check_Port
        sudo sed -i "
            s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
            s/RUN_AS.*/RUN_AS=$USER/
            s/WEB_UPDATE=0/WEB_UPDATE=1/g
        " /etc/default/maraschino
        echo "Changed daemon settings..."
        sudo /etc/init.d/maraschino start || error_Msg
    fi

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_Maraschino () {
echo "
Done! Installed $set_app.
$set_app is by default located @ http://$HOSTNAME:$set_port
"
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
    cf_Choice
}

Install_Mediafrontpage () {

    check_Git
    wget -nv -O /tmp/mediafrontpage.deb $DROPBOX/LaSi_Repo/mediafrontpage.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
    sudo dpkg -i /tmp/mediafrontpage.deb || error_Depends

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_Mediafrontpage () {
echo "
Done! Installed $set_app.
Mediafrontpage is now located @ http://$HOSTNAME/mediafrontpage
"
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
    cf_Choice
}


Install_Sabnzbdplus () {

    # check if python-software-properties is installed (not by default on minimal servers)
    check_PPA

    # Check if ppa is used as a source
    if ! ls /etc/apt/sources.list.d/jcfp-ppa* > /dev/null; then
        sudo add-apt-repository ppa:jcfp/ppa
    fi

    # Update list, install and configure
    echo "Checking for newest version..."
    sudo apt-get update > /dev/null
    sudo apt-get -y install sabnzbdplus || error_Depends

    if ! pgrep -f /usr/bin/sabnzbplus > /dev/null; then
        #check_Port
        sudo sed -i "
            /=/s/USER.*/USER=$USER/
            /=/s/HOST.*/HOST=0.0.0.0/
        " /etc/default/sabnzbdplus
        echo "Changed daemon settings..."
        sudo /etc/init.d/sabnzbdplus start || error_Msg
    fi

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_Sabnzbdplus () {
echo "
Done! Installed $set_app.
Type sabnzbdplus --help for options
Sabnzbdplus is by default located @ http://$HOSTNAME:$set_port
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
    wget -nv -O /tmp/sickbeard.deb $DROPBOX/LaSi_Repo/sickbeard.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
    sudo dpkg -i /tmp/sickbeard.deb || error_Depends

    if ! pgrep -f SickBeard.py > /dev/null; then
        #check_Port
        sudo sed -i "
            s/ENABLE_DAEMON=0/ENABLE_DAEMON=1/g
            s/RUN_AS.*/RUN_AS=$USER/
            s/WEB_UPDATE=0/WEB_UPDATE=1/g
        " /etc/default/sickbeard
        echo "Changed daemon settings..."
        sudo /etc/init.d/sickbeard start || error_Msg
    fi

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_SickBeard () {
echo "
Done! Installed $set_app
Type sickbeard --help for options
SickBeard is by default located @ http://$HOSTNAME:$set_port
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

    check_Git
    wget -nv -O /tmp/spotweb.deb $DROPBOX/LaSi_Repo/spotweb.deb || { echo "Connection to dropbox failed, try again later"; exit 1; }
    sudo dpkg -i /tmp/spotweb.deb || error_Depends

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

    # update database
    cd /var/www/spotweb && /usr/bin/php /var/www/spotweb/upgrade-db.php
    cd - > /dev/null


Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log


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
                if [ $new_database = 1 ]; then
                    echo 
                    echo "You need to set your newsserver and other options first in spotweb."
                    echo "Go to http://$HOSTNAME/spotweb/?page=editsettings"
                    echo "Login with admin / admin"
                    echo "and set it at the Nieuwsserver-tab, after that, continue ..."
                    read -sn 1 -p "Press a key to continue"
                fi
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
echo "
Done! Installed $set_app.
Spotweb is now located @ http://$HOSTNAME/spotweb
Run /var/www/spotweb/retrieve.php to fill the database with spots
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

    check_Pip
    sudo $pip install subliminal || { sudo $easy_install subliminal || error_Msg; }
    sudo $pip install argparse || { sudo $easy_install argparse || error_Msg; }

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_Subliminal () {
echo "
Done! Installed $set_app.
Type subliminal --help for options
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

    sudo apt-get -y install transmission-daemon || error_Depends

    if grep 'USER=debian-transmission' /etc/init.d/transmission-daemon > /dev/null; then
        sudo /etc/init.d/transmission-daemon stop > /dev/null || error_Msg
        sudo sed -i "s/USER=debian-transmission/USER=$USER/g" /etc/init.d/transmission-daemon
        sudo sed -i "s#CONFIG_DIR=\"/var/lib/transmission-daemon/info\"#CONFIG_DIR=\"$HOME/.transmission\"#g" /etc/default/transmission-daemon
    fi

    if ! [ -e $HOME/.transmission/settings.json ]; then
        # start-stop to create config at new location
        sudo /etc/init.d/transmission-daemon start > /dev/null || error_Msg
        sudo /etc/init.d/transmission-daemon stop > /dev/null || error_Msg
    fi

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
    echo "And very important:"
    echo "IP-adresses from which you want to connect from"
    echo "\"rpc-whitelist\": \"127.0.0.1,192.168.1.*\","

    # check if default port is in use and tell to set another if it is
    if lsof -i tcp@0.0.0.0:$set_port > /dev/null; then
        echo 
        echo "The default port $set_port is in use, you need to"
        echo "edit \"rpc-port\": \"9091\" to another port."
        while lsof -i tcp@0.0.0.0:$set_port > /dev/null; do
            set_port=$(($set_port +100))
        done
        echo "For example port $set_port is free."
    fi

    # give time to read output from above installprocess before returning to menu
    echo 
    read -sn 1 -p "Press a key to edit the $HOME/.transmission/settings.json"
    editor $HOME/.transmission/settings.json

    # start with all new settings
    sudo /etc/init.d/transmission-daemon start || error_Msg

Summ_$set_app
Summ_$set_app >> /tmp/lasi_install.log

}

Summ_Transmission () {
echo "
Done! Installed $set_app.
Type tranmission-daemon --help for options
Transmission is by default located @ http://$HOSTNAME:9091
"
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
        echo "2. Live (stable only)"
        echo "3. Unstable, but has newer features"
        read -p ": " VERSION
        case $VERSION in
            1*|2*)
                # check if python-software-properties is installed (not by default on minimal servers)
                check_PPA
                sudo add-apt-repository ppa:team-xbmc || error_Msg
                distro=$(ls /etc/apt/sources.list.d/team-xbmc* | sed "s/.*ppa-\|\.list//g")
                ;;
            3*)
                # check if python-software-properties is installed (not by default on minimal servers)
                check_PPA
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

    case $VERSION in
        1*)
            sudo apt-get -y install xbmc xbmc-standalone || error_Depends
            Summ_XBMC_stable
            Summ_XBMC_stable >> /tmp/lasi_install.log
            ;;
        2*)
            sudo apt-get -y install xorg alsa-base xbmc xbmc-live  || error_Depends
            Summ_XBMC_Live
            Summ_XBMC_Live >> /tmp/lasi_install.log
            ;;
        3*)
            sudo apt-get -y install xbmc || error_Depends
            Summ_XBMC_unstable
            Summ_XBMC_unstable >> /tmp/lasi_install.log
            ;;
    esac

}

Summ_XBMC_stable () {
echo "
Done! Installed XBMC stable.
XBMC can now be started from the menu
or can be set in the loginscreen as a desktopmanager.
"
}

Summ_XBMC_Live () {
echo "
Done! Installed XBMC Live.
Reboot your machine and XBMC will be started
"
}

Summ_XBMC_unstable () {
echo "
Done! Installed XBMC unstable.
XBMC can now be started from the menu.
"
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
            echo "2. Uninstall $set_app"
            echo 
            echo "B. Back to menu"
            echo "Q. Quit"
            ;;
        *)
            echo 
            echo "Options:"
            echo "1. Install $set_app"
            echo "2. Remove $set_app"
            echo "3. Set cronjob for $set_app"
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
            cf_Uninstall
            ;;
        3)
            case $set_app in
                Sabnzbdplus|Transmission|XBMC)
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
    echo "Are you sure you want to continue and install $set_app?"
    read -p "[yes/no]: " REPLY
    echo
    case $REPLY in
    [Yy]*)
        # update sources if needed
        [ $update_apt = 1 ] || update_Apt
        Install_$set_app
        # give time to read output from above installprocess before returning to menu
        echo 
        read -sn 1 -p "Press a key to continue"
        # for multiple install continue in next item, else back to info
        if [ "${#items[@]}" = 1 ]; then
            Info_$set_app
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


cf_Uninstall () {

    set_app_lower=$(echo $set_app | tr '[A-Z]' '[a-z]')

    echo 
    echo "Are you sure you want to continue and $uninstaller $set_app?"
    read -p "[yes/no]: " REPLY
    echo
    case $REPLY in
    [Yy]*)
        case $set_app in
            Beets|Subliminal)
                sudo $pip uninstall $set_app_lower || error_Msg
                ;;
            *)
                sudo apt-get -y $uninstaller $set_app_lower
            ;;
        esac
        # give time to read output from above installprocess before returning to menu
        echo 
        read -sn 1 -p "Press a key to continue"
        # for multiple install continue in next item, else back to info
        if [ "${#items[@]}" = 1 ]; then
            Info_$set_app
        fi
        ;;
    [Nn]*)
        LaSi_Menu
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



##################
#### CRONJOBS ####
##################

set_Cronjob () {

    # set updaters
    set_app_lower=$(echo $set_app | tr '[A-Z]' '[a-z]')

    case $set_app in
        CouchPotato|Headphones|SickBeard|Maraschino)

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
    [ -e /etc/cron.weekly/$set_app_lower ] && sudo rm -f /etc/cron.weekly/$set_app_lower
    [ -e /etc/cron.monthly/$set_app_lower ] && sudo rm -f /etc/cron.monthly/$set_app_lower


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

    sudo mv -f /tmp/$set_app_lower /etc/cron.$schedule/$set_app_lower || error_Msg
    sudo chmod +x /etc/cron.$schedule/$set_app_lower  || error_Msg

Summ_Cronjob
Summ_Cronjob >> /tmp/lasi_install.log

}

Summ_Cronjob () {
echo "Checking $schedule for $set_app updates.
Script placed in /etc/cron.$schedule/$set_app_lower.
Check /etc/crontab for the exact times these jobs will be run.
"
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
    echo "S. Skip"
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
        [Ss]*)
            echo "No cronjob set"
            break
            ;;
        [Qq]*)
            Info_$set_app ;;
        *)
            echo "Please choose... (e.g. 2)"
            cf_Cronjob
            ;;
    esac

if [ $ask_schedule = 0 ]; then
    # give time to read output from above installprocess before returning to menu
    echo 
    read -sn 1 -p "Press a key to continue"
    # for multiple install continue in next item, else back to info
    if [ "${#items[@]}" = 1 ]; then
        Info_$set_app
    fi
fi

}


### RUN ALL FUNCTIONS ###
update_apt=0                    # this is set to 1 if one of repo-softwares is installed and updates the sources
check_Apt                       # checks if this script is run on a debian-based machine
check_Variables                 # checks for fast install and cronjob options which can be set @ commandline
check_Deb                       # removes all previous used custommade deb-files from /tmp
check_Log                       # Shows an installsummary if multiple programs were installed.
LaSi_Menu                       # Show menu

