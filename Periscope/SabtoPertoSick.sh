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

DIR=$1;                                     #### Pathname passed by Sabnzbd
NZB=$2;                                     #### Clean nzb-name passed by Sabnzbd (unused in this script)
GARBAGE=".nfo .srr .sfv .nzb .jpg"          #### Add or remove extensions here

Periscope () {  #### Find subtitles
echo "--------------------------"
echo $(date)
echo ': Starting subtitle search'

find "$DIR" \( -name *.avi -o -name *.mkv \) -type f -exec /usr/bin/python PATH_PERISCOPE/downloadSub.py {} \;

echo $(date)
echo ': Subtitle search ended'
echo "--------------------------"
}

Cleanup () { #### Remove unwanted files
for junk in $GARBAGE
do
find $DIR -name *$junk -type f -exec rm -f {} \;
done
}


Sickbeard () { #### Pass to sickbeard for Processing
echo "--------------------------"
echo $(date)
echo ': Starting Sickbeard processing'

/usr/bin/python /PATH_SICKBEARD/autoProcessTV/sabToSickBeard.py $DIR $NZB 

echo $(date)
echo ': SickBeard processing ended'
echo "--------------------------"
}

#### FUNCTIONS ####
Periscope
#Cleanup #UNCOMMENT IF YOU WANT TO CLEAN FILES
Sickbeard





