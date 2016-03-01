#!/bin/bash

LINE=500

COMMON=("10.2.2.51|CITI|/opt/gk_app/logs/gw-citi/dealing.cp.citi.rate.log" "10.2.2.56|CITI2|/opt/gk_app/logs/gw-citi2/nts.gw.citi2.rate.log" "10.2.2.60|BNP|/opt/gk_app/logs/gw-bnp/dealing.cp.bnp.log")
UN_COMMON=("10.2.2.54|Barx|/opt/gk_app/logs/gw-barx/dealing.cp.barx.rate.log" "10.2.2.52|BOA|/opt/gk_app/logs/gw-boa/gkg.cp.boa.log" "10.2.2.59|FXCM|/opt/gk_app/logs/fxfm/dealing.cp.fastmatch.rate.log" "10.2.2.55|Hotspot|/opt/gk_app/logs/gw-hotspot/nts.gw.hotspot.log" "10.2.2.58|HSBC|/opt/gk_app/logs/hsbc/dealing.cp.hsbc.rate.log" "10.2.2.53|UBS|/opt/gk_app/logs/gw-ubs/nts.gw.ubs.rate.log" "10.2.2.61|CNX|/opt/gk_app/logs/gw-cnx/dealing.cp.cnx.rate.log" "10.2.2.60|BTMU|/opt/gk_app/logs/gw-btmu/nts.gw.gwbtmu.rate.log" "10.2.2.56|DB|/opt/gk_app/logs/gw-db/cp.db.rate.log" "10.2.2.58|MSFX|/opt/gk_app/logs/gw-msfx/nts.gw.msfx.rate.log")

BASE_CUR="AUDJPY=AUD/JPY
CADJPY=CAD/JPY
CHFJPY=CHF/JPY
EURJPY=EUR/JPY
GBPJPY=GBP/JPY
NZDJPY=NZD/JPY
USDJPY=USD/JPY
ZARJPY=ZAR/JPY
AUDUSD=AUD/USD
EURUSD=EUR/USD
GBPUSD=GBP/USD
NZDUSD=NZD/USD
EURCHF=EUR/CHF
USDCHF=USD/CHF
USDCAD=USD/CAD
GBPCHF=GBP/CHF
AUDNZD=AUD/NZD
EURAUD=EUR/AUD
EURNZD=EUR/NZD
GBPAUD=GBP/AUD
AUDCAD=AUD/CAD
AUDCHF=AUD/CHF
CADCHF=CAD/CHF
EURCAD=EUR/CAD
EURGBP=EUR/GBP
GBPNZD=GBP/NZD
NOKJPY=NOK/JPY
NZDCAD=NZD/CAD
NZDCHF=NZD/CHF
SEKJPY=SEK/JPY
EURZAR=EUR/ZAR
GBPCAD=GBP/CAD
USDNOK=USD/NOK
USDSEK=USD/SEK
USDZAR=USD/ZAR
XAUUSD=XAU/USD
XAGUSD=XAG/USD"

function rate_ctr
{
 IP_ADDR=`echo $1 | awk -F '|' '{print $1}'`
 SERVER_NAME=`echo $1 | awk -F '|' '{print $2}'`
 LOG_FILE=`echo $1 | awk -F '|' '{print $3}'`
 TMP_LOG="/opt/tool/symbol_log_tmp/$SERVER_NAME""_tmp.log"
 RESULT_F="/var/www/html/monitors/symbol/check_symbol_"$SERVER_NAME"_result.tmp"
# echo "CRTD: $RESULT_F"
 >$RESULT_F
 ssh $IP_ADDR tail -n $LINE $LOG_FILE | grep "$CUR_TIME" | grep "$2" > $TMP_LOG
  for SYMBOL in ${BASE_CUR[@]}
  do
   CUR_C=`echo $SYMBOL | awk -F '=' '{print $1}'`
   CUR_U=`echo $SYMBOL | awk -F '=' '{print $2}'`
#echo "$CUR_C\|$CUR_U"
   result=`cat $TMP_LOG | grep "$CUR_C\|$CUR_U" | uniq | wc -l`
   if [ $result -gt 0 ]
   then
    echo "$CUR_U:$result" >> $RESULT_F
#    echo "$CUR_U:$result" >> /var/www/html/monitors/symbol/check_symbol_$SERVER_NAME\_result.tmp
   else
    echo "$CUR_U:NULL" >> $RESULT_F
#    echo "$CUR_U:NULL" >> /var/www/html/monitors/symbol/check_symbol_$SERVER_NAME\_result.tmp
   fi
  done
}

x=1
while [ $x -gt 0 ]
do

for SERVER in ${COMMON[@]}
 do
 rate_ctr $SERVER "currencyPair\|INFO"
 done

for UC_SERVER in ${UN_COMMON[@]}
 do
 rate_ctr $UC_SERVER "GKGOHFUTURES_MKD\|DATA_FIX_GK_GOH\|INFO"
 done

 echo "Done."
 sleep 30
done
