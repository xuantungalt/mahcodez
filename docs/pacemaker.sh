#!/bin/bash

# Authors:
#  Andrew Beekhof <abeekhof@redhat.com>
#  Fabio M. Di Nitto <fdinitto@redhat.com>
#
# License: Revised BSD

# chkconfig: - 99 01
# description: Pacemaker Cluster Manager
# processname: pacemakerd
#
### BEGIN INIT INFO
# Provides:             pacemaker
# Required-Start:       $network corosync
# Should-Start:         $syslog
# Required-Stop:        $network corosync
# Default-Start:  2 3 4 5
# Default-Stop:   0 1 6
# Short-Description:    Starts and stops Pacemaker Cluster Manager.
# Description:          Starts and stops Pacemaker Cluster Manager.
### END INIT INFO

desc="Pacemaker Cluster Manager"
prog="pacemakerd"
pcon="/opt/cluster/etc/cluster.conf"
cman=0

# set secure PATH
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/sbin:$PATH"

checkrc() {
    if [ $? = 0 ]; then
        success
    else
        failure
    fi
}

success()
{
        echo -ne "[  OK  ]\r"
}

failure()
{
        echo -ne "[FAILED]\r"
}

status()
{
    pid=$(pidof $1 2>/dev/null)
    rtrn=$?
    if [ $rtrn -ne 0 ]; then
        echo "$1 is stopped"
    else
        echo "$1 (pid $pid) is running..."
    fi
    return $rtrn
}

# rpm based distros
if [ -d /etc/sysconfig ]; then
    [ -f /etc/init.d/functions ] && . /etc/init.d/functions
    #[ -f /etc/sysconfig/pacemaker ] && . /etc/sysconfig/pacemaker
    [ -z "$LOCK_FILE" ] && LOCK_FILE="/var/lock/subsys/pacemaker"
fi

# deb based distros
if [ -d /etc/default ]; then
    [ -f /etc/default/pacemaker ] && . /etc/default/pacemaker
    [ -z "$LOCK_FILE" ] && LOCK_FILE="/var/lock/pacemaker"
fi

# Unless specified otherwise, assume cman is in use if cluster.conf exists
if [ x = "x$PCMK_STACK" -a -f "$pcon" ]; then
    PCMK_STACK=cman
fi

start()
{
    echo -n "Starting $desc: "

    # most recent distributions use tmpfs for $/var/run
    # to avoid to clean it up on every boot.
    # they also assume that init scripts will create
    # required subdirectories for proper operations
    mkdir -p /var/run

    if status $prog > /dev/null 2>&1; then
        success
    else
        $prog > /dev/null 2>&1 &

        # Time to connect to corosync and fail
        sleep 5

        if status $prog > /dev/null 2>&1; then
            touch $LOCK_FILE
            pidof $prog > /var/run/$prog.pid
            success
        else
            failure
            rtrn=1
        fi
    fi
    echo
}

cman_pre_start()
{
    pid=$(pidof corosync 2>/dev/null)
    if [ $? -ne 0 ]; then
    service cman start
    sleep 2
    fi
}

cman_pre_stop()
{
    pid=$(pidof fenced 2>/dev/null)
    if [ $? -ne 0 ]; then
    : CMAN is not running, nothing to do here
    return
    fi
    cname=`crm_node --name`
    crm_attribute -N $cname -n standby -v true -l reboot
    logger -t pacemaker -p daemon.notice "Waiting for shutdown of managed resources"
    echo -n "Waiting for shutdown of managed resources"

    while [ 1 = 1 ]; do
    # 0x0000000000000002 means managed
    active=`crm_resource -c | grep Resource: | grep 0x...............[2367] | awk '{print $9}' | grep $cname | wc -l`
    if [ $active = 0 ]; then
        break;
    fi
    sleep 1
    echo -n "."
    done
    success
    echo

    logger -t pacemaker -p daemon.notice "Leaving fence domain"
    echo -n "Leaving fence domain"
    fence_tool leave -w 10
    checkrc

    logger -t pacemaker -p daemon.notice "Stopping fenced"
    fenced=$(pidof fenced)
    echo -n "Stopping fenced $fenced"
    kill -KILL $fenced > /dev/null 2>&1
    checkrc
}

stop()
{
    shutdown_prog=$prog
    if ! status $prog > /dev/null 2>&1; then
        shutdown_prog="crmd"
    fi

    if status $shutdown_prog > /dev/null 2>&1; then
        echo -n "Signaling $desc to terminate: "
        kill -TERM $(pidof $prog) > /dev/null 2>&1
        success
        echo

        echo -n "Waiting for cluster services to unload:"
        while status $prog > /dev/null 2>&1; do
        sleep 1
        echo -n "."
        done
    else
        echo -n "$desc is already stopped"
    fi

    rm -f $LOCK_FILE
    rm -f /var/run/$prog.pid
    killall -q -9 'crmd stonithd attrd cib lrmd pacemakerd'
    success
    echo
}

rtrn=0

case "$1" in
start)
    # For consistency with stop
    [ "$PCMK_STACK" = cman ] && cman_pre_start
    start
;;
restart|reload|force-reload)
    stop
    start
;;
condrestart|try-restart)
    if status $prog > /dev/null 2>&1; then
        stop
        start
    fi
;;
status)
    status $prog
    rtrn=$?
;;
stop)
    #
    # stonithd needs to be around until fenced is stopped
    # fenced can't be stopped until any cluster filesystems are unmounted
    #
    # So:
    # 1. put the node into standby
    # 2. wait for all resources to be stopped
    # 3. stop fenced and anything that needs it (borrowed from the cman script)
    # 4. stop pacemaker
    # 5. stop the rest of cman (so it doesn't end up half up/down)
    #
    [ "$PCMK_STACK" = cman ] && cman_pre_stop
    stop
    [ "$PCMK_STACK" = cman ] && service cman stop
;;
*)
    echo "usage: $0 {start|stop|restart|reload|force-reload|condrestart|try-restart|status}"
    rtrn=2
;;
esac

exit $rtrn