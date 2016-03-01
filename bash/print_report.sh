#!/bin/bash

FILE=./report.out

sh ./lam_report.sh.20130819 > $FILE

CITI_PID=`cat $FILE | grep "10.2.2.51" | grep GK_GW_CITI | awk '{print $3}' | awk -F: '{print $2}'`
BOA_PID=`cat $FILE | grep GK_GW_BOA | awk '{print $3}' | awk -F: '{print $2}'`
UBS_PID=`cat $FILE | grep GK_GW_UBS | awk '{print $3}' | awk -F: '{print $2}'`
BARX_PID=`cat $FILE | grep GK_GW_BARX | awk '{print $3}' | awk -F: '{print $2}'`
HOTS_PID=`cat $FILE | grep GK_GW_HOTS | awk '{print $3}' | awk -F: '{print $2}'`
HSBC_PID=`cat $FILE | grep GK_GW_HSBC | awk '{print $3}' | awk -F: '{print $2}'`
CNX_PID=`cat $FILE | grep GK_GW_CNX | awk '{print $3}' | awk -F: '{print $2}'`
FXCM_PID=`cat $FILE | grep GK_GW_FXFM | awk '{print $3}' | awk -F: '{print $2}'`
BTMU_PID=`cat $FILE | grep GK_GW_BMTU | awk '{print $3}' | awk -F: '{print $2}'`
CITI2_PID=`cat $FILE | grep GK_GW_CITI2 | awk '{print $3}' | awk -F: '{print $2}'`
MSFX_PID=`cat $FILE | grep GK_GW_MSFX | awk '{print $3}' | awk -F: '{print $2}'`

HEDGEMNG_PID=`cat $FILE | grep HEDGEMNG | awk '{print $3}' | awk -F: '{print $2}'`
CPRATECACHE_PID=`cat $FILE | grep GK_CPRATECACHE | awk '{print $3}' | awk -F: '{print $2}'`
RATEMNG_PID=`cat $FILE | grep GK_RATEMNG | awk '{print $3}' | awk -F: '{print $2}'`
CPRATEWRITER_PID=`cat $FILE | grep GK_CPRATEWRITER | awk '{print $3}' | awk -F: '{print $2}'`
POOLFILTER_PID=`cat $FILE | grep POOLFILTER | awk '{print $3}' | awk -F: '{print $2}'`
POOLMNG_PID=`cat $FILE | grep POOLMNG | awk '{print $3}' | awk -F: '{print $2}'`
WEBSOCKET_PID=`cat $FILE | grep GK_DEALING_WEBSOCKET | awk '{print $3}' | awk -F: '{print $2}'`
DLWEB_PID=`cat $FILE | grep GK_TOMCAT_DEALING | awk '{print $3}' | awk -F: '{print $2}'`
FXRATEWRITER_PID=`cat $FILE | grep GK_FXRATEWRITER | awk '{print $3}' | awk -F: '{print $2}'`
EXCHANGESERVER_PID=`cat $FILE | grep GK_EXCHANGESERVER | awk '{print $3}' | awk -F: '{print $2}'`
FXFIXRATEWRITER_PID=`cat $FILE | grep GK_FXFIXRATEWRITER | awk '{print $3}' | awk -F: '{print $2}'`
RATEGENERATOR_PID=`cat $FILE | grep GK_RATEGENERATOR | awk '{print $3}' | awk -F: '{print $2}'`
TRIANA_PID=`cat $FILE | grep GK_TRIANA | awk '{print $3}' | awk -F: '{print $2}'`
FTSS_PID=`cat $FILE | grep GK_FTSS | awk '{print $3}' | awk -F: '{print $2}'`
SENDMAIL_PID=`cat $FILE | grep GKG_SENDMAIL | awk '{print $3}' | awk -F: '{print $2}'`

ACTIVEMQ151_PID=`cat $FILE | grep ACTIVEMQ151 | awk '{print $3}' | awk -F: '{print $2}'`
ACTIVEMQ152_PID=`cat $FILE | grep ACTIVEMQ152 | awk '{print $3}' | awk -F: '{print $2}'`

ACTIVEMQ31_PID=`cat $FILE | grep ACTIVEMQ31 | awk '{print $3}' | awk -F: '{print $2}'`
ACTIVEMQ32_PID=`cat $FILE | grep ACTIVEMQ32 | awk '{print $3}' | awk -F: '{print $2}'`

ACTIVEMQ33_PID=`cat $FILE | grep ACTIVEMQ33 | awk '{print $3}' | awk -F: '{print $2}'`
ACTIVEMQ34_PID=`cat $FILE | grep ACTIVEMQ34 | awk '{print $3}' | awk -F: '{print $2}'`

CITI_DISK=`cat $FILE | grep "10.2.2.51" | grep GK_GW_CITI | awk '{print $6}'`
BOA_DISK=`cat $FILE | grep GK_GW_BOA | awk '{print $6}'`
UBS_DISK=`cat $FILE | grep GK_GW_UBS | awk '{print $6}'`
BARX_DISK=`cat $FILE | grep GK_GW_BARX | awk '{print $6}'`
HOTS_DISK=`cat $FILE | grep GK_GW_HOTS | awk '{print $6}'`
HSBC_DISK=`cat $FILE | grep GK_GW_HSBC | awk '{print $6}'`
CNX_DISK=`cat $FILE | grep GK_GW_CNX | awk '{print $6}'`
FXCM_DISK=`cat $FILE | grep GK_GW_FXFM | awk '{print $6}'`
BTMU_DISK=`cat $FILE | grep GK_GW_BMTU | awk '{print $6}'`
CITI2_DISK=`cat $FILE | grep GK_GW_CITI2 | awk '{print $6}'`
MSFX_DISK=`cat $FILE | grep GK_GW_MSFX | awk '{print $6}'`

HEDGEMNG_DISK=`cat $FILE | grep HEDGEMNG | awk '{print $6}'`
CPRATECACHE_DISK=`cat $FILE | grep GK_CPRATECACHE | awk '{print $6}'`
RATEMNG_DISK=`cat $FILE | grep GK_RATEMNG | awk '{print $6}'`
CPRATEWRITER_DISK=`cat $FILE | grep GK_CPRATEWRITER | awk '{print $6}'`
POOLFILTER_DISK=`cat $FILE | grep POOLFILTER | awk '{print $6}'`
POOLMNG_DISK=`cat $FILE | grep POOLMNG | awk '{print $6}'`
WEBSOCKET_DISK=`cat $FILE | grep GK_DEALING_WEBSOCKET | awk '{print $6}'`
DLWEB_DISK=`cat $FILE | grep GK_TOMCAT_DEALING | awk '{print $6}'`
FXRATEWRITER_DISK=`cat $FILE | grep GK_FXRATEWRITER | awk '{print $6}'`
EXCHANGESERVER_DISK=`cat $FILE | grep GK_EXCHANGESERVER | awk '{print $6}'`
FXFIXRATEWRITER_DISK=`cat $FILE | grep GK_FXFIXRATEWRITER | awk '{print $6}'`
RATEGENERATOR_DISK=`cat $FILE | grep GK_RATEGENERATOR | awk '{print $6}'`
TRIANA_DISK=`cat $FILE | grep GK_TRIANA | awk '{print $6}'`
FTSS_DISK=`cat $FILE | grep GK_FTSS | awk '{print $6}'`
SENDMAIL_DISK=`cat $FILE | grep GKG_SENDMAIL | awk '{print $6}'`

ACTIVEMQ151_DISK=`cat $FILE | grep ACTIVEMQ151 | awk '{print $6}'`
ACTIVEMQ152_DISK=`cat $FILE | grep ACTIVEMQ152 | awk '{print $6}'`

ACTIVEMQ31_DISK=`cat $FILE | grep ACTIVEMQ31 | awk '{print $6}'`
ACTIVEMQ32_DISK=`cat $FILE | grep ACTIVEMQ32 | awk '{print $6}'`

ACTIVEMQ33_DISK=`cat $FILE | grep ACTIVEMQ33 | awk '{print $6}'`
ACTIVEMQ34_DISK=`cat $FILE | grep ACTIVEMQ34 | awk '{print $6}'`

snmpwalk -v 2c -c public 10.2.2.121 .1.3.6.1.2.1.25.4.2.1.2 | grep mt5 | awk -F ":hrSWRunName." '{print $2}' | awk -F " = STRING: " '{print $1" "$2}' > ./snmp_121.tmp
snmpwalk -v 2c -c public 10.2.2.122 .1.3.6.1.2.1.25.4.2.1.2 | grep mt5 | awk -F ":hrSWRunName." '{print $2}' | awk -F " = STRING: " '{print $1" "$2}' > ./snmp_122.tmp

mt5access64=`cat snmp_121.tmp | grep "mt5access64" | awk '{print $1}'`
mt5backup64=`cat snmp_121.tmp | grep "mt5backup64" | awk '{print $1}'`
mt5history64=`cat snmp_121.tmp | grep "mt5history64" | awk '{print $1}'`
mt5trade64=`cat snmp_121.tmp | grep "mt5trade64" | awk '{print $1}'`
datafeed=`cat snmp_121.tmp | grep "datafeed" | awk '{print $1}'`
rate=`cat snmp_121.tmp | grep "rate" | awk '{print $1}'`
cashflow=`cat snmp_121.tmp | grep "cashflow" | awk '{print $1}'`
trading=`cat snmp_121.tmp | grep "trading" | awk '{print $1}'`

mt5backup64=`cat snmp_122.tmp | grep "mt5backup64" | awk '{print $1}'`
amsbridge=`cat snmp_122.tmp | grep "amsbridge" | awk '{print $1}'`
wtrade=`cat snmp_122.tmp | grep "wtrade" | awk '{print $1}'`

ams_back=`ssh 10.2.2.141 ps ux | grep "GK_TOMCAT_BACKEND" | grep -v 'grep' | awk '{print $2}'`
ams_disk=`ssh 10.2.2.141 df | grep -w '/' | awk '{print $4}'`

echo "===========================================" >> $FILE
echo "Mt5:" >> $FILE
echo "===========================================" >> $FILE
echo "OK" >> $FILE
echo $mt5access64 >> $FILE
echo $mt5backup64 >> $FILE
echo $mt5history64 >> $FILE
echo $mt5trade64 >> $FILE
echo $datafeed >> $FILE
echo $rate >> $FILE
echo $cashflow >> $FILE
echo $trading >> $FILE
echo "YES" >> $FILE
echo "OK" >> $FILE
echo $mt5backup64 >> $FILE
echo $amsbridge >> $FILE
echo $wtrade >> $FILE
echo "YES" >> $FILE
echo $ams_back >> $FILE
echo $ams_disk >> $FILE

echo "===========================================" >> $FILE
echo "Gateways:" >> $FILE
echo "===========================================" >> $FILE
echo $CITI_PID >> $FILE
echo $CITI_DISK >> $FILE
echo $CITI2_PID >> $FILE
echo $CITI2_DISK >> $FILE
echo $BOA_PID >> $FILE
echo $BOA_DISK >> $FILE
echo $UBS_PID >> $FILE
echo $UBS_DISK >> $FILE
echo $BARX_PID >> $FILE
echo $BARX_DISK >> $FILE
echo $HOTS_PID >> $FILE
echo $HOTS_DISK >> $FILE
echo $HSBC_PID >> $FILE
echo $HSBC_DISK >> $FILE
echo $CNX_PID >> $FILE
echo $CNX_DISK >> $FILE
echo $FXCM_PID >> $FILE
echo $FXCM_DISK >> $FILE
echo $BTMU_PID >> $FILE
echo $BTMU_DISK >> $FILE
echo $MSFX_PID >> $FILE
echo $MSFX_DISK >> $FILE
echo "===========================================" >> $FILE
echo "Services:" >> $FILE
echo "===========================================" >> $FILE
echo $HEDGEMNG_PID >> $FILE
echo $HEDGEMNG_DISK >> $FILE
echo $CPRATECACHE_PID >> $FILE
echo $CPRATECACHE_DISK >> $FILE
echo $RATEMNG_PID >> $FILE
echo $RATEMNG_DISK >> $FILE
echo $CPRATEWRITER_PID >> $FILE
echo $CPRATEWRITER_DISK >> $FILE
echo $POOLFILTER_PID >> $FILE
echo $POOLFILTER_DISK >> $FILE
echo $POOLMNG_PID >> $FILE
echo $POOLMNG_DISK >> $FILE
echo $WEBSOCKET_PID >> $FILE
echo $WEBSOCKET_DISK >> $FILE
echo $DLWEB_PID >> $FILE
echo $DLWEB_DISK >> $FILE
echo $FXRATEWRITER_PID >> $FILE
echo $FXRATEWRITER_DISK >> $FILE
echo $EXCHANGESERVER_PID >> $FILE
echo $EXCHANGESERVER_DISK >> $FILE
echo $FXFIXRATEWRITER_PID >> $FILE
echo $FXFIXRATEWRITER_DISK >> $FILE
echo $RATEGENERATOR_PID >> $FILE
echo $RATEGENERATOR_DISK >> $FILE
echo $TRIANA_PID >> $FILE
echo $TRIANA_DISK >> $FILE
echo $FTSS_PID >> $FILE
echo $FTSS_DISK >> $FILE
echo $SENDMAIL_PID >> $FILE
echo $SENDMAIL_DISK >> $FILE
echo "===========================================" >> $FILE
echo "ActiveMQ:" >> $FILE
echo "===========================================" >> $FILE
echo $ACTIVEMQ151_PID >> $FILE
echo "OK" >> $FILE
echo $ACTIVEMQ151_DISK >> $FILE

echo $ACTIVEMQ152_PID >> $FILE
echo "OK" >> $FILE
echo $ACTIVEMQ152_DISK >> $FILE

echo $ACTIVEMQ31_PID >> $FILE
echo "OK" >> $FILE
echo $ACTIVEMQ31_DISK >> $FILE

echo $ACTIVEMQ32_PID >> $FILE
echo "OK" >> $FILE
echo $ACTIVEMQ32_DISK >> $FILE

echo $ACTIVEMQ33_PID >> $FILE
echo "OK" >> $FILE
echo $ACTIVEMQ33_DISK >> $FILE

echo $ACTIVEMQ34_PID >> $FILE
echo "OK" >> $FILE
echo $ACTIVEMQ34_DISK >> $FILE
