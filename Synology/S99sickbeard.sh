#!/bin/sh
#################################
#
# Original author: J. van Emden (Brickman)
# Latest version: http://dl.dropbox.com/u/5653370/synology.html
#
# Edited by Mar2zz
# Latest version: http://dl.dropbox.com/u/18712538/Synology/Scriptname.sh
#
# Short-Description: start, stop and restart Sickbeard
#
# Location for this script: /opt/etc/init.d/
#
#################################

############### EDIT ME ##################
# path to app
APP_PATH=/volume1/@appstore/sickbeard

# path to python bin
DAEMON=/opt/bin/python2.6

# startup args
DAEMON_OPTS="SickBeard.py -d"

# app name
DESC=SickBeard

# user
RUN_AS=sickbeard


############### END EDIT ME ##################


# GET VARIABLES FROM CONFIG.INI
PORT=$(grep web_port $APP_PATH/config.ini | sed 's/web_port = //g');
USERNAME=$(grep web_username $APP_PATH/config.ini | sed 's/web_username = //g');
PASSWORD=$(grep  web_password $APP_PATH/config.ini | sed 's/web_password = //g');

if [ -n $USERNAME ]
	then
	AUTH="--user=$USERNAME --password=$PASSWORD"
fi


# CREATE DAEMONFUNCTIONS

start_daemon () {
# Start
echo "Starting $DESC ..."

# Check for python, which is required by the postprocessor
	python_check (){
	if [ ! -f /usr/bin/python ]
	then
		ln -s $DAEMON /usr/bin/python
	fi
	}
python_check

su $RUN_AS -s /bin/sh -c "$DAEMON $APP_PATH/$DAEMON_OPTS &"
}


stop_daemon () {
# Shutdown
echo "Stopping $DESC ..."
wget -q --spider $AUTH http://localhost:$PORT/home/shutdown/ > /dev/null

# Wait until shutdown is initiated.
counter=20
while [ $counter -gt 0 ] 
do
	daemon_status || break
	let counter=counter-1
	sleep 1
done

# Let it die
sleep 10 
}

daemon_status () {
# Check if it is still listening @ port
wget -q --spider $AUTH http://localhost:$PORT/ > /dev/null
}


# DO WHAT USER ASKS
case "$1" in
	start)
		if daemon_status
			then
			echo "$DESC daemon already running"
			exit 0
		else
			start_daemon
			exit $?
		fi
		;;
	stop)
		if daemon_status
			then
			stop_daemon
			exit $?
		else
			echo "$DESC is not running"
			exit 0
		fi
		;;
	restart)
		if daemon_status
			then
			stop_daemon
			
			start_daemon
			exit $?
		else
			echo "$DESC is not running"
			exit 0
		fi
		;;
	status)
		if daemon_status
			then
			echo "$DESC is running"
			exit 0
		else
			echo "$DESC is not running"
			exit 1
		fi
		;;
	*)
		echo "Usage: $0 {start|stop|restart|status}"
		exit 1
		;;
esac

exit 0
