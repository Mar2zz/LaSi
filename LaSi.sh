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
# | # Periscope (alpha, not tested thoroughly)   
# | # AlbumIdentify (alpha, not tested yet)
# | # Spotweb                                   
# |___________________________________________________________________________________
#
# Tested succesful on OS's:
# Ubuntu 10.4 Desktop, Ubuntu 10.4 Minimal server, XBMC Live Dharma
#
#######################################################################################
#######################################################################################

                         		#### v1.0 ####
                         
TESTOS1=Ubuntu_10.4_Desktop
TESTOS2=Ubuntu_10.4_Server
TESTOS3=XBMC_Live_Dharma


#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

DROPBOX=http://dl.dropbox.com/u/18712538/ 				# dropbox-adres
CONN2=dropbox.com							# to test connections needed
													

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
		echo "1. $APP1"
		echo "2. $APP2"
		echo "3. $APP3 (needs updating)"
		echo "4. $APP4"
		echo "5. $APP5"
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
# or download the .nzb or .torrent to a	# specified directory.						 
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
# Als de installatie klaar is zal spotweb draaien op 
# http://$HOSTNAME/spotweb, maar je moet dan nog wel spots
# binnenhalen via php retrieve.php in de spotwebmap.
# 
# Je kunt kiezen tussen SQLite en mySQL database. De mySQL
# database moet je zelf aanmaken en configureren.
# SQlite werkt out of the box.
#
*############################################################
#
# Spotweb is geschreven door Spotweb (m.a.w. hij wil anoniem blijven).
#
# Visit https://github.com/spotweb/spotweb	
*#############################################################"
SET_APP=$APP5
SET_INST=$APP5_INST
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
	else
		mkdir_LaSi
	fi
	}
	
	mkdir_LaSi () {
	if [ ! -d LaSi ]
		then
		mkdir LaSi &&
		get_Installer
	else
		get_Installer
	fi
	}
		
		get_Installer () {
		if [ -e LaSi/$SET_INST ]
			then
			mv -f LaSi/$SET_INST LaSi/$SET_INST.bak &&
			wget -P LaSi $DROPBOX/$SET_APP/$SET_INST &&
			sudo chmod +x LaSi/$SET_INST &&
			./LaSi/$SET_INST &&
			LaSi_Menu
		else
			wget -P LaSi $DROPBOX/$SET_APP/$SET_INST
			sudo chmod +x LaSi/$SET_INST &&
			./LaSi/$SET_INST &&
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


                   	



