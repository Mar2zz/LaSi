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
# |
# | - Auto-Sub
# | - Beets
# | - CouchPotato
# | - Headphones
# | - SABnzbd+
# | - Sickbeard
# | - Subliminal
# | - Spotweb
# | - Transmission
# | - XBMC
# |___________________________________________________________________________________
#
#######################################################################################
#######################################################################################

# Debian based
if which apt-get > /dev/null; then
	wget -nv -O /tmp/LaSi_Deb.sh http://dl.dropbox.com/u/18712538/LaSi/LaSi_Deb.sh || { echo "Connection to dropbox failed, try again later"; exit 1; }
	sudo chmod +x /tmp/LaSi_Deb.sh &&
	/tmp/./LaSi_Deb.sh
# Synology
elif which ipkg; then
	wget -nv -O /tmp/LaSi_syn.sh http://dl.dropbox.com/u/18712538/LaSi/LaSi_syn.sh || { echo "Connection to dropbox failed, try again later"; exit 1; }
	sudo chmod +x LaSi_Deb.sh &&
	/tmp/./LaSi_Deb.sh
# FreeBSD based
elif [ "`uname`" = "FreeBSD" ]; then
	# Check if user can sudo
	if [ "$(id -u)" != "0" ]; then
		# ZFSguru SSH user can't sudo, need to su
		if [ "`whoami`" = "ssh" ];then
			clear
			echo "Now going to SU"
			echo "You need to run LaSi.sh again"
			sleep 2
			su
		else
			echo "Provide sudo password to continue with this installation..."
			if [ "$(sudo id -u)" != "0" ]; then
				clear
				echo
				echo "The current user can't sudo,"
				echo
				echo "this installer needs to sudo to install applications"
				echo "You need to perform this command: "EDITOR=ee visudo""
				echo "and uncomment the following line: %wheel ALL=(ALL) ALL"
				echo
				sleep 2
				exit
			fi
		fi
	elif ! ls /tmp/LaSi > /dev/null; then
		sudo mkdir /tmp/LaSi
	fi
	
	cd /tmp/LaSi &&
	fetch http://dl.dropbox.com/u/18712538/LaSi/LaSi_BSD.sh || { echo "Connection to dropbox failed, try again later"; exit 1; }
	sudo chmod +x LaSi_BSD.sh &&
	./LaSi_BSD.sh
fi
