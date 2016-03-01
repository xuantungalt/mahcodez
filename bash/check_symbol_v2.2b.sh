#!/bin/bash
LINE=200
BASECURRENCY_XAGXAUZAR="AUDJPY AUDNZD AUDUSD CADJPY EURAUD EURCHF EURGBP EURJPY EURNZD EURUSD GBPAUD GBPCHF GBPJPY GBPUSD NZDJPY NZDUSD USDCAD USDCHF USDJPY CHFJPY XAGUSD XAUUSD ZARJPY"
BASECURRENCY_COMMON="AUDJPY AUDNZD AUDUSD CADJPY EURAUD EURCHF EURGBP EURJPY EURNZD EURUSD GBPAUD GBPCHF GBPJPY GBPUSD NZDJPY NZDUSD USDCAD USDCHF USDJPY CHFJPY"
BASECURRENCY_UNCOMMON="AUD/JPY AUD/NZD AUD/USD CAD/JPY EUR/AUD EUR/CHF EUR/GBP EUR/JPY EUR/NZD EUR/USD GBP/AUD GBP/CHF GBP/JPY GBP/USD NZD/JPY NZD/USD USD/CAD USD/CHF USD/JPY CHF/JPY"
COMMON=("10.2.2.54|Barx|/opt/gk_app/logs/gw-barx/dealing.cp.barx.rate.log" "10.2.2.52|BOA|/opt/gk_app/logs/gw-boa/gkg.cp.boa.rate.log" "10.2.2.51|CITI|/opt/gk_app/logs/gw-citi/dealing.cp.citi.rate.log" "10.2.2.56|DB|/opt/gk_app/logs/gw-db/cp.db.rate.log" "10.2.2.59|FXCM|/opt/gk_app/logs/fxfm/dealing.cp.fastmatch.rate.log" "10.2.2.55|Hotspot|/opt/gk_app/logs/gw-hotspot/nts.gw.hotspot.log" "10.2.2.58|HSBC|/opt/gk_app/logs/hsbc/dealing.cp.hsbc.rate.log")
UN_COMMON=("10.2.2.53|UBS|/opt/gk_app/logs/gw-ubs/nts.gw.ubs.rate.log" "10.2.2.61|CNX|/opt/gk_app/logs/gw-cnx/dealing.cp.cnx.rate.log")

x=1
while [ $x -gt 0 ]
do

#echo "Clearing old data" 
>/var/www/html/monitors/symbol/check_symbol_Barx_result.tmp
>/var/www/html/monitors/symbol/check_symbol_BOA_result.tmp
>/var/www/html/monitors/symbol/check_symbol_CITI_result.tmp
>/var/www/html/monitors/symbol/check_symbol_DB_result.tmp
>/var/www/html/monitors/symbol/check_symbol_FXCM_result.tmp
>/var/www/html/monitors/symbol/check_symbol_Hotspot_result.tmp
>/var/www/html/monitors/symbol/check_symbol_HSBC_result.tmp
>/var/www/html/monitors/symbol/check_symbol_UBS_result.tmp
>/var/www/html/monitors/symbol/check_symbol_CNX_result.tmp
 
 s_1=0
while [ $s_1 -lt 7 ]
 do
  for SYMBOL in $BASECURRENCY_COMMON
  do
   IP_ADDR=`echo ${COMMON[$s_1]} | awk -F '|' '{print $1}'`
   SERVER_NAME=`echo ${COMMON[$s_1]} | awk -F '|' '{print $2}'`
   LOG_FILE=`echo ${COMMON[$s_1]} | awk -F '|' '{print $3}'`
   #echo "On $SERVER_NAME Checking $SYMBOL..."
   result=`ssh $IP_ADDR tail -n $LINE $LOG_FILE | grep "currencyPair" | grep $SYMBOL | sed 's/.*rate=//' | sed 's/,.*//' | uniq | wc -l`
   if [ $result != 0 ]
   then
    echo "$SYMBOL:$result" >> /var/www/html/monitors/symbol/check_symbol_$SERVER_NAME\_result.tmp
   else
    echo "$SYMBOL:NULL" >> /var/www/html/monitors/symbol/check_symbol_$SERVER_NAME\_result.tmp
   fi
   #echo "Done!"
  done
  s_1=`expr $s_1 + 1`
 done

 s_2=0
while [ $s_2 -lt 2 ]
 do
  for UC_SYMBOL in $BASECURRENCY_UNCOMMON
  do
   IP_ADDR=`echo ${UN_COMMON[$s_2]} | awk -F '|' '{print $1}'`
   SERVER_NAME=`echo ${UN_COMMON[$s_2]} | awk -F '|' '{print $2}'`
   LOG_FILE=`echo ${UN_COMMON[$s_2]} | awk -F '|' '{print $3}'`
   #echo "On $SERVER_NAME Checking $UC_SYMBOL..."
   result=`ssh $IP_ADDR tail -n $LINE $LOG_FILE |  grep "GKGOHFUTURES_MKD\|DATA_FIX_GK_GOH" | grep $UC_SYMBOL | awk -F '=' '{print $9":"$13}' | uniq | wc -l`
   if [ $result != 0 ]
   then
    echo "$UC_SYMBOL:$result" >> /var/www/html/monitors/symbol/check_symbol_$SERVER_NAME\_result.tmp
   else
    echo "$SYMBOL:NULL" >> /var/www/html/monitors/symbol/check_symbol_$SERVER_NAME\_result.tmp
   fi
   #echo "Done!"
  done
  s_2=`expr $s_2 + 1`
 done
 #echo "FINISH!"
 sleep 10
done

###################################
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

