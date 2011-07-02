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

DROPBOX=http://dl.dropbox.com/u/18712538/Synology;	# dropbox-adres
CONN2=dropbox.com;					# to test connections needed

NAS=$(hostname)


#######################################################################################
#################### LIST APPS USED ###################################################

APP1=Spotweb;
APP1_INST=spotwebinstall_syn.sh;

APP2=Periscope;
APP2_INST=periscopeinstall_syn.sh;

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
		echo "1. Spotweb (Dutch Usenet Community)"
		echo "2. Periscope (Subtitle downloader)"
		echo
		echo "Q. Quit"
	
		read -p "Choose an option: " SELECT
		case "$SELECT" in
			[1]*)
				info_Spotweb
				;;
			[2]*)
				info_Periscope
				;;
			[Qq]*)
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


#### SPOTWEB ####

info_Spotweb () {
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
# http://$NAS/spotweb.
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
SET_APP=$APP1
SET_INST=$APP1_INST
cf_Choice
}


#### PERISCOPE ####

info_Periscope () {
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
SET_APP=$APP2
SET_INST=$APP2_INST
cf_Choice
}


#### BACKTOMENU OR INSTALL ####
cf_Choice () {
echo
echo "Options:"
echo "1. Install $SET_APP"
echo "2. Back to menu"
echo "Q. Quit"

read -p "Choose an option: " SELECT
	case "$SELECT" in
		[1]*)
			inst_App
			;;
		[2]*)
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

#### INSTALL APPLICATION
inst_App () {
	
	dropbox_Test () {
	if ! ping -c 1 $CONN2 > /dev/null 2>&1 
		then
		echo "Hmmm $CONN2 seems down..."
		echo "Need $CONN2 to install... Now exiting"
		LaSi_Menu
	else
		get_Installer
	fi
	}
		
		get_Installer () {
		if [ -e $SET_INST ]
			then
			rm -f $SET_INST &&
			wget $DROPBOX/$SET_INST &&
			chmod +x $SET_INST &&
			./$SET_INST &&
			LaSi_Menu
		else
			wget -P LaSi $DROPBOX/$SET_INST
			chmod +x $SET_INST &&
			./$SET_INST &&
			LaSi_Menu
		fi
		} 
	
	Question() {
	echo
	echo "Are you sure you want to continue and install $SET_APP?"
	read -p "(yes/no)   :" REPLY
	case $REPLY in
	[Yy]*)
		echo
		echo "Say hello to my little friend!"
		echo
		dropbox_Test
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






