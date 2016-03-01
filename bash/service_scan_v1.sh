#$SERVER_LIST='./server_list.conf'
SERVER_LIST=$1

RED='\e[0;31m'	# Red
GRE='\e[0;32m'	# Green
NOC='\e[0m' # No Color

#while read LINE
for LINE in `cat $SERVER_LIST`
do
	IP_ADDR=`echo $LINE | awk -F '|' '{print $1}'`
	SERVICE=`echo $LINE | awk -F '|' '{print $2}'`
	DISK_USE=`ssh $IP_ADDR df -h | grep -w '/' | awk '{print $4}'`
	
	#ps ux | grep -w "$SERVICE -DconfigPath=" | grep -v 'grep' | awk -F '=' '{print $2}' | awk '{print $1}'
	RESULT=`ssh $IP_ADDR ps ux | grep -w "$SERVICE" | grep -v 'grep' | awk -F 'DprocessName=' '{print $2}' | awk '{print $1}'`
	#echo 'IP: '$IP_ADDR' ---> '$RESULT
	#RESULT=`ssh $IP_ADDR ps ux | grep -w "$SERVICE -DconfigPath=" | grep -v 'grep' | wc -l`
	if [ $RESULT ] && [ $RESULT == $SERVICE ]
		then
		S_PID=`ssh $IP_ADDR ps ux | grep 'DprocessName=' | grep -w "$RESULT" | awk '{print $2}'`
		echo -e "On:${GRE}"$IP_ADDR"${NOC} Service:${GRE}"$RESULT"${NOC} Status:${GRE}RUNNING${NOC} PID:${GRE}"$S_PID"${NOC} DiskUsed:${GRE}"$DISK_USE"${NOC}"
		#echo -e "On:${GRE}"$IP_ADDR"${NOC} Service:${GRE}"$RESULT"${NOC} Status:${GRE}RUNNING${NOC} DiskUsed:${GRE}"$DISK_USE"${NOC}"
		else
		echo -e "On:${RED}"$IP_ADDR"${NOC} Service:${RED}"$SERVICE"${NOC} Status:${RED}MISSING${NOC} DiskUsed:${GRE}"$DISK_USE"${NOC}"
	fi
done
