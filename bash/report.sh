#!/bin/bash
# Shell script to get uptime, disk usage, cpu usage, RAM usage,system load,etc.
# from multiple Linux servers and output the information on a single server
# in html format. Read below for usage/installation info
# *---------------------------------------------------------------------------*
# * dig_remote_linux_server_information.bash,v0.1, last updated on 25-Jul-2005*
# * Copyright (c) 2005 nixCraft project *
# * Comment/bugs: http://cyberciti.biz/fb/ *
# * Ref url: http://cyberciti.biz/nixcraft/forum/viewtopic.php?t=97 *
# * This script is licensed under GNU GPL version 2.0 or above *
# *---------------------------------------------------------------------------*
# * Installation Info *
# ----------------------------------------------------------------------------*
# You need to setup ssh-keys to avoid password prompt, see url how-to setup
# ssh-keys:
# cyberciti.biz/nixcraft/vivek/blogger/2004/05/ssh-public-key-based-authentication.html
#
# [1] You need to setup correct VARIABLES script:
#
# (a) Change Q_HOST to query your host to get information
# Q_HOST="192.168.1.2 127.0.0.1 192.168.1.2"
#
# (b) Setup USR, who is used to connect via ssh and already setup to connect
# via ssh-keys
# USR="nixcraft"
#
# (c)Show warning if server load average is below the limit for last 5 minute.
# setup LOAD_WARN as per your need, default is 5.0
#
# LOAD_WARN=5.0
#
# (d) Setup your network title using MYNETINFO
# MYNETINFO="My Network Info"
#
# (e) Save the file
#
# Please refer to forum topic on this script:
# Also download the .gif files and put them in your output dir
#
# ----------------------------------------------------------------------------
# Execute script as follows (and copy .gif file in this dir) :
# this.script.name > /var/www/html/info.html
# ============================================================================
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
 
# SSH SERVER HOST IPS, setup me
# Change this to query your host
Q_HOST="10.2.2.11  10.2.2.12  10.2.2.141  10.2.2.142  10.2.2.145  10.2.2.146  10.2.2.148  10.2.2.149  10.2.2.21  10.2.2.22  10.2.2.24  10.2.2.25  10.2.2.27  10.2.2.28  10.2.2.31  10.2.2.32  10.2.2.33  10.2.2.34  10.2.2.35  10.2.2.36  10.2.2.37  10.2.2.38   10.2.2.40  10.2.2.41  10.2.2.42  10.2.2.43  10.2.2.51  10.2.2.52  10.2.2.53  10.2.2.54  10.2.2.55  10.2.2.56  10.2.2.57  10.2.2.58  10.2.2.59  10.2.2.60  10.2.2.61"
 
# SSH USER, change me
USR="gfx"
 
# Show warning if server load average is below the limit for last 5 minute
LOAD_WARN=5.0

# Local path to ssh and other bins
SSH="/usr/bin/ssh"
PING="/bin/ping"
NOW="$(date)"

## main ##
        echo -e "--IP-----\t-------Hostname--\t-------Load-------\t----RAM Total/Used---\t--Total process--\t -HDD Free/Used--"

for host in $Q_HOST
do
	_CMD="$SSH $USR@$host"
	rhostname="$($_CMD hostname)" 
#	echo "$rhostname "	

#	ruptime="$($_CMD uptime)"	
#	if $(echo $ruptime | grep -E "min|days" >/dev/null); then
#		x=$(echo $ruptime | awk '{ print $3 $4}')
#	else
#		x=$(echo $ruptime | sed s/,//g| awk '{ print $3 " (hh:mm)"}')
#	fi
#	ruptime="$x" 
#	echo "$ruptime"

	rload="$($_CMD uptime |awk -F'average:' '{ print $2}')"
	x="$(echo $rload | sed s/,//g | awk '{ print $2}')"
	y="$(echo "$x >= $LOAD_WARN" | bc)"
	[ "$y" == "1" ] && rload="$rload (High) $NOC" || rload=" $rload (Ok) $NOC"
			
#	echo "$rload "
#	rclock="$($_CMD date +"%r")"

	rtotalprocess="$($_CMD ps axue | grep -vE "^USER|grep|ps" | wc -l)"

	#rfs3="$($_CMD df -hP | grep -vE 'boot|shm' |awk {'print $4'})"
	#rfs2="$($_CMD df -hP | grep -vE 'boot|shm' |awk {'print $5'} )"
	#rfs1="$($_CMD df -hP | grep -vE 'boot|shm' |awk {'print $6'} )"

#	 rfs1="$($_CMD	df -hP | grep -vE 'boot|shm' |awk '{print $4 "/" $5}'  |grep -vE 'Use' |awk '/--/{print s;printf $0;s=""}!/--/{s=s" "$0}END{print s}' )"
	 warning_disk=75;
	 rfs1="$($_CMD df -hP | grep -vE 'boot|shm|残り' |awk '{print $4 " " $5}'  |grep -vE 'Use' |sed 's/\%//I' | awk '{ print $1 "/" $2"%"; if($2 >= 75 ) { print " Warning Check Disk now" ;}}' |awk ' /--/{print s;printf $0;s=""}!/--/{s=s" "$0}END{print s}' )"

	rusedram="$($_CMD free -mto | grep Mem: | awk '{ print $3 "MB" }')"
#	rfreeram="$($_CMD free -mto | grep Mem: | awk '{ print $4 " MB" }')"
	rtotalram="$($_CMD free -mto | grep Mem: | awk '{ print $2 "MB" }')"
	echo -e "$host \t $rhostname \t  $rload \t $rtotalram/$rusedram  \t $rtotalprocess \t $rfs1"
done
