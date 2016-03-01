#!/bin/bash

_HIPROOMID='1000767'
_HIPTOKAPI='nG5SDZ8yJxWnPj8hCJpbuKcjbSKkmrcSXuiq8Ydx'
#_HIPTOKAPI="6XHoFiFvm4h3bPpkKSfvjfoYUZAm4IvMGqtJxd8v"
_HIPAPIURL="https://api.hipchat.com/v2/room/$_HIPROOMID/notification?auth_token=$_HIPTOKAPI"

#curl https://api.hipchat.com/v2/room?auth_token=FyVYmS8tKMLgsbUFkHGAF6TPqbAUg5j8I9FwdRmK | sed "s/, /\\
#/g"

_SERVERS="10.8.21.101
10.8.21.102
10.8.21.103
10.8.21.104
10.8.21.105
10.8.21.106
10.8.21.107
10.8.21.108
10.8.21.109
10.8.21.110
10.8.21.111"

#_SERVERS=("localhost")

_CURDATE=$(date +'%Y/%m/%d [%H:%M JST]')
_SCRPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
_ALERTIF=85
#_MT4='mtsrv\|nts-mt4\|mtreportsvr'
#_MT4SVR=("10.2.3.220")
_REPLOG="$_SCRPDIR/bo_report.hip"
_REPTMP="$_SCRPDIR/bo_report.tmp"
> "$_REPLOG"

IFS=$'\r\n'

for _AIP in ${_SERVERS[@]}
do
        echo "Server: $_AIP" | tee -a $_REPLOG
        _ERROR=''


        ssh $_AIP "top -b -n 1 | head -n 3 | grep -v '^Tasks: '"  | tee -a $_REPLOG

        _HDD=""
        _DFH=( $(ssh $_AIP 'df -h | grep "/" | grep -v "/dev/shm\|/boot" | grep "%"') )

        for _APR in ${_DFH[@]}
        do
                _HDD="$_HDD
$(echo $_APR | awk '{print "["$NF"] "$(NF-4)" Used: "$(NF-3)" "$(NF-1)", "}')"
                _PART=$(echo $_APR | awk '{print $NF}')
                _PERCENT=$(echo $_APR | awk '{print $(NF-1)}' | awk -F '%' '{print $1}')
                if [ $_PERCENT -gt $_ALERTIF ]; then _ERROR=$_ERROR"Partition: [$_PART] $_PERCENT% > $_ALERTIF% Used, "; fi
        done

        echo "Hdd: $_HDD" | tee -a $_REPLOG
        echo $(ssh $_AIP free -m | grep 'Mem' | awk '{print "Mem: "$2"Mb "int($3/$2*100)"% Used"}') | tee -a $_REPLOG
        if [ "$_ERROR" != '' ]
        then
                echo $_ERROR  | tee -a $_REPLOG
                _COLOR='red'
        else
                _COLOR='green'
        fi
        echo "=========================================" | tee -a $_REPLOG
done

_HIPDATA='{"color": "'$_COLOR'", "message": "'$(cat "$_REPLOG" | sed ':a;N;$!ba;s/\n/<br>/g')'"}'
curl -H "content-type: application/json" -d "$_HIPDATA" $_HIPAPIURL

unset IFS