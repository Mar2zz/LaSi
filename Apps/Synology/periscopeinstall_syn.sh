#!/bin/sh

# Author:  Mar2zz
# blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3

## Periscope Install script for Synology by Mar2zz

## v0.1.

# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues

# Based on the tutorials by J. van Emden (Brickman)
# http://synology.brickman.nl/syn_howto/HowTo%20-%20install%20Periscope.txt


######## INSTALLATION ########

NAS=$(hostname);
INSTALLDIR="/volume1/@appstore";


## Check if ipkg is installed by updating the packagelist
if ! ipkg update
	then
	echo "Bootstrap is not installed, please install it before using this script"
	echo "Information how to install bootstrap can be found on" 
	echo "http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc#How_to_install_ipkg"
	exit
fi

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


show_Menu (){
echo "1. (re)Install Periscope"
echo "2. Add a cronjob to search for subtitles"
echo "3. Update Periscope"
echo "4. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2, 3 or 4: " CHOICE
case $CHOICE in
	1)
		install_Apps
		prep_Scripts
		cf_Language
		show_Menu
		;;
	2)
		set_Path
		set_Age
		check_Cron
		add_Cron
		show_Menu
		;;
		
	3)
		echo "Check for update..."
		cd $INSTALLDIR/periscope &&
		svn update
		show_Menu
		;;
	4)
		echo "Have fun using periscope"
		exit
		;;
	*)
		echo "Enter 1, 2, 3 or 4"
		show_Menu
		;;
esac
}


## Install all needed apps
install_Apps () {
if ! $(which svn) 
	then
	ipkg install svn
fi

get_Periscope () {
# checkout latest version from googlecode
cd $INSTALLDIR &&
svn checkout http://periscope.googlecode.com/svn/trunk/periscope &&
mkdir -p periscope/cache

## make sure python 2.6 is present
if ! $(which python | grep "python2.6")
	then
	ipkg install python26
fi

# get BeautifulSoup and clean up after
wget http://www.crummy.com/software/BeautifulSoup/download/3.x/BeautifulSoup-3.2.0.tar.gz &&
tar -xvzf BeautifulSoup-3.2.0.tar.gz &&
rm -rf BeautifulSoup-3.2.0.tar.gz &&
mv BeautifulSoup-3.2.0/BeautifulSoup.py periscope/plugins/ &&
rm -Rf BeautifulSoup-3.2.0

# get periscopeCLI-file and place it
wget -P $INSTALLDIR/periscope http://dl.dropbox.com/u/18712538/Periscope/downloadSub.py &&
sed -i "s#PATH_PERISCOPE#$INSTALLDIR/periscope/cache#g" $INSTALLDIR/periscope/downloadSub.py
}

# Check for existing installation
if [ -d $INSTALLDIR/periscope ]
	then
	backup_Periscope () {
	echo "$INSTALLDIR/periscope allready exists..."
	echo "Do you want to backup this folder?"
	read -p "Answer yes or no: " REPLY
	case $REPLY in
		[YyJj])
			mv -Rf $INSTALLDIR/periscope $INSTALLDIRperiscope_bak &&
			echo "Moved $INSTALLDIR/periscope to $INSTALLDIR/periscope_bak"
			get_Periscope
			;;
		[Nn])
			rm -Rf $INSTALLDIR/periscope
			echo "Removed $INSTALLDIR/periscope"
			get_Periscope
			;;
		*)
			echo "Answer yes or no"
			backup_Periscope
			;;
	esac
	}
	backup_Periscope
fi
}

#### DOWNLOAD ALL SCRIPTS THAT CAN BE USED
prep_Scripts () {
get_Scripts () {
echo '--------'
echo "Downloading subtitlesearch scripts"
echo '--------'
wget -P $INSTALLDIR/periscope http://dl.dropbox.com/u/18712538/Periscope/scanPath.sh
wget -P $INSTALLDIR/periscope http://dl.dropbox.com/u/18712538/Periscope/downloadSub.py
chmod +x $INSTALLDIR/periscope/scanPath.sh
}

#### SET PYTHON IN SCRIPTS ####
path_Python() {
sed -i "s#/usr/bin/python#python2.6#g" $INSTALLDIR/scanPath.sh
}

#### SET PERISCOPE PATH IN SCRIPTS ####
path_Periscope () {
sed -i "s#PATH_PERISCOPE#$INSTALLDIR/periscope#g" $INSTALLDIR/periscope/scanPath.sh
sed -i "s#PATH_PERISCOPE#$INSTALLDIR/periscope#g" $INSTALLDIR/periscope/downloadSub.py
}

get_Scripts
path_Python
path_Periscope

#### /PATH/TO/VIDEO INTO A VARIABLE
sed -i 's#/PATH/TO/VIDEOS#$1#g' $INSTALLDIR/periscope/scanPath.sh
}

#### CHOOSE LANGUAGES ####
cf_Language () {

	show_Language () {
	echo '--------'
	echo 'Periscope supports as many languages as the websites support'
	echo 'This install will set 2 languages, so take your pick...'
	echo '--------'
	echo 'SUPPORTED LANGUAGES'
	echo '-----------------------'
	echo 'ar    fa    ka    pt-br'
	echo 'ay    fi    kk    ro'
	echo 'bg    fr    ko    ru'
	echo 'bs    gl    lb    sk'
	echo 'ca    he    lt    sl'
	echo 'cs    hi    lv    sq'
	echo 'da    hr    mk    sr'
	echo 'de    hu    ms    sv'
	echo 'el    hy    nl    th'
	echo 'en    id    no    tr'
	echo 'eo    is    oc    uk'
	echo 'es    it    pl    vi'
	echo 'et    ja    pt    zh'
	echo '-----------------------'
	echo
	LANG_SET1="ar ay bg bs ca cs da de el en eo es et fa fi fr gl he hi hr hu hy id is it ja ka"
	LANG_SET2="kk ko lb lt lv mk ms nl no oc pl pt pt-br ro ru sk sl sq sr sv th tr uk vi zh"
	choose_Lang1
	choose_Lang2
	}
	
	choose_Lang1 () {
	echo "Choose your first (=preferred) language"
	read -p "e.g. en: " LANG1
	if echo "$LANG_SET1 $LANG_SET2" | grep $LANG1 >/dev/null
		then
		echo "First language set to $LANG1"
		sed -i "s/111/$LANG1/g" $INSTALLDIR/periscope/downloadSub.py
	else
		echo "Language not found, try again"
		choose_Lang1
	fi
	}

	choose_Lang2 () {
	echo "Choose your second language"
	read -p "e.g. nl :" LANG2
	if echo "$LANG_SET1 $LANG_SET2" | grep $LANG2 >/dev/null
		then
		echo "Second language set to $LANG2"
		sed -i "s/222/$LANG2/g" $INSTALLDIR/periscope/downloadSub.py
	else
		echo "Language not found, try again"
		choose_Lang2
	fi
	}
	show_Language
}


#### ADD CRONJOB ####
set_Path () {
echo
echo 'Please specify the full path to your folder containing files that need subs'
echo "e.g. /volume1/downloads/Videos"
echo "note: If you want to set more paths, run option 2: Add a cronjob again!"
read -p ":" BATCHPATH
if [ -d $BATCHPATH ]
	then
	echo "Periscope will search for subs for all avi and mkv-files in $BATCHPATH"
else
	echo "$BATCHPATH doesn't exist, try again"
	set_Path
fi
}

set_Age () {
echo
echo 'Please specify how many days back Periscope should search for'
echo "e.g. 7, then it will only search subs for videofiles not older then a week"
echo "This reduces the time Periscope will run on your system, which is more resource-friendly"
read -p ' :' AGE
if [ $AGE -eq $AGE ]
	then
	sed -i "s/AGE_DAYS/$AGE/g" $INSTALLDIR/periscope/scanPath.sh
else
	echo "$AGE is not a numeric value, try again"
	set_Age
	fi
}


check_Cron () {
if $(grep -q "scanPath.sh $BATCHPATH" /etc/crontab)
	then
	echo "The following cronjob for Periscope allready exists"
	echo $(grep "scanPath.sh $BATCHPATH" /etc/crontab)
	read -p "Do you want to replace this? (yes/no): " DOUBLE
	case $DOUBLE in
		[YyJj])
			sed -i 'scanPath.sh $BATCHPATH' /etc/crontab
			;;
		[Nn])
			echo "Crontab not edited"
			show_Menu
			;;
		*)
			echo "Answer yes or no"
			check_Cron
			;;
	esac
fi
}


add_Cron () {
echo "How often in hours should Periscope search for subs?"
echo "Valid answers are 1, 2, 3 etc..."
echo "Enter 6 to update every 6 hours, 12 for every twelve hours, etc...!"
read -p "Enter a digit: " $HOUR
if [ $HOUR -eq $HOUR ]
	then
	echo "0	*/$HOUR	*	*	*	root	sh $INSTALLDIR/periscope/scanPath.sh \"$BATCHPATH\" > /dev/null" >> /etc/crontab &&
	echo "Cronjob added for Periscope to retrieve spots every $HOUR hour(s)"
	/usr/syno/etc/rc.d/S04crond.sh stop &&
	/usr/syno/etc/rc.d/S04crond.sh start
else
	echo "You did not enter a digit, try again"
	add_Cron
fi
}


### Start with the menu ###
LaSi_Logo
show_Menu
