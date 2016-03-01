#!/bin/bash

_CURDATE=$(date +'%Y/%m/%d [%H:%M JST]')
_SCRPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

_ALERTIF=85
_MT4='mtsrv\|nts-mt4\|mtreportsvr'
_MT4SVR=("10.2.3.220")
_MAILBD="$_SCRPDIR/bo_report.mail"
_MAILFULL="$_SCRPDIR/bo_report_full.mail"
>"$_MAILBD"
_HEADER='From: no-reply@min-st.jp
To: om-trs@nextop.asia, st-sysrep@traderssec.co.jp
Cc: Tung.Nguyen.Xuan@nextop.asia
'
TEST_HEADER='From: no-reply@min-st.jp
To: Tung.Nguyen.Xuan@nextop.asia
'


#BACKIFS=$IFS
IFS=$'\r\n'
echo $(date +'[PROD] [TRS-BO] Report At: %Y/%m/%d - %H:%M %p')

echo "From      : $(who am i)"| tee -a $_MAILBD
echo "Status    : report"| tee -a $_MAILBD
echo "ReportBy  : ${BASH_SOURCE[0]}"| tee -a $_MAILBD
echo "DateTime  : $(date)"| tee -a $_MAILBD

echo "=========================================" | tee -a $_MAILBD
for _AIP in ${_SERVERS[@]}
do
		echo "Server: $_AIP" | tee -a $_MAILBD
        _ERROR=''
        _HDD=""
        _DFH=( $(ssh $_AIP 'df -h | grep "/" | grep -v "/dev/shm\|/boot" | grep "%"') )
        if [ $? -eq 0 ]
        then

        for _APR in ${_DFH[@]}
        do
                _HDD="$_HDD
$(echo $_APR | awk '{print "["$NF"] "$(NF-4)" Used: "$(NF-3)" "$(NF-1)", "}')"
                _PART=$(echo $_APR | awk '{print $NF}')
                _PERCENT=$(echo $_APR | awk '{print $(NF-1)}' | awk -F '%' '{print $1}')
                if [ $_PERCENT -gt $_ALERTIF ]; then _ERROR=$_ERROR"Partition: [$_PART] $_PERCENT% > $_ALERTIF% Used, "; fi
        done

        _SERVERSPSU=($(ssh $_AIP ps -ef | grep java | grep DprocessName | grep -v grep))
        for _ATRSM1PS in ${_SERVERSPSU[@]}
        do
                _SERVERSPNM=$(echo $_ATRSM1PS | sed -n 's/.*DprocessName\=//p' | awk -v ip=$_AIP {'print $1'})
                _SERVERSPID=$(echo $_ATRSM1PS | awk '{print $2}')
                _SERVERSStartTime=$(ssh $_AIP "ps -o lstart= $_SERVERSPID")
                echo "$_SERVERSPNM (PID $_SERVERSPID) (Start time \"$_SERVERSStartTime)\"" | tee -a $_MAILBD
        done

        echo "Hdd: $_HDD" | tee -a $_MAILBD
        echo $(ssh $_AIP free -m | grep 'Mem' | awk '{print "Mem: "$2"Mb "int($3/$2*100)"% Used"}') | tee -a $_MAILBD
        if [ ${#_ERROR} -gt 0 ]; then echo "WARN - $_ERROR" | tee -a $_MAILBD; fi

        else
                echo "$_AIP - ERROR - CANNOT ESTABLISH CONNECTION" | tee -a $_MAILBD
        fi
        echo "=========================================" | tee -a $_MAILBD
done



_OIDLABEL=".1.3.6.1.2.1.25.2.3.1.3"

for _AMT4 in ${_MT4SVR[@]}
do
        _ERROR=''
        _MT4SNMP=($(snmpwalk -v 2c -c public $_AMT4 .1.3.6.1.2.1.25.4.2.1.2 | grep $_MT4))
        if [ $? -eq 0 ]
        then

        for _ALINE in ${_MT4SNMP[@]}
        do
                _MT4PID=$(echo $_ALINE | awk -F 'hrSWRunName.' '{print $NF}' | awk -F ' = ' '{print $1}')
                _MT4PNM=$(echo $_ALINE | awk -F '"' '{print $(NF - 1)}')
                echo "$_MT4SVR - $_MT4PNM ($_MT4PID)" | tee -a $_MAILBD
        done
        _MT4HDD=''
        _MT4DISK=($(snmpwalk -v 2c -c public $_AMT4 $_OIDLABEL | grep 'Serial Number'))
        for _ASNMP in ${_MT4DISK[@]}
        do
                _MT4DSK=$(echo $_ASNMP | awk -F 'STRING: ' '{print $NF}' | awk -F '\\' '{print $1}')
                _MT4DID=$(echo $_ASNMP | awk -F ' = ' '{print $1}' | awk -F '.' '{print $NF}')
                _DSKTOL=$(snmpwalk -v 2c -c public $_AMT4 ".1.3.6.1.2.1.25.2.3.1.5.$_MT4DID" | awk '{print $NF}')
                _DSKUSE=$(snmpwalk -v 2c -c public $_AMT4 ".1.3.6.1.2.1.25.2.3.1.6.$_MT4DID" | awk '{print $NF}')
                _DSKPER=$((($_DSKUSE * 100) / $_DSKTOL))
                _MT4HDD="$_MT4HDD
[$_MT4DSK] $(($_DSKTOL / 1024 / 1024))Gb Used: $_DSKPER%, "
                if [ $_DSKPER -gt $_ALERTIF ]; then _ERROR=$_ERROR"Partition: [$_MT4DSK] $_DSKPER% > $_ALERTIF% Used, "; fi
        done
        echo "$_AMT4 - HDD: $_MT4HDD" | tee -a $_MAILBD
        if [ ${#_ERROR} -gt 0 ]; then echo "WARN - $_ERROR" | tee -a $_MAILBD; fi

        else
                echo "$_AMT4 - ERROR - CANNOT ESTABLISH SNMP CONNECTION TO SERVER" | tee -a $_MAILBD
        fi
        echo "=========================================" | tee -a $_MAILBD
done

#echo 'Close Market:' >> $_MAILBD
#cat /opt/batch_app/logs/closemarket/closemarket.log | grep -i 'closemarket' >> $_MAILBD
#echo 'Open Market:' >> $_MAILBD
#cat /opt/batch_app/logs/openmarket/openmarket.log | grep -i "front\|date" >> $_MAILBD

if [ $(grep 'ERROR\|WARN' $_MAILBD | wc -l) -gt 0 ]
then _HEADER="$_HEADER""Subject: [PROD] [TRS-BO] Report For $_CURDATE [CRITICAL]";
else _HEADER="$_HEADER""Subject: [PROD] [TRS-BO] Report For $_CURDATE [INFO]";
fi

_HEADER="$_HEADER

"

echo "$_HEADER" | cat - $_MAILBD > './mail_temp' && mv './mail_temp' "$_MAILFULL"

cat "$_MAILFULL" | mail -t

echo -n "MAIL "
[ $? -eq 0 ] || echo "FAILED"

unset IFS