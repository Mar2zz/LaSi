#!/bin/sh
#################################
#
# Author: Mar2zz
# Latest version: http://dl.dropbox.com/u/18712538/maraschino/S99maraschino.sh
# 
# Short-Description: start, stop and restart maraschino
#
# Location for this script: /opt/etc/init.d/
#
# Version:
# 2012-01-04:
# - Initial release
#
#################################

############### EDIT ME ##################
# path to app
APP_PATH=/volume1/@appstore/maraschino

# path to db
DB_PATH=/volume1/@appstore/.maraschino

# path to python bin
DAEMON=/opt/bin/python2.6

# startup args
DAEMON_OPTS=" $APP_PATH/cherrypy-maraschino.py"

# app name
DESC=Maraschino

# user
RUN_AS=maraschino


############### END EDIT ME ##################

GIT=$(which git)

host_check () {
PORT=$(grep -m1 CHERRYPY_PORT $APP_PATH/settings.py | sed 's/CHERRYPY_PORT = //g');
URL="http://localhost:${PORT}"
# Define exit URL
EXIT=$URL/shutdown
}

# check if daemon exists and link it
python_check () {
    if [ -f /usr/bin/python ]; then
        ln -s $DAEMON /usr/bin/python
    fi
}

# Check if settings.py and dbdir exists
dir_check () {
    # check or create settings.py
    [ -e "$APP_PATH/settings.py" ] || cp -f $APP_PATH/settings_example.py $APP_PATH/settings.py
    # set db path if it isn't set
    grep "$DB_PATH" $APP_PATH/settings.py > /dev/null || sed -i "s!DATABASE =.*!DATABASE = '$DB_PATH/maraschino.db'!g" $APP_PATH/settings.py
    # create dbpath if it doesn't exist
    [ -d "$DB_PATH" ] || mkdir -p "$DB_PATH"
    # set to user running
    chown -R ${RUN_AS}:users $APP_PATH
    chown -R ${RUN_AS}:users $DB_PATH
}

start_daemon () {
    echo "* Starting $DESC ..."

    dir_check
    python_check

    su $RUN_AS -s /bin/sh -c "$DAEMON $DAEMON_OPTS &" || echo "Fail!"
    echo "Done!"
}

stop_daemon () {
    echo "* Stopping $DESC ..."

    host_check
    wget -q --spider $AUTH $EXIT > /dev/null || echo "Fail!"

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
    echo "Done!"
}

daemon_status () {
    # Check if it is still listening @ port (and bypass this check first start)
    wget -q --spider $URL > /dev/null
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
    restart)
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
            /opt/etc/init.d/S99maraschino.sh restart
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
        echo "Usage: $0 {start|stop|restart|update|status}"
        exit 1
        ;;
esac

exit 0
