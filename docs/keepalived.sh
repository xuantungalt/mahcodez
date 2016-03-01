#!/bin/sh
#
# Startup script for the Keepalived daemon
#
# processname: keepalived
# pidfile: /var/run/keepalived.pid
# config: /etc/keepalived/keepalived.conf
# chkconfig: 35 21 79
# description: Start and stop Keepalived

# Global definitions
RUN_FILE="/opt/keepalived/bin/keepalived"
CNF_FILE="/opt/keepalived/etc/keepalived.conf"
PID_FILE="/var/run/keepalived.pid"
KEEPALIVED_OPTIONS="-D"

# source function library
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

RETVAL=0

print_retval() {
	if [ $1 -ne 0 ]
	then
		echo '['$(tput bold)$(tput setaf 1)'FAIL'$(tput sgr0)']'
	else
		echo '['$(tput bold)$(tput setaf 2)'OK'$(tput sgr0)']'
	fi
}

status() {
	PRC_NAME=${echo $RUN_FILE | awk -F '/' '{print $NF}'}
	PID_NUMS=($(pidof $PRC_NAME))
	if [ ${#PID_NUMS[@]} -gt 0 ]
	then
		return ${PID_NUMS[@]}
	else
		return 0
	fi
}

start() {
		echo -n "Starting Keepalived for LVS: "
		RUN_STAT=$(status)
		if [ -f $PID_FILE ] && [ $RUN_STAT -ne 0 ]
		then
			echo '['$(tput bold)$(tput setaf 1)'FAIL'$(tput sgr0)"] Keepalived \"$(cat $PID_FILE)\" is already on."
			RETVAL=0
		else		
			$RUN_FILE $KEEPALIVED_OPTIONS --use-file $CNF_FILE --pid $PID_FILE
			RETVAL=$?
			print_retval $RETVAL
		fi
        return $RETVAL
}

stop() {
        echo -n "Shutting down Keepalived for LVS: "
		RUN_STAT=$(status)
		if [ ! -f $PID_FILE ] && [ $RUN_STAT -eq 0 ]
		then
			echo '['$(tput bold)$(tput setaf 1)'FAIL'$(tput sgr0)'] Keepalived not running ATM.'
		else
			kill -9 $(cat $PID_FILE)
			print_retval $?
		fi
        return 0
}

reload() {
        echo -n "Reloading Keepalived config: "
        pkill keepalived -1
        RETVAL=$?
        print_retval $RETVAL
        return $RETVAL
}

# See how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        start
        ;;
  reload)
        reload
        ;;
  status)
        status keepalived
        ;;
  condrestart)
        [ -f $PID_FILE ] && $0 restart || :
        ;;
  *)
        echo "Usage: $0 {start|stop|restart|reload|condrestart|status}"
        exit 1
esac

exit 0