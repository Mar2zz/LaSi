#!/usr/bin/env bash

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: Same as GPL I guess. hey, it's just text. give credit and edit.
#
# I modified J. van Emden (Brickman)'s script for Synology NAS devices
# original script can be found here: http://dl.dropbox.com/u/5653370/synology.html
#
# This script is part of "Lazy admin Scripted installers (LaSi)"
#
# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues
#
# Download main script @
# http://dl.dropbox.com/u/18712538/LaSi/LaSi.sh
#------------------------------------------


DIR=/home/marsjaco/Films;
AGE=7;

#echo "--------------------------"
#echo $(date)
#echo ": Starting subtitle search"

ORIGINAL=$(find $DIR -name *.avi -mtime -$AGE -type f  {} \;);

echo $(find $DIR -name *.avi -mtime -$AGE -type f  {} \;) >> $ORIGINAL.orig

#echo $(date)
#echo ": Subtitle search ended"
#echo "--------------------------"
