#$SERVER_LIST='./server_list.conf'
SERVER_IP=$1

RED='\e[0;31m'	# Red
GRE='\e[0;32m'	# Green
NOC='\e[0m' # No Color

#while read LINE
for IP_ADDR in `cat $SERVER_IP`
do
	DISK_USE=`ssh $IP_ADDR df -h | grep -w '/' | awk '{print $4}'`
	
	#ps ux | grep -w "$SERVICE -DconfigPath=" | grep -v 'grep' | awk -F '=' '{print $2}' | awk '{print $1}'
	RESULTS=`ssh $IP_ADDR ps ux | grep 'DprocessName=' | grep -v 'grep' | awk -F 'DprocessName=' '{print $2}' | awk '{print $1}' | grep -e "^$" -v`
	#RESULT=`ssh $IP_ADDR ps ux | grep -w "$SERVICE -DconfigPath=" | grep -v 'grep' | wc -l`
	#echo ${RESULTS[@]}
	if [ ${#RESULTS[@]} -ne 0 ]
	then
		for RESULT in ${RESULTS[@]}
		do
			#printf "%10s %20s %10s\n" "On:${GRE}$IP_ADDR${NOC}" "Service:${GRE}$RESULT${NOC}" "DiskUsed:${GRE}$DISK_USE${NOC}"
			S_PID=`ssh $IP_ADDR ps ux | grep 'DprocessName=' | grep -w "$RESULT" | awk '{print $2}'`
			echo -e "On:${GRE}"$IP_ADDR"${NOC} Service:${GRE}"$RESULT"${NOC} PID:${GRE}"$S_PID"${NOC} DiskUsed:${GRE}"$DISK_USE"${NOC}"
		done
	else
		#printf "%10s %20s %10s\n" "On:${RED}$IP_ADDR${NOC}" "Service:${RED}NO SERVICE AVAILABLE${NOC}" "DiskUsed:${GRE}$DISK_USE${NOC}"
		echo -e "On:${GRE}"$IP_ADDR"${NOC} Service:${RED}NO SERVICE RUNNING${NOC} DiskUsed:${GRE}"$DISK_USE"${NOC}"
	fi
done

