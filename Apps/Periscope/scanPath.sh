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


DIR=/PATH/TO/VIDEOS;
AGE=AGE_DAYS;

echo "--------------------------"
echo $(date)
echo ": Starting subtitle search"

find "$DIR" \( -name *.avi -o -name *.mkv \) -mtime -$AGE -type f -exec /usr/bin/python PATH_PERISCOPE/downloadSub.py {} \;

echo $(date)
echo ": Subtitle search ended"
echo "--------------------------"
