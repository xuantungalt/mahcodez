#!/bin/bash
LINE=20000
#SERVER=("10.2.2.54|Barx|/opt/gk_app/logs/gw-barx/dealing.cp.barx.rate.log" "10.2.2.52|BOA|/opt/gk_app/logs/gw-boa/gkg.cp.boa.rate.log" "10.2.2.51|CITI|/opt/gk_app/logs/gw-citi/dealing.cp.citi.rate.log" "10.2.2.59|FXCM|/opt/gk_app/logs/fxfm/dealing.cp.fastmatch.rate.log" "10.2.2.55|Hotspot|/opt/gk_app/logs/gw-hotspot/nts.gw.hotspot.log" "10.2.2.58|HSBC|/opt/gk_app/logs/hsbc/dealing.cp.hsbc.rate.log" "10.2.2.58|MSFX|/opt/gk_app/logs/gw-msfx/nts.gw.msfx.rate.log")
SERVER=("10.2.2.54|Barx|/opt/gk_app/logs/gw-barx/dealing.cp.barx.rate.log" "10.2.2.52|BOA|/opt/gk_app/logs/gw-boa/gkg.cp.boa.log" "10.2.2.51|CITI|/opt/gk_app/logs/gw-citi/dealing.cp.citi.rate.log" "10.2.2.59|FXCM|/opt/gk_app/logs/fxfm/dealing.cp.fastmatch.rate.log" "10.2.2.55|Hotspot|/opt/gk_app/logs/gw-hotspot/nts.gw.hotspot.log" "10.2.2.58|HSBC|/opt/gk_app/logs/hsbc/dealing.cp.hsbc.rate.log" "10.2.2.58|MSFX|/opt/gk_app/logs/gw-msfx/nts.gw.msfx.rate.log")
TOTAL_RATE=0
CUR_DATE=`date +"%Y-%m-%d"`
DEBUG_TIME=`date -d"2 min ago" +"%H:%M"`
SEARCH_TIME=`date -d"1 min ago" +"%H:%M"`
CURRENT_TIME=`date +"%H:%M"`
DEFAULT_TIME=`date -d"1 min ago" +"%H:%M"`
s_1=0

while [ $s_1 -lt ${#SERVER[@]} ]
do

IP_ADDR=`echo ${SERVER[$s_1]} | awk -F '|' '{print $1}'`
LOG_FILE=`echo ${SERVER[$s_1]} | awk -F '|' '{print $3}'`
SERVER_NAME=`echo ${SERVER[$s_1]} | awk -F '|' '{print $2}'`

result=`ssh $IP_ADDR tail -n $LINE $LOG_FILE | grep "$CUR_DATE $DEBUG_TIME\|$CUR_DATE $SEARCH_TIME\|$CUR_DATE $CURRENT_TIME" | grep "INFO\|DEBUG\|CpRateInfo" | awk -F 'INFO' '{print $1}' | cut -d':' -f1-2 | uniq -c | tail -2 | head -1 | awk '{print $3" ---> "$1}'`

#echo $SERVER_NAME' ---> '$result
#count_time[$s_1]=''
count_time[$s_1]=`echo $result | awk '{print $1}'`
if [ -z ${count_time[$s_1]} ]
then
count_time[$s_1]=$DEFAULT_TIME
fi

count_rate[$s_1]=0
count_rate[$s_1]=`echo $result | awk '{print $3}'`
#echo $result
if [ -z ${count_rate[$s_1]} ]
then
count_rate[$s_1]=0
fi
TOTAL_RATE=`expr $TOTAL_RATE + ${count_rate[$s_1]}`
s_1=`expr $s_1 + 1`

done

#NO_CPR=("10.2.2.61|CNX|/opt/gk_app/logs/gw-cnx/dealing.cp.cnx.rate.log" "10.2.2.56|DB|/opt/gk_app/logs/gw-db/cp.db.rate.log" "10.2.2.60|BTMU|/opt/gk_app/logs/gw-btmu/nts.gw.gwbtmu.rate.log" "10.2.2.53|UBS|/opt/gk_app/logs/gw-ubs/nts.gw.ubs.rate.log" "10.2.2.56|CITI2|/opt/gk_app/logs/gw-citi2/nts.gw.citi2.rate.log" "10.2.2.60|BNP|/opt/gk_app/logs/gw-bnp/dealing.cp.bnp.log" "10.2.2.149|FIX_EXCHANGE|/opt/gk_app/logs/exchangeserver/exserver.log")
NO_CPR=("10.2.2.61|CNX|/opt/gk_app/logs/gw-cnx/dealing.cp.cnx.rate.log" "10.2.2.56|DB|/opt/gk_app/logs/gw-db/cp.db.rate.log" "10.2.2.60|BTMU|/opt/gk_app/logs/gw-btmu/nts.gw.gwbtmu.rate.log" "10.2.2.53|UBS|/opt/gk_app/logs/gw-ubs/nts.gw.ubs.rate.log" "10.2.2.56|CITI2|/opt/gk_app/logs/gw-citi2/nts.gw.citi2.rate.log" "10.2.2.60|BNP|/opt/gk_app/logs/gw-bnp/dealing.cp.bnp.log" "10.2.2.59|RBS|/opt/gk_app/logs/gw-rbs/dealing.cp.rbs.rate.log" "10.2.2.57|NOMURA|/opt/gk_app/logs/fxnomura/dealing.cp.nomura.log" "10.2.2.61|FXJP|/opt/gk_app/logs/gw-fxjp/nts.gw.fxjp.rate.log" "10.2.2.58|INTEGRA|/opt/gk_app/logs/gw-integral/nts.gw.integral.log" "10.2.2.149|FIX|/opt/gk_app/logs/exchangeserver/exserver.log")
s_2=0
while [ $s_2 -lt ${#NO_CPR[@]} ]
do

NOCPR_IP_ADDR=`echo ${NO_CPR[$s_2]} | awk -F '|' '{print $1}'`
NOCPR_LOG_FILE=`echo ${NO_CPR[$s_2]} | awk -F '|' '{print $3}'`
NOCPR_DEBUG_NAME=`echo ${NO_CPR[$s_2]} | awk -F '|' '{print $2}'`
#echo $DEBUG_TIME'\|'$SEARCH_TIME'\|'$CURRENT_TIME
nocpr=`ssh $NOCPR_IP_ADDR tail -n $LINE $NOCPR_LOG_FILE | grep "$CUR_DATE $DEBUG_TIME\|$CUR_DATE $SEARCH_TIME\|$CUR_DATE $CURRENT_TIME" | grep "INFO\|DEBUG" | awk -F 'INFO' '{print $1}' | cut -d':' -f1-2 | uniq -c | tail -2 | head -1 | awk '{print $3" ---> "$1}'`

#echo $NOCPR_DEBUG_NAME' ---> '$nocpr
nocpr_time[$s_2]=''
nocpr_time[$s_2]=`echo $nocpr | awk '{print $1}'`
if [ -z ${nocpr_time[$s_2]} ]
then
nocpr_time[$s_2]=$DEFAULT_TIME
fi

nocpr_rate[$s_2]=0
nocpr_rate[$s_2]=`echo $nocpr | awk '{print $3}'`
if [ -z ${nocpr_rate[$s_2]} ]
then
nocpr_rate[$s_2]=0
fi
TOTAL_RATE=`expr $TOTAL_RATE + ${nocpr_rate[$s_2]}`
s_2=`expr $s_2 + 1`

done

TOTAL_RATE=`expr $TOTAL_RATE - ${nocpr_rate[$(expr ${#nocpr_rate[@]}-1)]}`

#TOTAL_RATE=`expr ${count_rate[0]} + ${count_rate[1]} + ${count_rate[2]} + ${count_rate[3]} + ${count_rate[4]} + ${count_rate[5]} + ${count_rate[6]} +  ${nocpr_rate[0]} + ${nocpr_rate[1]} + ${nocpr_rate[2]} + ${nocpr_rate[3]} + ${nocpr_rate[4]} + ${nocpr_rate[5]} + ${nocpr_rate[6]} + ${nocpr_rate[7]}`
#TOTAL_RATE=`expr ${count_rate[0]} + ${count_rate[1]} + ${count_rate[2]} + ${count_rate[3]} + ${count_rate[4]} + ${count_rate[5]} + ${count_rate[6]} + ${nocpr_rate[0]} + ${nocpr_rate[1]} + ${nocpr_rate[2]} + ${nocpr_rate[3]} + ${nocpr_rate[4]} + ${nocpr_rate[5]} + ${nocpr_rate[6]} + ${nocpr_rate[7]} + ${nocpr_rate[8]}`
echo "
System Report:
Login MT5 OK
Login Dealing OK
Rate in Price Panel OK
Rate in Dealing OK
MarketDepth OK
--------------------
On 10.2.2.121 Server
Mt5-tool-cashfollow        OK
nts-mt5-rate               OK
nts-mt5-datafeed           OK
Mt5-trading                OK
nts-mt5-wtrade             OK
--------------------
On 10.2.2.122 Server
nts-mt5-amsbridge            OK
nts-mt5-webtrade             OK
--------------------"
ec_n=0
while [ $ec_n -lt ${#SERVER[@]} ]
do
NAME=`echo ${SERVER[$ec_n]} | awk -F '|' '{print $2}'`
#echo ${count_time[$ec_n]}
printf "%11s\n" $NAME
printf "%4s %6s %-6s\n" ${count_time[$ec_n]} " ---> " ${count_rate[$ec_n]}
ec_n=`expr $ec_n + 1`
done

ec_un=0
while [ $ec_un -lt `expr ${#NO_CPR[@]} - 1` ]
do
U_NAME=`echo ${NO_CPR[$ec_un]} | awk -F '|' '{print $2}'`
#echo ${nocpr_time[$ec_un]}
printf "%11s\n" $U_NAME
printf "%4s %6s %-6s\n" ${nocpr_time[$ec_un]} " ---> " ${nocpr_rate[$ec_un]}
ec_un=`expr $ec_un + 1`
done

#printf "%11s\n" "BARX"
#printf "%4s %6s %-6d\n" ${count_time[0]} " ---> " ${count_rate[0]}
#printf "%11s\n" "BOA"
#printf "%4s %6s %-6d\n" ${count_time[1]} " ---> " ${count_rate[1]}
#printf "%11s\n" "CITI"
#printf "%4s %6s %-6d\n" ${count_time[2]} " ---> " ${count_rate[2]}
#printf "%11s\n" "DB"
#printf "%4s %6s %-6d\n" ${count_time[3]} " ---> " ${count_rate[3]}
#printf "%11s\n" "FXCM"
#printf "%4s %6s %-6d\n" ${count_time[3]} " ---> " ${count_rate[3]}
#printf "%11s\n" "Hotspot"
#printf "%4s %6s %-6d\n" ${count_time[4]} " ---> " ${count_rate[4]}
#printf "%11s\n" "HSBC"
#printf "%4s %6s %-6d\n" ${count_time[5]} " ---> " ${count_rate[5]}
#printf "%11s\n" "CNX"
#printf "%4s %6s %-6d\n" ${count_time[7]} " ---> " ${count_rate[7]}
#printf "%11s\n" "UBS"
#printf "%4s %6s %-6d\n" ${nocpr_time[1]} " ---> " ${nocpr_rate[1]}

#printf "%11s\n" "CNX"
#printf "%4s %6s %-6d\n" ${nocpr_time[0]} " ---> " ${nocpr_rate[0]}
#printf "%11s\n" "DB"
#printf "%4s %6s %-6d\n" ${nocpr_time[1]} " ---> " ${nocpr_rate[1]}
#printf "%11s\n" "BTMU"
#printf "%4s %6s %-6d\n" ${nocpr_time[2]} " ---> " ${nocpr_rate[2]}
#printf "%11s\n" "CITI2"
#printf "%4s %6s %-6d\n" ${nocpr_time[3]} " ---> " ${nocpr_rate[3]}
#printf "%11s\n" "BNP"
#printf "%4s %6s %-6d\n" ${nocpr_time[4]} " ---> " ${nocpr_rate[4]}
#printf "%11s\n" "MSFX"
#printf "%4s %6s %-6d\n" ${count_time[6]} " ---> " ${count_rate[6]}
#printf "%11s\n" "FIX"
#printf "%4s %6s %-6d\n" ${nocpr_time[5]} " ---> " ${nocpr_rate[5]}
#printf "%11s\n" "FIX"
#printf "%4s %6s %-6d\n" ${nocpr_time[6]} " ---> " ${nocpr_rate[6]}
printf "%11s\n" "TOTAL"
printf "%4s %6s %-6d\n" $DEFAULT_TIME " ---> " $TOTAL_RATE
echo "--------------------"
printf "%13s\n" "FIX RATE"
printf "%4s %6s %-6d\n" ${nocpr_time[$(expr ${#nocpr_time[@]}-1)]} " ---> " ${nocpr_rate[$(expr ${#nocpr_rate[@]}-1)]}
echo "--------------------"
echo "Websocket server Resources"
echo "Dealing Websocket:"
echo `/usr/local/nagios/libexec/check_nrpe -H 10.2.2.142 -n -c check_cpu_mem -a 25 30 30 50`
echo "Webtrade Websocket:"
echo `/usr/local/nagios/libexec/check_nrpe -H 10.2.2.145 -n -c check_cpu_mem -a 25 30 30 50`
echo "--------------------
Unknown-Order on Dealing-Web: None
PROD MT5-Dealing : Position are the same"

#NOTES
#10.2.2.51|CITI|/opt/gk_app/logs/gw-citi/dealing.cp.citi.rate.log
#10.2.2.52|BOA|/opt/gk_app/logs/gw-boa/gkg.cp.boa.rate.log
#10.2.2.53|UBS|/opt/gk_app/logs/gw-ubs/nts.gw.ubs.rate.log ---> UNCOMMON
#10.2.2.54|Barx|/opt/gk_app/logs/gw-barx/dealing.cp.barx.rate.log
#10.2.2.55|Hotspot|/opt/gk_app/logs/gw-hotspot/nts.gw.hotspot.log
#10.2.2.56|DB|/opt/gk_app/logs/gw-db/cp.db.rate.log
#10.2.2.57|Nomura|
#10.2.2.58|HSBC|/opt/gk_app/logs/hsbc/dealing.cp.hsbc.rate.log
#10.2.2.58|MS|
#10.2.2.59|FXCM|/opt/gk_app/logs/fxfm/dealing.cp.fastmatch.rate.log
#10.2.2.59|GS|
#10.2.2.60|SAXO|
#10.2.2.60|RBS|
#10.2.2.60|GS2|
#10.2.2.61|CNX|/opt/gk_app/logs/gw-cnx/dealing.cp.cnx.rate.log ---> QUEER
#10.2.2.61|JP|
#10.2.2.61|UBS2|
###################################

