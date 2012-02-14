#!/usr/bin/env bash

# Author: Mar2zz
# Email: lasi.mar2zz@gmail.com
# Blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3
#
# Forked: Kriss1981
# Email : KrissGit@gmail.com
#
# This is the Spotweb installation script, which is part of 
# Lazy Admins Scripted Installers (LaSi) FreeBSD Edition
#
# please report bugs/issues @
# https://github.com/Mar2zz/LaSi/issues
#######################################################################################
#######################################################################################

install_Spotweb () {
	if [ "$WEBSRV" = "lighttpd" ]; then
		DOCUROOT=`sed -ne '/^server.document-root =/p' /usr/local/etc/lighttpd/lighttpd.conf | awk -F '"' '{ print $2 }'`
		SPOTDIR=$DOCUROOT/spotweb
	elif [ "$WEBSRV" = "apache22" ]; then
		DOCUROOT=`sed -ne '/^var.server_root =/p' /usr/local/etc/apache22/httpd.conf | awk -F '"' '{ print $2 }'`
		SPOTDIR=$DOCUROOT/spotweb
	fi

	if [ "$(ls -A $SPOTDIR)" ]; then
		clear
		echo
		echo "Installation folder for SpotWeb is not empty"
		echo "Assuming SpotWeb is already installed"
		echo
		sleep 3
		Info_Spotweb
	fi

	sudo git clone https://github.com/spotweb/spotweb.git $SPOTDIR &&
	sudo chown -R www:www $SPOTDIR &&
	sudo sed -i ".backup" 's/;date.timezone =/date.timezone = "Europe\/Amsterdam"/g' /usr/local/etc/php.ini &&
	sudo $RCPATH/$WEBSRV restart
}

config_SQL () {
	
	cf_SQL () {
		echo
		echo "Do you want to create a new database?"
		echo "Warning: All existing info in an existing spotwebdatabase will be lost!"
		read -p "[yes/no]: " DBREPLY
			case $DBREPLY in
				[YyJj]*)
					input_PW
                    new_database=1
                    ;;
                [Nn]*)
                    new_database=0
                    ;;
                *)
                    echo "Answer yes or no"
                    cf_SQL
                    ;;
            esac
	}

	input_PW () {
		if [ "$SQLPASSWORD" != "" ]; then
			stty_orig=`stty -g`
			echo
			echo "What is your mySQL password?"
			stty -echo
            echo "[mysql] password:"
            read SQLPASSWORD
            stty $stty_orig
            create_DB
		else
			create_DB
		fi
	}

    create_DB () {
            MYSQL=$(which mysql)

            # check password
            if ! $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "SHOW DATABASES;" > /dev/null); then
                echo "Password is wrong, try again"
                input_PW
            fi

            # drop DB if it exists
            if $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "SHOW DATABASES;" | grep 'spotweb' > /dev/null); then
                $MYSQL mysql -u root --password="$SQLPASSWORD" -e "DROP DATABASE spotweb;" > /dev/null
            fi

            # drop USER if it exists
            if $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "select user.user from mysql.user;" | grep 'spotweb' > /dev/null); then
                $MYSQL mysql -u root --password="$SQLPASSWORD" -e "DROP USER 'spotweb'@'localhost';" > /dev/null
            fi

            # create DB
            $MYSQL mysql -u root --password="$SQLPASSWORD" -e "
            CREATE DATABASE spotweb;
            CREATE USER 'spotweb'@'localhost' IDENTIFIED BY 'spotweb';
            GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'spotweb';"

            # check if database and user is created
            if ! $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "SHOW DATABASES;" | grep 'spotweb' > /dev/null); then
                echo
                echo "Creation of database failed, try again"
                error_Msg
            fi

            if ! $($MYSQL mysql -u root --password="$SQLPASSWORD" -e "select user.user from mysql.user;" | grep 'spotweb' > /dev/null); then
                echo
                echo "Creation of user failed, try again"
                error_Msg
            fi

            echo
            echo "Created a database named spotweb for user spotweb with password spotweb"
            echo
	}

	cf_SQL
	# Upgrade spotweb database
	cd $SPOTDIR && /usr/local/bin/php $SPOTDIR/upgrade-db.php

	Summ_Spotweb
	Summ_Spotweb >> /tmp/LaSi/lasi_install.log
	}

	cf_CronRetrieve () {
		echo
		echo "Do you want to set a hourly cronjob for retrieving spots?"
		read -p "[yes/no]: " CRONRETRIEVE
		case $CRONRETRIEVE in
			[YyJj]*)
				# check if another cronjob for this exists and remove it
				[ -e /etc/cron.hourly/spotweb_spots ] && sudo rm -f /etc/cron.hourly/spotweb_spots

				# create lasi file in correct location
				# would like to use sed for this, but can't figure out how...
echo "#!/bin/sh

# Author: Mar2zz
# Email: lasi.mar2zz@gmail.com
# Blogs: mar2zz.tweakblogs.net
# License: GNU GPL v3

# This job is set by the Lazy admin Scripted installer

set -e

[ -x /usr/local/bin/php ] || exit 0
[ -e $SPOTDIR/retrieve.php ] || exit 0

/usr/local/bin/php $SPOTDIR/retrieve.php || exit 1
" > /tmp/LaSi/spotweb_spots

                sudo mv -f /tmp/LaSi/spotweb_spots /etc/cron.hourly/spotweb_spots
                sudo chmod +x /etc/cron.hourly/spotweb_spots

                echo
                echo "Cronjob set."
                echo "See /etc/cron.hourly/spotweb_spots."
                echo
                ;;

            [Nn]*)
                echo "You can set cronjobs yourself if you want to."
                echo "Type crontab -e for personal jobs or sudo crontab -e for root jobs."
                echo
                ;;
            *)
                echo "Answer yes or no."
                cf_CronRetrieve
                ;;
        esac
	}

	cf_Retrieve () {
		echo
		echo "Do you want to retrieve spots now?"
		read -p "[yes/no]: " RETRIEVE
		case $RETRIEVE in
			[YyJj]*)
				if [ $new_database = 1 ]; then
					echo
					echo "You need to set your newsserver and other options first in spotweb."
					echo "Go to http://$HOSTNAME/spotweb/?page=editsettings"
					echo "Login with admin / admin"
					echo "and set it at the Nieuwsserver-tab, after that, continue ..."
					read -sn 1 -p "Press a key to continue"
				fi
					echo "This will take a while!"
					sleep 2
					/usr/local/bin/php $SPOTDIR/retrieve.php
					;;
			[Nn]*)
					;;
				*)
					echo "Answer yes or no"
					cf_Retrieve
					;;
		esac
	}
	
Summ_Spotweb () {
clear
echo
echo "
Done! Installed SpotWeb.

SpotWeb is now located @ http://$HOSTNAME/spotweb
Go there to configure SpotWeb. Login admin:admin

After configuring run $SPOTDIR/retrieve.php to fill the database with spots
"
}

check_php () {
	if ! which php > /dev/null; then
	REQ=php5
	REQPATH=/usr/ports/lang/php5
	intall_REQ
	fi
}

check_phpext () {
	sudo rm -f /tmp/LaSi/php.ext &&
	sudo rm -f /tmp/LaSi/php.dext
	## Check php-extensions needed for Spotweb
	if ! grep ctype /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "CTYPE" >> /tmp/LaSi/php.dext
		fi
	if ! grep curl /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-curl" >> /tmp/LaSi/php.ext
		fi
	if ! grep dom /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "DOM" >> /tmp/LaSi/php.dext
		fi
	if ! grep gd.so /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-gd" >> /tmp/LaSi/php.ext
		fi
	if ! grep gettext /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-gettext" >> /tmp/LaSi/php.ext
		fi
	if ! grep mbstring /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-mbstring" >> /tmp/LaSi/php.ext
		fi
	if ! grep mysql /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-mysql" >> /tmp/LaSi/php.ext
		fi
	if ! grep openssl /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-openssl" >> /tmp/LaSi/php.ext
		fi
	if ! grep xml /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "XML" >> /tmp/LaSi/php.dext
		fi
	if ! grep zip /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-zip" >> /tmp/LaSi/php.ext
		fi
	if ! grep zlib /usr/local/etc/php/extensions.ini > /dev/null; then
		echo "php5-zlib" >> /tmp/LaSi/php.ext
		fi
	## any ?
	if ls /tmp/LaSi/php.ext > /dev/null; then
		PHPEXT=`cat /tmp/LaSi/php.ext`
		REQ=php5-extensions
		REQPATH=/usr/ports/lang/php5-extensions
		install_REQ
		fi
}

install_phpext () {
	if [ "$SETPKG" = "ports" ]; then
		clear
		echo
		echo "You're about to install php-extensions with the"
		echo "Ports Collection. This means you have to configure"
		echo "the make process to add the extensions required by Spotweb"
		echo
		echo "In the following menu add these extensions to the default"
		echo "selection by checking them:"
		echo
		echo "$PHPEXT"
		echo
		echo "After checking(space) the extensions press enter(OK)"
		echo "Then, go drink some coffee, cause this will take a while"
		echo
		read -sn 1 -p "Press a key to continue to the config menu"
		cd /usr/ports/lang/php5-extensions &&
		sudo make config &&
		sudo make BATCH=yes install clean || error_REQ
	else
		PHPEXT1=`sed -n '1p' /tmp/LaSi/php.ext`
		PHPEXT2=`sed -n '2p' /tmp/LaSi/php.ext`
		PHPEXT3=`sed -n '3p' /tmp/LaSi/php.ext`
		PHPEXT4=`sed -n '4p' /tmp/LaSi/php.ext`
		PHPEXT5=`sed -n '5p' /tmp/LaSi/php.ext`
		PHPEXT6=`sed -n '6p' /tmp/LaSi/php.ext`
		PHPEXT7=`sed -n '7p' /tmp/LaSi/php.ext`
		PHPEXT8=`sed -n '8p' /tmp/LaSi/php.ext`
		sudo pkg_add -r php5-extensions $PHPEXT1 $PHPEXT2 $PHPEXT3 $PHPEXT4 $PHPEXT5 $PHPEXT6 $PHPEXT7 $PHPEXT8 || error_REQ
	fi
}

check_WEBSRV () {

	cf_Webserver () {
		clear
		LaSi_Logo
		echo
		echo "There's is NO webserver installed on this system"
		echo "A webserver is needed to run $SETAPP"
		echo
		echo "Which webserver do you like to install?"
		echo
		echo "Options:"
		echo
		echo "1. Lighttpd"
		echo "2. Apache"
		echo
		echo "B. Back to Info"
		echo "Q. Quit"
		read SELECT
		case $SELECT in
			1)
				WEBSRV=lighttpd
				APPLOW=lighttpd
				cf_Installweb
				;;
			2)
				WEBSRV=apache22
				APPLOW=apache22
				cf_Installweb
				;;
			[Bb]*)
				Info_$SETAPP
				;;
			[Qq]*)
				exit
				;;
			*)
				echo "Please choose..."
				cf_Webserver
				;;
		esac
	}

	cf_Installweb () {
		echo
		echo "Are you sure you want to continue and install $APPLOW?"
		read -p "[yes/no]: " REPLY
		echo
		case $REPLY in
			[Yy]*)
				Install_WEBSRV
				;;
			[Nn]*)
				Info_$SETAPP
				;;
			[Qq]*)
				exit
				;;
			*)
				echo "Answer yes to install"
				echo "no for menu"
				echo "or Q to quit"
				cf_Installweb
				;;
		esac
	}

	install_WEBSRV () {
		pkg_Choice
		if [ "$SETPKG" = "ports" ]; then
			cd /usr/ports/www/$WEBSRV &&
			sudo make -DBATCH install clean || error_REQ
		else
			sudo pkg_add -r $WEBSRV || error_REQ
		fi

		if [ "$WEBSRV" = "apache22" ]; then
			check_php
			sed -i ".backup" 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /usr/local/etc/apache22/httpd.conf &&
			echo AddType application/x-httpd-php .php > /usr/local/etc/apache22/Includes/php5.conf &&
			echo AddType application/x-httpd-php-source .phps >> /usr/local/etc/apache22/Includes/php5.conf
		fi
		set_RCD
	}

	if which lighttpd > /dev/null; then
		WEBSRV=lighttpd
	elif which apache > /dev/null; then
		WEBSRV=apache22
	else
		cf_Webserver
	fi
}

check_mysql () {
	set_MYSQLPW () {
		stty_orig=`stty -g`
		clear
		echo
		echo "You need to set a password for the MYSQL root user"
		echo
		stty -echo
		echo "[mysql] password:"
		read SQLPASSWORD
		stty $stty_orig
		mysqladmin -u root password $SQLPASSWORD
	}

	if ! which mysql > /dev/null; then
	APPLOW=mysql
	REQ=mysql55-server
	REQPATH=/usr/ports/databases/mysql55-server
	install_REQ
	set_RCD
	set_MYSQLPW
	fi
}

check_php () {
	if ! which php > /dev/null; then
	REQ=php5
	REQPATH=/usr/ports/lang/php5
	intall_REQ
	fi
}

##### FreeBSD rc.d Script #####
set_RCD () {
	if ! grep ''$APPLOW'_enable="YES"' /etc/rc.conf > /dev/null; then
		sudo echo ''$APPLOW'_enable="YES"' >> /etc/rc.conf
			if [ "$APPLOW" = "mysql" ]; then
				local APPLOW=mysql-server
			fi
		sudo $RCPATH/$APPLOW start || error_Msg
	elif grep '#'$APPLOW'_enable="YES"' /etc/rc.conf > /dev/null; then
		sudo sed -i ".backup" "/$APPLOW/d" /etc/rc.conf
		sudo echo ''$APPLOW'_enable="YES"' >> /etc/rc.conf
			if [ "$APPLOW" = "mysql" ]; then
				local APPLOW=mysql-server
			fi
		sudo $RCPATH/$APPLOW start || error_Msg
	elif [ "$APPLOW" = "mysql" ]; then
		local APPLOW=mysql-server
		sudo $RCPATH/$APPLOW restart || error_Msg
	else
		sudo $RCPATH/$APPLOW restart || error_Msg
	fi
}

#########################
##### Run Installer #####
#########################

### set variables ###
DROPBOX=http://dl.dropbox.com/u/36835219/LaSi/FreeBSD
RCPATH=/usr/local/etc/rc.d
USRDIR=/usr/local
SETAPP=Spotweb
APPLOW=spotweb

### run functions ###
check_WEBSRV
check_php
check_phpext
check_mysql
install_Spotweb
config_SQL
cf_CronRetrieve
