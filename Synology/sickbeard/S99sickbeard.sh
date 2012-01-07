#!/bin/sh
#################################
#
# Original author: J. van Emden (Brickman)
# Latest version: http://dl.dropbox.com/u/5653370/synology.html
#
# Edited by Mar2zz
# Latest version: http://dl.dropbox.com/u/18712538/couchpotato/S99sickbeard.sh
#
# Short-Description: start, stop and restart Sickbeard
#
# Location for this script: /opt/etc/init.d/
#
# Version:
# 2012-01-07 by Jeroenve
# - Browser never started with --nolaunch option
# - Process ID implemented for shutdown
#
# 2011-11-11 by Mar2zz
# - Override config/data location in daemonsettings
# - Some cleanups
# - Removed manual
# - Changed manual update to auto update
# - Checking host-values into function (only run this when needed)
#
# Version:
# 2011-08-21:
# - Implementation of modification by Mar2zz
# - Implementation for web_root (apache redirect)
# - Manual start function added
# - Manual update function added
#
# 2011-07-10:
# - Check implemented for symlink to /opt/bin/python2.6
#
# 2011-07-03:
# - Initial release
#
#################################

############### EDIT ME ##################
# path to app
APP_PATH=/volume1/@appstore/sickbeard

# path where config.ini and database is stored
CFG_PATH=/volume1/@appstore/.sickbeard

# path where the PID file is stored
PID_FILE=${CFG_PATH}/sickbeard.pid

# path to python bin
DAEMON=/opt/bin/python2.6

# startup args
DAEMON_OPTS=" $APP_PATH/SickBeard.py -d --nolaunch --config=$CFG_PATH/config.ini --datadir=$CFG_PATH --pidfile=$PID_FILE"

# app name
DESC=SickBeard

# user
RUN_AS=sickbeard

############### END EDIT ME ##################

# Daemon check
test -x $DAEMON || exit 0

GIT=$(which git)

# check if daemon exists and link it
python_check () {
    if ! [ -f /usr/bin/python ]; then
        ln -s $DAEMON /usr/bin/python
    fi
}

# Check if config/data dir exists
conf_dir_check () {
    if ! [ -d $CFG_PATH ]; then
        mkdir -p $CFG_PATH
    fi
    chown -R ${RUN_AS}:users $CFG_PATH
}

# Retrieve the process ID
get_pid () {
    if [ -f $PID_FILE ]; then
        PID=$(cat $PID_FILE)
    fi
}

start_daemon () {
    echo "* Starting $DESC ..."

    conf_dir_check
    python_check

    su $RUN_AS -s /bin/sh -c "$DAEMON $DAEMON_OPTS &" || echo "Fail!"
    echo "Done!"
}

stop_daemon () {
    # Shutdown
    # Get the proces ID
    get_pid
    
    echo "* Stopping $DESC ..."
    kill $PID

    # Wait until shutdown is initiated.
    counter=20
    while [ $counter -gt 0 ]; do
        daemon_status || break
        let counter=counter-1
        sleep 2
    done
    
    echo "Done!"
}

daemon_status () {
    # Get the proces ID
    get_pid
    if [ $PID ]; then
        PID_res=$(ps | grep -c $PID)
        if [ $PID_res -eq 2 ]; then
            return 0
        fi
    fi
    
    return 1
}

run_update () {
    # Manual update
    echo "* Updating $DESC ..."
    su $RUN_AS -s /bin/sh -c "$GIT --git-dir=$APP_PATH/.git pull" || exit 1
}


# DO WHAT USER ASKS
case "$1" in
    start)
        if daemon_status; then
            echo "* $DESC daemon already running"
            exit 0
        else
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            stop_daemon
            exit $?
        else
            echo "* $DESC is not running"
            exit 0
        fi
        ;;
    restart|force-reload)
        if daemon_status; then
            stop_daemon
            start_daemon
            exit $?
        else
            echo "* $DESC is not running"
            exit 0
        fi
        ;;
    update)
        if ! run_update | grep 'Already up-to-date'; then
            /opt/etc/init.d/S99headphones.sh restart
        fi
        ;;
    status)
        if daemon_status; then
            echo "* $DESC is running"
        else
            echo "* $DESC is not running"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|update|status}" >&2
        exit 1
        ;;
esac

exit 0
