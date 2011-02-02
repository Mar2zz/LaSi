#!/usr/bin/env bash

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: Same as GPL I guess. hey, it's just text. give credit and edit.
#
#
# This script is part of "Lazy admin Scripted installers (LaSi)"
#
# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues
#
# Download main script @
# http://dl.dropbox.com/u/18712538/LaSi/LaSi.sh
#------------------------------------------


#autotag, replaygain, find albumart and rename/move music into your library
#This script can be used in a cronjob to scan a specific directory from time to time
#NEVER use this script on your musiclibrary!!!

DIR="/path/to/process"; 				#fullpath with musicfiles you want to tag (do not point to your musiclibrary!!!)
FAILDIR="/path/to/UNTAGGED"; 			#directory to move files that were not autotagged
SUCCESDIR="/path/to/TAGGED";				#directory to keep original files that were tagged and moved to library 


#### PROCESSING FILES ####
process () {
echo "--------------------------"
echo $(date)
echo "Starting renamealbum for $NZB"

/usr/bin/python /path/to/renamealbum -R --no-embed-coverart $DIR

echo $(date)
echo "Album search ended for $NZB"
}


#### MOVE UNIDENTIFIED FOLDERS ####
move_Failed () {
if grep -R --include=report.txt -i "fail!" $DIR >> /tmp/fail.txt
	then
	sed -i "s#report.txt:fail!##g" /tmp/fail.txt
	mv -f $(cat /tmp/fail.txt) $FAILDIR
	echo "The following albums weren't identified:"
	echo $(cat /tmp/fail.txt)
fi
}
	
#### MOVE IDENTIFIED SOURCEFILES ####
move_Succes () {	
if grep -R --include=report.txt -i "succes!" $DIR >> /tmp/succes.txt
	then
	sed -i "s#report.txt:succes!##g" /tmp/succes.txt
	mv -f $(cat /tmp/succes.txt) $SUCCESDIR
	echo "The following albums were identified:"
	echo $(cat /tmp/succes.txt)
fi
}

#### DELETE IDENTIFIED SOURCEFILES ####
delete_Succes () {
if grep -R --include=report.txt -i "succes!" $DIR >> /tmp/succes.txt
	then
	sed -i "s#report.txt:succes!##g" /tmp/succes.txt
	rm -Rf $(cat /tmp/succes.txt) $SUCCESDIR 
	echo "The following albums were identified:"
	echo $(cat /tmp/succes.txt)
fi
}


#### REMOVE LOGS TO AVOID USING THEM OVER AND OVER AGAIN ####
clean_Up ()
if [ -e /tmp/fail.txt ]
	then 
	rm -f /tmp/fail.txt
fi

if [ -e /tmp/succes.txt ]
	then 
	rm -f /tmp/succes.txt
fi
echo "--------------------------"
}



#### CALLING FUNCTIONS ####
process					#DEFAULT POSTPROCESSING STUFF
move_Failed #			#COMMENT IF YOU WANT THE SOURCEFILES TO STAY WHERE THEY ARE WHEN NOT IDENTIFIED
move_Succes #			#COMMENT IF YOU WANT THE SOURCEFILES TO STAY WHERE THEY ARE WHEN IDENTIFIED
#delete_Succes #		#UNCOMMENT THIS IF YOU WANT TO DELETE SOURCEFILES WHEN SUCCESFUL IDENTIFIED (ALSO COMMENT move_Succes)
clean_Up				#REMOVES LOGS TO AVOID USING THEM OVER AND OVER AGAIN


