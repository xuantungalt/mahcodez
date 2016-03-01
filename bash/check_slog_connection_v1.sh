#!/bin/sh
LINE=30000

if [ $# -ne 2 ]
then
    echo "Illegal Parameter(s), program only accept TWO parameters!"
	echo 'Usage: check_slog_connection $SERVICE_NAME $LOG_FILE'
	exit 1
else
	SERVICE=$1
    LOG_FILE=$2
fi

_date0=`date +"%Y-%m-%d %H:%M"`
_date1=`date -d"1 min ago" +"%Y-%m-%d %H:%M"`
_date2=`date -d"2 min ago" +"%Y-%m-%d %H:%M"`

tail -n $LINE $LOG_FILE | grep "$_date0\|$_date1\|$_date2" | grep "35=A\|35=5" > "/tmp/$SERVICE.355-35A.txt"
tmp_fsize=`stat -c %s "/tmp/$SERVICE.355-35A.txt"`

if [ $tmp_fsize -lt 1 ];then
   echo $SERVICE" Connection Status: NORMAL."
   exit 0
else
   cat "/tmp/$SERVICE.355-35A.txt"
   exit 2
fi

# 10.2.2.51 GK_GW_CITI /opt/gk_app/logs/gw-citi/dealing.cp.citi.log
# 10.2.2.52 GK_GW_BOA /opt/gk_app/logs/gw-boa/gkg.cp.boa.log
# 10.2.2.53 GK_GW_UBS /opt/gk_app/logs/gw-ubs/nts.gw.ubs.log
# 10.2.2.54 GK_GW_BARX /opt/gk_app/logs/gw-barx/dealing.cp.barx.log
# 10.2.2.55 GK_GW_HOTS /opt/gk_app/logs/gw-hotspot/nts.gw.hotspot.log
# 10.2.2.56 GK_GW_DB /opt/gk_app/logs/gw-db/cp.db.log
# 10.2.2.56 GK_GW_CITI2 /opt/gk_app/logs/gw-citi2/nts.gw.citi2.log
# 10.2.2.53 GK_GW_UBS /opt/gk_app/logs/gw-ubs/nts.gw.ubs.log
# 10.2.2.61 GK_GW_CNX /opt/gk_app/logs/gw-cnx/dealing.cp.cnx.log
# 10.2.2.61 GK_GW_RBS /opt/gk_app/logs/gw-rbs/dealing.cp.rbs.log
# 10.2.2.61 GK_GW_FXJP /opt/gk_app/logs/gw-fxjp/nts.gw.fxjp.log
# 10.2.2.58 GK_GW_HSBC /opt/gk_app/logs/hsbc/dealing.cp.hsbc.log
# 10.2.2.58 GK_GW_MSFX /opt/gk_app/logs/gw-msfx/nts.gw.msfx.log
# 10.2.2.35 /opt/gk_app/logs/hedgemng/dealing.hedgemng.log
