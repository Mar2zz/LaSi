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
NAS=hostname;


#######################################################################################
#################### LIST APPS USED ###################################################

APP1=Spotweb;
APP1_INST=spotwebinstall_syn.sh;

APP2=Periscope;
APP2_INST=periscopeinstall_syn.sh;

APP3=Mediafrontpage
APP3_INST=mediafrontpageinstall_syn.sh;

APP4=SickBeard;
APP4_INST=sickbeardinstall_syn.sh;

APP5=CouchPotato;
APP5_INST=couchpotatoinstall_syn.sh;

APP6=Headphones
APP6_INST=headphonesinstall_syn.sh;

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
		echo "1. Spotweb (Dutch NZB Community)		4. SickBeard (TV Shows)"
		echo "2. Periscope (Subtitles)			5. CouchPotato (Movies)"
		echo "3. Mediafrontpage (HTPC Organiser)	6. Headphones (Music)"
		echo "Q. Quit"
		echo
		echo "Warning: You need to have bootstrap installed to install these applications!"

		read -p "Choose an option: " SELECT
		case "$SELECT" in
			[1]*)
				info_Spotweb
				;;
			[2]*)
				info_Periscope
				;;
			[3]*)
				info_Mediafrontpage
				;;
			[4]*)
				info_Sickbeard
				;;
			[5]*)
				info_Couchpotato
				;;
			[6]*)
				info_Headphones
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


#### MEDIAFRONTPAGE ####
info_Mediafrontpage () {
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
SET_APP=$APP3
SET_INST=$APP3_INST
cf_Choice
}


#### SICKBEARD ####

info_Sickbeard () {
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
SET_APP=$APP4
SET_INST=$APP4_INST
cf_Choice
}


#### COUCHPOTATO ####

info_Couchpotato () {
clear
echo "
*###################### COUCHPOTATO ######################### 
#
# CouchPotato is an automatic NZB and torrent downloader. 
# You can keep a 'movies I want'-list and it will search 
# for NZBs/torrents of these movies every X hours.	
#
# Once a movie is found, it will send it to SABnzbd
# or download the .nzb or .torrent to a	# specified directory.
#
*############################################################
#
# CouchPotato is written by Ruud Burger in his spare time...
# ..so buy him a coke to support him.
#
# Visit http://www.couchpotatoapp.com
*#############################################################"
SET_APP=$APP5
SET_INST=$APP5_INST
cf_Choice
}


#### HEADPHONES ####

info_Headphones () {
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

	get_Installer () {
	if [ -e $SET_INST ]
		then
		rm -f $SET_INST
	fi
	if wget $DROPBOX/$SET_INST
		then
		chmod +x $SET_INST &&
		./$SET_INST &&
		LaSi_Menu
	else
		echo "Download failed, testing $CONN2..."
		dropbox_Test () {
		if ! ping -c 1 $CONN2 > /dev/null 2>&1 
			then
			echo "$CONN2 seems down..."
			echo "Need $CONN2 to install... Now exiting"
			LaSi_Menu
		fi
		}
		dropbox_Test
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






