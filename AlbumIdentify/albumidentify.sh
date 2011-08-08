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
# | execute this script with the command sudo chmod +x albumidentify.sh
# | and run with ./albumidentify.sh
# |
# | answer all questions the terminal asks,
# | and albumidentify will be running in no time!
# |___________________________________________________________________________________
#
# Tested succesful on OS's:
# Ubuntu 10.4 Desktop, Ubuntu 10.4 Minimal server, XBMC Live Dharma
#
#######################################################################################
#######################################################################################

VERSION=v0.1 ####

TESTOS1=Ubuntu_10.4_Desktop
TESTOS2=Ubuntu_10.4_Server
TESTOS3=XBMC_Live_Dharma

#######################################################################################
#################### LIST OF VARIABLES USED ###########################################


#SET SOME VARIABLES (SOME VARIABLES WILL BE SET THROUGH LIVE USERINPUT IN TERMINAL)

APP=AlbumIdentify; 		# name of app to install (also for Dropboxfolders)
APPLOW=albumidentify;	# lowercase appname

CONN1=github.com; 	# to test connections needed to install apps
CONN2=dropbox.com;

GITHUB=https://github.com/albumidentify/albumidentify.git; 	#github-adres
DROPBOX=http://dl.dropbox.com/u/18712538/ 				#dropbox-adres


PACK1=git-core; 	#needed packages to run (using apt to check and install)
PACK1_EXE=git;		#EXE optional needed when packagename differs from executable
PACK2=python;
PACK3="python-musicbrainz2 python-imaging";
PACK4="libsndfile1 sndfile-programs libofa0";
PACK5=mpg123
PACK6=mp3gain
PACK7=flac
PACK9=vorbisgain
PACK8=vorbis-tools

INSTALLDIR=/home/$USER/.$APPLOW; #directory you want to install to.
CONFIGFILE=.albumidentifyrc;	#name of default init-script
SCANALBUM=scanAlbum.sh;			#name of auto batchscanner
SABTOALBUM=SabtoAlbum.sh;		#name of sabnzbd postprocessingscript
MANALBUM=manualAlbum.sh;		#name of manual batchscanner




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
echo '---------------------------------'
echo 'ALBUMIDENTIFY IS CREATED BY ALBUMIDENTIFY-TEAM'
echo '------ https://github.com/scottr/albumidentify'
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

		git_test () {
		if ! ping -c 1 $CONN1 > /dev/null 2>&1
			then
			echo "Hmmm $CONN1 seems down..." &&
			echo "Need $CONN1 to install... Now exiting" &&
			LaSi_Menu
		fi
		}

		dropbox_test () {
		if ! ping -c 1 $CONN2 > /dev/null 2>&1
			then
			echo "Hmmm $CONN2 seems down..."
			echo "Need $CONN2 to install... Now exiting"
			LaSi_Menu
		fi
		}
	git_test
	dropbox_test
	}


#### CONFIRM_CONTINUE ####
	cf_Continue () {
	echo '--------'
	echo 'You can take the blue pill if you want to, just answer no on the next question or press CTRL+C'
	echo '--------'
	echo ' '

		Question() {
		echo "Are you sure you want to continue and install $APP?"
		read -p "(yes/no)   :" REPLY
		case $REPLY in
     		[Yy]*)
     			echo "Into the rabbit hole..."
	    		;;
     		[Nn]*)
				LaSi_Menu
			 	;;
			*)
				echo "Answer yes or no"
				Question
			  	;;
		esac
		}
	Question
	}


#######################################################################################
#### CHECK AND INSTALL PACKAGES #######################################################

#### CHECK SOFTWARE ####
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
		if ! which $PACK2
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
		if ! which $PACK3
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

		check_Pack4 () {
		if ! which $PACK4
			then
			echo
			echo "Cannot find if $PACK4 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK4
			use_PM
		else
			echo "$PACK4 installed"
		fi
		}

		check_Pack5 () {
		if ! which $PACK5
			then
			echo
			echo "Cannot find if $PACK5 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK5
			use_PM
		else
			echo "$PACK5 installed"
		fi
		}

		check_Pack6 () {
		if ! which $PACK6
			then
			echo
			echo "Cannot find if $PACK6 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK6
			use_PM
		else
			echo "$PACK6 installed"
		fi
		}

		check_Pack7 () {
		if ! which $PACK7
			then
			echo
			echo "Cannot find if $PACK7 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK7
			use_PM
		else
			echo "$PACK7 installed"
		fi
		}
		check_Pack8 () {
		if ! which $PACK8
			then
			echo
			echo "Cannot find if $PACK8 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK8
			use_PM
		else
			echo "$PACK8 installed"
		fi
		}

		check_Pack9 () {
		if ! which $PACK9
			then
			echo
			echo "Cannot find if $PACK9 is installed"
			echo "Trying to install..."
			echo
			INST_PACK=$PACK9
			use_PM
		else
			echo "$PACK9 installed"
		fi
		}

	check_Pack1
	check_Pack2
	check_Pack3
	check_Pack4
	check_Pack5
	check_Pack6
	check_Pack7
	check_Pack8
	check_Pack9
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
     			echo "Backup $INSTALLDIR to /home/$USER/LaSi/$APP"
     			if [ -d LaSi ]
     				then
     				mv -f $INSTALLDIR /home/$USER/LaSi/$APP
     			else
     				mkdir LaSi
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


#### CLONING INTO GIT ####
	clone_Git () {
	echo
	echo '-------'
	echo "Download and install the most recent version of $APP from GitHub"
	echo '-------'
	echo
	command git clone $GITHUB $INSTALLDIR
	echo
	}


#### CREATE OR IMPORT CONFIGFILE ####
	new_Config(){

		import_Config() { # import config.ini
		echo
		echo 'Type the full path and filename of the configurationfile you want to import'
		echo 'or s to skip:'
		read -p ' :' IMPORTCONFIG
     		if [ $IMPORTCONFIG = S -o $IMPORTCONFIG = s ]
     			then
     			cf_Import
     		elif [ -e $IMPORTCONFIG ]
				then
				cp -f -b $IMPORTCONFIG /home/$USER/$CONFIGFILE
				echo "File imported to /home/$USER/$CONFIGFILE"
			else
				echo 'File does not exist, enter correct path as /path/to/file.ext' &&
				import_Config
			fi
		}

		cf_Import () { # Confirm import
		echo "Do you want to import your own configurationfile?"
		read -p "(yes/no)   :" REPLY
		case $REPLY in
     		[Yy]*)
     			import_Config
     			;;
     		[Nn]*)
     			echo "Using the default one"
				cp -f -b $INSTALLDIR/albumidentifyrc.dist /home/$USER/$CONFIGFILE
				echo "Config created in /home/$USER/$CONFIGFILE"
      		;;
      		*)
			echo "Answer yes or no"
				cf_Import
      		;;
			esac
		}
	cf_Import
	}

#################################################
#### CHANGE THE CONFIGFILE TO PERSONAL NEEDS ####

#### DIR RENAMED FILES GO TO ####

	set_Musicdir () {
	echo "Enter the location where renamed files should go"
	echo "e.g. /home/$USER/Music"
	read -p ':' PATH_MUSIC

		cf_Musicdir () {
		echo "You entered $PATH_MUSIC, is this correct?  :"
		read -p "(yes/no)   :" REPLY
		case $REPLY in
   			[Yy]*)
   				echo "Ok, adding $PATH_MUSIC to config.ini..."
   			    sed -i "
   			    	s!#dest_path=!dest_path=$PATH_MUSIC!g
					" /home/$USER/$CONFIGFILE
				;;
   			[Nn]*)
   				set_Musicdir
   				;;
   			*)
				echo "Answer yes or no"
				cf_Musicdir
   				;;
		esac
		}
	cf_Musicdir
	}


#### SET NAMINGSCHEME ####

	show_Scheme () {
	echo '-------'
	echo "You can choose a preferred namingscheme"
	echo "Default is:"
	echo "%(sortalbumartist)s - %(year)i - %(album)s/%(tracknumber)02i - %(trackartist)s - %(trackname)s"
	echo "That renames like this:"
	echo "Lavigne, Avril - 2007 - The Best Damn Thing/01 - Avril Lavigne - Girlfriend"
	echo '-------'

		set_Scheme () {
		echo
		echo '-------'
		echo "Here are the options. / makes a subdirectory...;"
		echo "use as: %(string)s"
		echo "trackname, trackartist, album, albumartist, sortalbumartist, sorttrackartist"
		echo "use as: %(integer)i"
		echo "tracknumber, year"
		echo '-------'
		echo "Now create your own or S to skip"
		echo
		read -p ":" NEWSCHEME
		case $REPLY in
   			[Ss]*)
   				echo "Skipping..."
				show_Scheme
				;;
   			*)
   				sed -i "
   					14s!#!!g
   					14s!=.*!=$NEWSCHEME!g
   					" /home/$USER/$CONFIGFILE &&
   				echo
   				echo "Naming scheme set to:"
   				echo "$NEWSCHEME"
   				;;
		esac
		}

		cf_Scheme () {
		echo "Do you want to change the default namingscheme?"
		read -p "(yes/no)   :" REPLY
		case $REPLY in
   			[Yy]*)
				set_Scheme
				;;
   			[Nn]*)
   				echo "Ok, keeping defaults..."
				;;
   			*)
				echo "Answer yes or no"
				cf_Scheme
   				;;
		esac
		}
	cf_Scheme
	}


#### SOUNDTRACKS BEHAVIOUR ####
	cf_Soundtrack () {
	echo
	echo "Files with genre Soundtrack are renamed by default to their own subdir in $PATH_MUSIC/Soundtrack"
	echo "Do you want to change this?"
	read -p "(yes/no)   :" REPLY
	case $REPLY in
   		[Yy]*)
   			echo "Ok, treating soundtracks like normal musicfiles..."
   	 		sed -i "
   		    	s/#leave_soundtrack_artist=False/leave_soundtrack_artist=True/g
				" /home/$USER/$CONFIGFILE
			;;
   		[Nn]*)
   			echo "Keeping the defaults"
			;;
   		*)
			echo "Answer yes or no"
			cf_Soundtrack
			;;
	esac
	}


#### TRACKS IN ORDER ####
	cf_Order () {
	echo
	echo "Renamealbum can be forced to only handle files that are in correct order"
	echo "By default tracks can be found in alternate orders but may produce false positives"
	echo "Do you want to change this?"
	read -p "(yes/no)   :" REPLY
	case $REPLY in
		[Yy]*)
	 		echo "Changed to strict handling.."
   		 	sed -i "
   			   	s/#force_order=True/force_order=True/g
				" /home/$USER/$CONFIGFILE
			;;
		[Nn]*)
			echo "Keeping the defaults"
			;;
		*)
			echo "Answer yes or no"
			cf_Order
			;;
	esac
	}


#### OVERWRITE LOWER QUALITY FILES ####
	cf_Dest () {
	echo
	echo "Renamealbum can be forced to replace existing files if the newer files are better quality"
	echo "and so prevent doubleups of flac's and mp3's in one folder"
	echo "Do you want to enable this?"
	read -p "(yes/no)   :" REPLY
	case $REPLY in
		[Yy]*)
	 		echo "Ok, enabling feature..."
   		 	sed -i "
   			   	s/#no_dest=False/no_dest=True/g
				" /home/$USER/$CONFIGFILE
			;;
	   	[Nn]*)
			echo "Keeping the defaults"
			;;
		*)
			echo "Answer yes or no"
			cf_Dest
			;;
	esac
	}


#### EDIT REST OF CONFIG MANUAL ####
	cf_Edit () {
	echo
	echo "The configfile has some more options for MusicBrainz features"
	echo "You can edit the configfile manually, this installer skips it"
	echo "because it's not mandatory."
	echo "Do you want to view them or edit?"
	read -p "(yes/no)   :" REPLY
	case $REPLY in
		[Yy]*)
	   		command editor /home/$USER/$CONFIGFILE
			;;
		[Nn]*)
			echo "Skipping this step"
			;;
		*)
			echo "Answer yes or no"
			cf_Edit
			;;
	esac
	}


#### DOWNLOAD ALL SCRIPTS USED ####
	get_Scripts () {
	echo '--------'
	echo "Downloading subtitlesearch scripts, $APP needs it"
	echo '--------'
	wget -P $INSTALLDIR $DROPBOX/$APP/$SABTOALBUM
	wget -P $INSTALLDIR $DROPBOX/$APP/$SCANALBUM
	wget -P $INSTALLDIR $DROPBOX/$APP/$MANALBUM
	sudo chmod +x $INSTALLDIR/$SABTOALBUM
	sudo chmod +x $INSTALLDIR/$SCANALBUM
	sudo chmod +x $INSTALLDIR/$MANALBUM	
	}


######################################################
#### ADJUSTING ALL LaSi SCRIPTS TO USERS SETTINGS ####


#### SET PYTHON PATH IN SCRIPTS ####

	path_Python() {
	PATH_PYTHON=$(which python)
   	sed -i "s#/usr/bin/python#$PATH_PYTHON#g" $INSTALLDIR/$SABTOALBUM
   	sed -i "s#/usr/bin/python#$PATH_PYTHON#g" $INSTALLDIR/$SCANALBUM
   	sed -i "s#/usr/bin/python#$PATH_PYTHON#g" $INSTALLDIR/$MANALBUM
	}


#### SET RENAMEALBUM PATH IN SCRIPTS ####

	path_Renalbum () {
   	sed -i "s!/path/to/renamealbum!$INSTALLDIR/renamealbum!g" $INSTALLDIR/$SABTOALBUM
   	sed -i "s!/path/to/renamealbum!$INSTALLDIR/renamealbum!g" $INSTALLDIR/$SCANALBUM
   	sed -i "s!/path/to/renamealbum!$INSTALLDIR/renamealbum!g" $INSTALLDIR/$MANALBUM
	}


#### EMBED COVERART IN FILES ####
	cf_Coverart () {
	echo "By default Renamealbum will embed coverart in your files"
	echo "Do you want to embed coverart? (if no it will only create a folder.jpg along your musicfiles)"
	read -p "(yes/no)   :" REPLY
	case $REPLY in
		[Yy]*)
   		 	sed -i "s/ --no-embed-coverart//g" $INSTALLDIR/$SABTOALBUM
   		 	sed -i "s/ --no-embed-coverart//g" $INSTALLDIR/$SCANALBUM
   		 	sed -i "s/ --no-embed-coverart//g" $INSTALLDIR/$MANALBUM
			;;
		[Nn]*)
			;;
		*)
			echo "Answer yes or no"
			cf_Coverart
			;;
	esac
	}

#### ASK FOR FAILED DIR ####
	show_Failed () {
	echo
	echo "$APP can't always identify your new albums."
	echo "In case that happens you can move those albums to a specified directory"
	echo "e.g. /home/$USER/Music/untagged/Album"

		dir_Failed () {
		echo
		echo "Type the path of the directory"
		echo "you want unidentified files to go to"
		read -p ':' DIRFAILED
		if [ -d $DIRFAILED ]
			then
			echo "Set $DIRFAILED as default"
   			sed -i "s#/path/to/UNTAGGED#$DIRFAILED#g" $INSTALLDIR/$SABTOALBUM
   			sed -i "s#/path/to/UNTAGGED#$DIRFAILED#g" $INSTALLDIR/$SCANALBUM
   			sed -i "s#/path/to/UNTAGGED#$DIRFAILED#g" $INSTALLDIR/$MANALBUM
		elif mkdir $DIRFAILED
			then
			echo "Set $DIRFAILED as default"
			sed -i "s#/path/to/UNTAGGED#$DIRFAILED#g" $INSTALLDIR/$SABTOALBUM
   			sed -i "s#/path/to/UNTAGGED#$DIRFAILED#g" $INSTALLDIR/$SCANALBUM
   			sed -i "s#/path/to/UNTAGGED#$DIRFAILED#g" $INSTALLDIR/$MANALBUM
		else
				echo "Unable to use or make $DIRFAILED"
			echo "Please type a valid path"
			dir_Failed
		fi
		}

		cf_Failed () {
		echo
		echo "Do you want to move unidentified files?"
		read -p "(yes/no)   :" REPLY
		case $REPLY in
			[Yy]*)
		   		dir_Failed
				;;
			[Nn]*)
				echo "Files stay where they are, untouched"
				sed -i "s/move_Failed #/#move_Failed #/g" $INSTALLDIR/$SABTOALBUM
   				sed -i "s/move_Failed #/#move_Failed #/g" $INSTALLDIR/$SCANALBUM
   				sed -i "s/move_Failed #/#move_Failed #/g" $INSTALLDIR/$MANALBUM
				;;
			*)
				echo "Answer yes or no"
				cf_Failed
				;;
		esac
		}
	cf_Failed
	}


#### ASK FOR SUCCES DIR ####
	show_Succes () {
	echo
	echo "When albums are identified they will be renamed and copied into your library"
	echo "The sourcefiles stay where they are, untouched"
	echo "You can keep it that way or move or delete them"
	echo "So take your pick..."

		dir_Succes () {
		echo
		echo "Type the path of the directory you want the leftover sourcefiles to go to"
		echo "note: Identified files are copied to your musiccollection automatic"
		echo "this is about the leftover sourcefiles..."
		echo "Enter path to directory for leftovers (e.g. ~/processedmusic)"
		read -p ':' DIRSUCCES
		if [ -d $DIRSUCCES ]
			then
			echo "Set $DIRSUCCES as default"
   			sed -i "s#/path/to/TAGGED#$DIRSUCCES#g" $INSTALLDIR/$SABTOALBUM
   			sed -i "s#/path/to/TAGGED#$DIRSUCCES#g" $INSTALLDIR/$SCANALBUM
   			sed -i "s#/path/to/TAGGED#$DIRSUCCES#g" $INSTALLDIR/$MANALBUM
		elif mkdir $DIRSUCCES
			then
			echo "Set $DIRSUCCES as default"
			sed -i "s#/path/to/TAGGED#$DIRSUCCES#g" $INSTALLDIR/$SABTOALBUM
   			sed -i "s#/path/to/TAGGED#$DIRSUCCES#g" $INSTALLDIR/$SCANALBUM
   			sed -i "s#/path/to/TAGGED#$DIRSUCCES#g" $INSTALLDIR/$MANALBUM
		else
			echo "Unable to use or make $DIRSUCCES"
			echo "Please type a valid path"
			dir_Succes
		fi
		}

		cf_Succes () {
		echo "1. Do nothing"
		echo "2. Move the sourcefiles to another directory (e.g. ~/Downloads/Tagged)"
		echo "3. Delete the sourcefiles (e.g. Gone like... forever)"
		read -p "Choose an option" REPLY
		case $REPLY in
			[1]*)
				echo "Files stay where they are, untouched"
				sed -i "s/move_Succes #/#move_Succes #/g" $INSTALLDIR/$SABTOALBUM
   				sed -i "s/move_Succes #/#move_Succes #/g" $INSTALLDIR/$SCANALBUM
   				sed -i "s/move_Succes #/#move_Succes #/g" $INSTALLDIR/$MANALBUM
   				;;
   			[2]*)
   				dir_Succes
   				;;
   			[3]*)
   				echo "The risky way eey... Be carefull not to use these scripts"
   				echo "on your complete musiccollection..."
				sed -i "
					s/move_Succes #/#move_Succes #/g
					s/#delete_Succes #/delete_Succes #/g
					" $INSTALLDIR/$SABTOALBUM
   				sed -i "
   					s/move_Succes #/#move_Succes #/g
   					s/#delete_Succes #/delete_Succes #/g
   					" $INSTALLDIR/$SCANALBUM
   				sed -i "
   					s/move_Succes #/#move_Succes #/g
   					s/#delete_Succes #/delete_Succes #/g
   					" $INSTALLDIR/$MANALBUM
   					;;
   			*)
   					echo "Please choose an option"
   					cf_Succes
   					;;
   		esac
		}
	cf_Succes
	}


#### SABNZBD POSTPROCESSING ####
	use_Sabnzbd () {

		set_Sabpost () {
		ln -s -b $INSTALLDIR/$SABTOALBUM $SABPATH/$SABTOALBUM
    	echo
    	echo "Created symbolic link to $SABPATH/$SABTOALBUM"
    	echo "Make sure you enable this script in Sabnzbd for your musicdownloads"
    	}

		set_Sabpath () {
		echo
		echo 'Please specify the full path to your folder containing postprocessing-scripts'
		echo "e.g. /home/$USER/.sabnzbd/scripts"
		echo "or S to skip"
		read -p ":" SABPATH
    		if [ $SABPATH = S -o $SABPATH = s ]
    			then
    			cf_Sabnzbd
    		elif [ ! -d $SABPATH ]
    			then
    			echo "$SABPATH doesn't exist, try again"
    			set_Sabpath
    		else
    			set_Sabpost
			fi
		}

		cf_Sabnzbd () {
		echo
		echo "AlbumIdentify can be used as postprocessing script for Sabnzbd"
		echo "Do you want to enable this?"
		read -p "(yes/no)   :" REPLY
		case $REPLY in
			[Yy]*)
		   		set_Sabpath
				;;
			[Nn]*)

				;;
			*)
				echo "Answer yes or no"
				cf_Sabnzbd
				;;
		esac
		}
	cf_Sabnzbd
	}


#### RETURN TO MENU ####
	LaSi_Menu () {

	echo
	read -sn 1 -p "Press a key to continue."
	exit
	}



#### ALL FUNCTIONS ####

LaSi_Logo 		#some basic info about installer
show_Author		#creator of the app installed
conn_Test		#connection test for url's used in installation
cf_Continue		#let user confirm to continue
root_Test		#test user is not root but has sudo
check_Packs		#check dependencys
set_Dir			#choose installation directory
clone_Git		#clone the git repo into $installdir
new_Config		#import or create configfile
set_Musicdir	#set path to musiclibrary (where succesful identified files go to)
show_Scheme		#keep or change namingscheme
cf_Soundtrack	#put soundtracks in their own folder
cf_Order		#make identifying more strict
cf_Dest			#no doubleups of flacs and mp3's (replace if better quality)
cf_Edit			#edit the rest of configfile (musicbrainz related)
get_Scripts		#Download all scripts used
path_Python		#Write python path in scripts
path_Renalbum	#write albumidentify paths in script
cf_Coverart		#embed coverart or not?
show_Failed		#set action on failed items
show_Succes		#set action on succes items
use_Sabnzbd		#use AlbumIdentify as postprocessing.
LaSi_Menu		#Return to main script


