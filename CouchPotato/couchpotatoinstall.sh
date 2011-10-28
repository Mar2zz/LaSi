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
# | execute this script with the command sudo chmod +x couchpotatoinstall.sh
# | and run with ./couchpotatoinstall.sh 
# |            
# | answer all questions the terminal asks,
# | and couchpotato will be running in no time!
# |___________________________________________________________________________________
#
# Tested succesful on OS's:
# Ubuntu 10.4 Desktop, Ubuntu 10.4 Minimal server, XBMC Live Dharma
#
#######################################################################################
#######################################################################################

VERSION=v0.8


#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

APP=CouchPotato;                    # name of app to install 
APP_LOW=couchpotato;                 # lowercase appname

CONN1=github.com;                   # to test connections needed to install apps
CONN2=dropbox.com;

DROPBOX=http://dl.dropbox.com/u/18712538/;        #dropbox-adres

PACKAGES="git python";              #needed packages to run (use a space as delimiter)






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
echo '-------------------------------------'
echo 'COUCHPOTATO IS CREATED BY RUUD BURGER'
echo '-------------- www.couchpotatoapp.com'
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


#### PRESENT OPTIONS IN A MENU ####
show_Menu (){
    LaSi_Logo                   #some basic info about installer
    show_Author                 #creator of the app installed
    echo
    echo "1. (re)Install $APP"
    echo "2. Update $APP"
    echo "3. Exit script"
    echo
    echo "Choose one of the above options"
    read -p "Enter 1, 2 or 3: " CHOICE
    case $CHOICE in
        1)
            install_Packages    #check dependencys
            install_Program     #download and install with .deb file
            start_App           #Start the application and gl!
            show_Menu
            ;;
        2)
            git_Update
            show_Menu
            ;;
            
        3)
            LaSi_Menu        #Return to main script
            ;;
        *)
            echo "Enter 1, 2 or 3"
            show_Menu
            ;;
    esac
}


#######################################################################################
#### CHECK AND INSTALL PACKAGES #######################################################

#### INSTALL DEPENDENCYS ####
install_Packages() {
echo
echo "Check for dependencys and install if needed"
sudo apt-get install -y $PACKAGE
}

install_Program () {
echo
echo "Downloading $APP"
wget -O /tmp/$APP_LOW.deb $DROPBOX/LaSi_repo/$APP_LOW.deb &&
echo "
* Installing $APP"
if sudo dpkg -i /tmp/$APP_LOW.deb | grep "daemon not enabled"; then cf_Daemon; fi
}


#### CONFIRM DAEMON INSTALL ####
cf_Daemon () {
echo
echo '-------'
echo "You can run $APP as a daemon, so it will start when your pc starts..."
echo '-------'
echo

    Question() {
    echo "Do you want to run $APP as a daemon?"
    read -p "(yes/no): " DAEMON
    case $DAEMON in
        [YyJj]*)
            read -sn 1 -p "Press a key to set daemon-options"
            sudo editor /etc/default/$APP_LOW
            sudo /etc/init.d/$APP_LOW start
            echo "Type $APP_LOW --help for a list of options."
            read -sn 1 -p "Press a key to continue."
            ;;
        [Nn]*)
            echo "You can start app manual, just type $APP_LOW in terminal"
            echo "Type $APP_LOW --help for a list of options."
            read -sn 1 -p "Press a key to continue."
            ;;
        *)
            echo "Answer yes or no"
            Question
            ;;
    esac
    }
Question
}

#### UPDATE APP ####
git_Update () {
    echo
    echo "===="
    echo "Just type:
    $APP_LOW --force-update
    in terminal to update and --help for other options"
    read -sn 1 -p "Press a key to continue."
    echo "===="
}

#### RETURN TO MENU ####
    LaSi_Menu () {
    echo
    read -sn 1 -p "Press a key to exit."
    exit
    }


#### ALL FUNCTIONS ####    
conn_Test        #connection test for url's used in installation
root_Test        #test user is not root but has sudo
show_Menu        #present choices for installation

