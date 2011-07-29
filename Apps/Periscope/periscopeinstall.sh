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
# | execute this script with the command sudo chmod +x periscopeinstall.sh
# | and run with ./periscopeinstall.sh 
# | 
# | answer all questions the terminal asks,
# | and periscope will be running in no time!
# |___________________________________________________________________________________
#
# Tested succesful on OS's:
# Ubuntu 10.4 Desktop, Ubuntu 10.4 Minimal server, XBMC Live Dharma
#
#######################################################################################
#######################################################################################

VERSION=v0.4 ####
                         
TESTOS1=Ubuntu_10.4_Desktop
TESTOS2=Ubuntu_10.4_Server
TESTOS3=XBMC_Live_Dharma

#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

APP=Periscope; 				# name of app to install (also for Dropboxfolders)
APPLOW=periscope;			# lowercase appname

CONN1=periscope.googlecode.com; 	# to test connections needed to install apps
CONN2=dropbox.com;
CONN3=crummy.com;

DROPBOX=http://dl.dropbox.com/u/18712538/ 				#dropbox-adres
SVN=http://periscope.googlecode.com/svn/trunk/periscope			#svn adres

BS=http://www.crummy.com/software/BeautifulSoup/download/3.x/BeautifulSoup-3.2.0.tar.gz
BSVERSION=BeautifulSoup-3.2.0;

PACK1=subversion;		#needed packages to run (using apt to check and install)
PACK1_EXE=svn;			#name_exe when execute command differs from packagename.
PACK2=python;
PACK2_EXE=$PACK2;
PACK3=python-xdg
PACK3_EXE=$PACK3

INSTALLDIR=/home/$USER/.$APPLOW;	#directory you want to install to.

SCANPATH=scanPath.sh;			#script to batchsearch
DOWN_SUB=downloadSub.py;		#Periscope CLI
SABPER=SabtoPeriscope.sh;		#Postprocessingscript Sabnzbd
SABPERSICK=SabtoPertoSick.sh;		#Postprocessingscript Sabnzbd to Periscope to Sickbeard



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
echo '--------------------------------'
echo 'PERSISCOPE IS CREATED BY PATRICK DESALLE'
echo '----------- code.google.com/p/periscope/'
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
	echo "Provide password to continue with this installation..."
	if [ "$(sudo id -u)" != "0" ] 
		then
	    echo "...but that's not gonna work, you need to sudo to install $APP, now exiting" &&
	    LaSi_Menu
	fi
	}
	
#### 2ND TEST IF USER IS ONLINE ####
	conn_Test () {
		
		conn1_test () {
		if ! ping -c 1 $CONN1 > /dev/null 2>&1
			then
			echo "Hmmm $CONN1 seems down..." &&
			echo "Need $CONN1 to install... Now exiting" &&
			LaSi_Menu
		fi
		}
		
		conn2_test () {
		if ! ping -c 1 $CONN2 > /dev/null 2>&1 
			then
			echo "Hmmm $CONN2 seems down..."
			echo "Need $CONN2 to install... Now exiting"
			LaSi_Menu
		fi
		}
		
		conn3_test () {
		if ! ping -c 1 $CONN3 > /dev/null 2>&1 
			then
			echo "Hmmm $CONN3 seems down..."
			echo "Need $CONN3 to install... Now exiting"
			LaSi_Menu
		fi
		}
	conn1_test
	conn2_test
	conn3_test
	}


#### PRESENT OPTIONS IN A MENU ####
show_Menu (){
LaSi_Logo 				#some basic info about installer
show_Author				#creator of the app installed
echo
echo "1. (re)Install $APP"
echo "2. Set a cronjob for $APP"
echo "3. Set Sabnzbd and/or Sickbeard postprocessing for $APP"
echo "4. Update $APP"
echo "5. Exit script"
echo
echo "Choose one of the above options"
read -p "Enter 1, 2, 3, 4 or 5: " CHOICE
case $CHOICE in
	1)
		check_Packs		#check dependencys
		set_Dir			#choose installation directory
		checkout_Svn		#check out SVN Repo and mv to $installdir
		get_BS			#get BeautifulSoup
		get_Scripts		#Download all scripts used
		path_Python		#check which python is used and update scripts
		path_Periscope		#check installdir and update scripts
		cf_Language		#set languages
		show_Menu
		;;
	2)
		set_Path_Cron		#set cronjobs
		show_Menu
		;;
	3)
		use_Sabnzbd		#set sabnzbd postprocessingscript
		show_Menu
		;;
	4)
		svn_Update
		show_Menu
		;;
	5)
		LaSi_Menu		#Return to main script
		;;
	*)
		echo "Enter 1, 2, 3, 4 or 5: "
		show_Menu
		;;
esac
}

#######################################################################################
#### CHECK AND INSTALL PACKAGES #######################################################

#### CHECK SOFTWARE: SUBVERSION AND PYTHON ####
	check_Packs () {
		
		check_Pack1 () {
		if ! which $PACK1_EXE
			then
			echo "Cannot find if $PACK1 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK1
			use_PM
		else
			echo "$PACK1 installed"
		fi
		}
		
		check_Pack2 () {
		if ! which $PACK2_EXE
			then
			echo
			echo "Cannot find if $PACK2 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK2
			use_PM
		else
			echo "$PACK2 installed"
		fi
		}

		check_Pack3 () {
		if ! which $PACK3_EXE
			then
			echo
			echo "Cannot find if $PACK3 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK3
			use_PM
		else
			echo "$PACK3 installed"
		fi
		}
	check_Pack1
	check_Pack2
	check_Pack3
	}
	
	
#### DETERMINE PACKAGEMANAGER ####
	use_PM () {
			
		def_PM () {
		[ -x "$(which $1)" ]
		}

		use_Apt () {
		sudo apt-get install $INST_PACK ||
		use_Manual
		}
	
		use_Yum () {
		sudo yum install $INST_PACK ||
		use_Manual
		}
		
		use_Pac () {
		sudo pacman -S $INST_PACK ||
		use_Manual
		}
		
		use_Manual () {
		echo
		echo "Installing $INST_PACK failed"
		echo "Please install manually..."
		echo
		echo "Type the command to install $INST_PACK"
		echo "e.g. sudo apt-get install $INST_PACK"
		read -p "   :" MAN_INST
		if $MAN_INST 
			then
			echo "Succes!"
		else
			echo "Failed! Solve this before continuing installation"
			echo "Try again or press CTRL+C to quit"
			use_Manual 
		fi
		}
		
	if def_PM apt-get
		then 
		use_Apt
	elif def_PM yum
		then
		use_Yum
	elif def_PM pacman 
		then 
		use_Pac
	else
	    echo 'No package manager found!'
	    use_Manual
	fi
	}
	
	
#### CHOOSE INSTALLATION DIRECTORY ####
	set_Dir () {	
	
		cf_Overwrite () {
		echo "1. Choose another directory"
		echo "2. Backup $INSTALLDIR to LaSi/$APP"
		echo "3. Delete $INSTALLDIR"
		echo "Q. Quit"
		read -p "Press 1, 2, 3 or Q to select an option    :" REPLY
		case $REPLY in
     		1)
				choose_Dir
     			;;
     		2)
     			echo "Backup $INSTALLDIR to LaSi/$APP"
     			if [ -d /home/$USER/LaSi ]
     				then
     				mv -f $INSTALLDIR /home/$USER/LaSi/$APP
     			else
     				mkdir /home/$USER/LaSi
     				mv -f $INSTALLDIR /home/$USER/LaSi/$APP
     			fi
     			;;
     		3)
     		    echo "Deleting $INSTALLDIR."
     			rm -R -f $INSTALLDIR
     			;;
     		[Qq]*)
     			echo "Fini..."
     			LaSi_Menu
     			;;
      		*)
				echo "Choose 1, 2, 3 or Q to quit"
				cf_Dir
      			;;
		esac
		}
	
		choose_Dir() { 
		read -p 'Type the path of the directory you want to install in...   :' INSTALLDIR
		if [ -d $INSTALLDIR ]
			then
			echo
			echo "$INSTALLDIR allready exists, please choose an option:"
			cf_Overwrite
		else
			echo "Installing $APP in $INSTALLDIR."
		fi
		}
		
		cf_Dir () { 
		if [ -d $INSTALLDIR ] 
			then 
			echo
			echo "$INSTALLDIR allready exists, please choose an option:"
			cf_Overwrite
		else
			echo "By default $APP will be installed in $INSTALLDIR."
			echo "Do you want to change this?"			
			read -p "(yes/no)   :" REPLY
			case $REPLY in
     			[Yy]*)
     				choose_Dir
     				;;
     			[Nn]*)
     				echo "Installing $APP in $INSTALLDIR"
     				;;
      			*)
					echo "Answer yes or no"
					cf_Dir
      				;;
			esac
		fi
		}
	cf_Dir
	}


#### CHECKOUT SVN ####
	checkout_Svn () {
	echo ' '
	echo '--------'
	echo "Download and install the most recent version of $APP from googlecode"
	echo '--------'
	echo ' '
	command svn checkout $SVN $INSTALLDIR
	mkdir -p $INSTALLDIR/cache
	echo
	}
	
	
### GET BEAUTIFULSOUP ####
	get_BS () { 
	echo '--------'
	echo "Downloading $BSVERSION, $APP needs it"
	echo '--------'
	wget -P /tmp $BS &&
	tar -C /tmp -xzvf /tmp/$BSVERSION.tar.gz &&
	cp -f -b /tmp/$BSVERSION/BeautifulSoup.py $INSTALLDIR/plugins/BeautifulSoup.py
	echo "Download ok"
	}
	
	
#### DOWNLOAD ALL SCRIPTS USED ####
	get_Scripts () {
	echo '--------'
	echo "Downloading subtitlesearch scripts, $APP needs it"
	echo '--------'
	wget -P $INSTALLDIR $DROPBOX/$APP/$SCANPATH
	wget -P $INSTALLDIR $DROPBOX/$APP/$DOWN_SUB
	wget -P $INSTALLDIR $DROPBOX/$APP/$SABPER
	wget -P $INSTALLDIR $DROPBOX/$APP/$SABPERSICK   
	sudo chmod +x $INSTALLDIR/$SABPERSICK
	sudo chmod +x $INSTALLDIR/$SABPER
	sudo chmod +x $INSTALLDIR/$SCANPATH
	}

	
#################################################
#### ADJUSTING ALL SCRIPTS TO USERS SETTINGS ####	

#### SET PYTHON ####
		
	path_Python() {
	PATH_PYTHON=$(which python)	
	sed -i "s#/usr/bin/python#$PATH_PYTHON#g" $INSTALLDIR/$SCANPATH
	sed -i "s#/usr/bin/python#$PATH_PYTHON#g" $INSTALLDIR/$SABPER
	sed -i "s#/usr/bin/python#$PATH_PYTHON#g" $INSTALLDIR/$SABPERSICK
	}

#### SET PERISCOPE PATH IN SCRIPTS ####

	path_Periscope () {
	sed -i "s#PATH_PERISCOPE#$INSTALLDIR#g" $INSTALLDIR/$SABPERSICK
	sed -i "s#PATH_PERISCOPE#$INSTALLDIR#g" $INSTALLDIR/$SCANPATH
	sed -i "s#PATH_PERISCOPE#$INSTALLDIR#g" $INSTALLDIR/$SABPER
	sed -i "s#PATH_PERISCOPE#$INSTALLDIR#g" $INSTALLDIR/$DOWN_SUB
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
		read -p "e.g. en:" LANG1
		if echo "$LANG_SET1 $LANG_SET2" | grep -w $LANG1 >/dev/null
			then
			echo "First language set to $LANG1"
			sed -i "s/111/$LANG1/g" $INSTALLDIR/$DOWN_SUB
		else
			echo "Language not found, try again"
			choose_Lang1
		fi
		}
		
		choose_Lang2 () {
		echo "Choose your second language"
		read -p "e.g. nl:" LANG2
		if echo "$LANG_SET1 $LANG_SET2" | grep -w $LANG2 >/dev/null
			then
			echo "Second language set to $LANG2"
			sed -i "s/222/$LANG2/g" $INSTALLDIR/$DOWN_SUB
		else
			echo "Language not found, try again"
			choose_Lang2
		fi
		}
	show_Language
	}
	

#### SET PATHS AND CRONJOBS FOR BATCH ####	
	set_Path_Cron () { 
	echo '--------'
	echo "Periscope can search for subtitles for all files"
	echo "you have in .avi or .mkv format."
	echo "You can set an unlimited amount of paths"
	echo '--------'
	echo
	echo "Do you want to set a path for Periscope to batchsearch in?"
		
		
		Question_Path() {
		read -p "(yes/no)   :" REPLY
		case $REPLY in
     		[Yy]*)
     			echo
     			read -p "Give a name to this search (e.g. Movies)  :" PREFIX
     			echo "Creating batchfile $PREFIX-$SCANPATH in $INSTALLDIR..."
     			cp $INSTALLDIR/$SCANPATH $INSTALLDIR/$PREFIX-$SCANPATH &&
     			sudo chmod +x $INSTALLDIR/$PREFIX-$SCANPATH &&
     			set_Path
	    		;;
     		[Nn]*)
				
			 	;;
			*)
				echo "Answer yes or no"
				Question_Path
			  	;;
		esac
		}
				
		set_Path () {
		echo
		echo 'Please specify the full path to your folder containing moviefiles'
		echo "e.g. /home/$USER/Videos"
		read -p ":" BATCHPATH
     		if [ -d $BATCHPATH ]
     			then
     			sed -i "s#/PATH/TO/VIDEOS#$BATCHPATH#g" $INSTALLDIR/$PREFIX-$SCANPATH
     			set_Age	
     		else
     			echo "$BATCHPATH doesn't exist, try again"
     			set_Path
			fi
		}
			
		set_Age () {
		echo
		echo 'Please specify how many days back Periscope should search for'
		echo "e.g. 7"
		read -p ' :' AGE
     		if [ $AGE -eq $AGE 2> /dev/null ]
     			then
				sed -i "s/AGE_DAYS/$AGE/g" $INSTALLDIR/$PREFIX-$SCANPATH
				set_Cron	
     		else
     			echo "$AGE is not a numeric value, try again"
     			set_Age		
			fi
		}
		
		
		check_Cron () {
		if crontab -l >/dev/null
			then
			echo "Crontab exists, export it >> cronjobs.txt"
			crontab -l > $INSTALLDIR/cronjobs.txt
		elif	[ ! -e $INSTALLDIR/cronjobs.txt ]
			then
			echo "# m h  dom mon dow   command" >> $INSTALLDIR/cronjobs.txt
		fi
		}
		
		import_Cron () {
		crontab $INSTALLDIR/cronjobs.txt
		echo
		echo "New cronjobs added:"
		echo '--------'
		crontab -l
		echo '--------'
		echo
		}
		
		
		set_Cron () {
		echo '--------'
		echo 'Choose an option to schedule Periscope'
		echo "to search for subtitles for files in $BATCHPATH"
		echo '--------'
		echo '1. @reboot____Once at startup'
		echo '2. @hourly____Once per hour'
		echo '3. @daily_____Once a day'
		echo '4. @midnight__Once a day @ 0:00'
		echo '5. @weekly____Once a week'
		echo 'S. Skip this step.'
		echo 'Q. Quit.'
		read -p 'Option: ' SCHED_PATH
		echo
		case $SCHED_PATH in
    	 	[1]*)
    	 		check_Cron &&
		    	if ! grep -i -q "@reboot .$INSTALLDIR/$PREFIX-$SCANPATH" $INSTALLDIR/cronjobs.txt
    		 		then
    		 		echo "@reboot .$INSTALLDIR/$PREFIX-$SCANPATH" >> $INSTALLDIR/cronjobs.txt
    		 	else 
		     		echo "Cronjob allready exists, skipped"
    		 	fi
    	 	
				import_Cron &&
    		 	echo "Do you want to set another path?"
    		 	Question_Path
    		 	
    	 		;;
    	 	[2]*)
    	 		check_Cron &&
			if ! grep -i -q "@hourly .$INSTALLDIR/$PREFIX-$SCANPATH" $INSTALLDIR/cronjobs.txt
    		 		then
    		 		echo "@hourly .$INSTALLDIR/$PREFIX-$SCANPATH" >> $INSTALLDIR/cronjobs.txt
    		 	else 
		     		echo "Cronjob allready exists, skipped"    		 	
    		 	fi
    	 	
			import_Cron &&
    		 	echo "Do you want to set another path?"
    		 	Question_Path
    	 		;;
    	  	[3]*)
    	  		check_Cron &&
   			if ! grep -i -q "@daily .$INSTALLDIR/$PREFIX-$SCANPATH" $INSTALLDIR/cronjobs.txt
    		 		then
    		 		echo "@daily .$INSTALLDIR/$PREFIX-$SCANPATH" >> $INSTALLDIR/cronjobs.txt
    		 	else 
		     		echo "Cronjob allready exists, skipped"
    		 	fi
    	 	
				import_Cron &&
    		 	echo "Do you want to set another path?"
    		 	Question_Path
    	  		;;
    	  	[4]*)
    	  		check_Cron &&
		  	if ! grep -i -q "@midnight .$INSTALLDIR/$PREFIX-$SCANPATH" $INSTALLDIR/cronjobs.txt
		     		then
			      	echo "@midnight .$INSTALLDIR/$PREFIX-$SCANPATH" >> $INSTALLDIR/cronjobs.txt
			    else 
		     		echo "Cronjob allready exists, skipped"
		     	fi
    		 	
			import_Cron &&
    		 	echo "Do you want to set another path?"
    		 	Question_Path
    	  		;;   	
    	  	[5]*)
    	  		check_Cron &&
		    	if ! grep -i -q "@weekly .$INSTALLDIR/$PREFIX-$SCANPATH" $INSTALLDIR/cronjobs.txt
		     		then
		     		echo "@weekly .$INSTALLDIR/$PREFIX-$SCANPATH" >> $INSTALLDIR/cronjobs.txt
		     	else 
		     		echo "Cronjob allready exists, skipped"
		     	fi
    	 	
			import_Cron &&
    		 	echo "Do you want to set another path?"
    		 	Question_Path
    	  		;;
    	  	[Ss]*)
    	  		echo "Search subs for files in $BATCHPATH not scheduled"
    	  		echo "TIP: Type crontab -e to schedule yourself"
    	  		echo "Do you want to set another path?"
    		 	Question_Path
    	  		;;
      		[Qq]*)
      			LaSi_Menu
      			;;
    	  	*)
    	  		echo "Please choose an option"
    	  		set_Cron
    	  		;;
		esac
		}
	Question_Path
	}
	
	
#### POSTPROCESSING SCRIPTS SABNZBD+ ####
	
	use_Sabnzbd (){
	
		set_Sabpath () {
		echo
		echo 'Please specify the full path to your folder containing postprocessing-scripts'
		echo "e.g. /home/$USER/.sabnzbd/scripts"
		echo "or S to skip"
		read -p ":" SABPATH
		if [ $SABPATH = S -o $SABPATH = s ]
			then
			Question
		elif [ ! -d $SABPATH ]
			then
			echo "$SABPATH doesn't exist, try again"
			set_Sabpath
			fi
		}
		
		set_Sabpost () {
		ln -s -b $INSTALLDIR/$SABPER $SABPATH/$SABPER
	echo
	echo "Created symbolic link to $SABPATH/$SABPER" 
	echo "Make sure you enable this in Sabnzbd+ for your movies and TVshows" 
	}


		set_Sickpath () {
		echo
		echo 'Please specify the full path to your Sickbeard folder'
		echo "e.g. /home/$USER/.sickbeard"
		echo "or S to skip"
		read -p ":" SICKPATH
		if [ -d $SICKPATH ]
			then
			sed -i "s!/PATH_SICKBEARD!$SICKPATH!g" $INSTALLDIR/$SABPERSICK
			ln -s -b $INSTALLDIR/$SABPERSICK $SABPATH/$SABPERSICK
			echo
			echo "Created symbolick link $SABPATH/$SABPERSICK" 
			echo "Make sure you enable this in Sabnzbd+ for your TVshows" 
		elif [ $SICKPATH = S -o $SICKPATH = s ]
			then
			echo "Skipped Sabnzbd+ to Periscope to Sickbeard postprocessing"
			echo "Tip: You can use the script $INSTALLDIR/$SABPERSICK anytime"
			echo "Edit it with the correct paths"
			echo "and symlink it to your Sabnzbd postprocessing folder"
		else
			echo "$SICKPATH doesn't exist, try again"
			set_Sickpath
			fi
		}

		Question() {
		echo
		echo '--------'
		echo "Periscope can be used as postprocessor for Sabnzbd."
		echo "Choose an option"
		echo '--------'
		echo "1. Use $APP to search subs when Sabnzbd finishes a download"
		echo "2. Use Sickbeard after $APP searched for subs to postprocess"
		echo "   the files Sabnzbd+ downloaded"
		echo "3. Both options 1. and 2."
		echo "S. Skip this step"
		read -p ":" REPLY
		case $REPLY in
	    	[1]*)
	    		set_Sabpath &&
	    		set_Sabpost
	    		;;
	    	[2]*)
	    		set_Sabpath &&
				set_Sickpath
			 	;;
			[3]*)
				set_Sabpath &&
				set_Sabpost &&
				set_Sickpath
				;;
			[Ss]*)
				echo "Skipped this step, installation finished"
				LaSi_Menu
				;;
		esac
		}
	Question		
	}


#UPDATE periscope
svn_Update () {
echo
echo "===="
echo "Checking for updates Periscope"
cd $INSTALLDIR && svn update
echo "===="
}

#### RETURN TO MENU ####
	LaSi_Menu () {
		
	echo 
	read -sn 1 -p "Press a key to continue."
	echo
	exit
	}


#### ALL FUNCTIONS ####	
conn_Test		#connection test for url's used in installation
root_Test		#test user is not root but has sudo
show_Menu


