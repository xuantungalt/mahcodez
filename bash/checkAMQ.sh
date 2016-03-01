#!/bin/bash
ipaddr=$1
current_time=`date +"%H:%M:%S"`
config_queue="/opt/tool/$ipaddr.checkAMQ_queue.conf"
config_topics="/opt/tool/$ipaddr.checkAMQ_topic.conf"
topic_error=0
queue_error=0
check_queue(){
  cmd="/usr/bin/curl http://$ipaddr:8161/admin/queues.jsp -s"
  vlist=`$cmd |grep "$1</a>" -A4|sed ':a;N;s/\n/;/;ba;'|sed '1,$s/<td>//g'|sed '1,$s/<\/td>//g'`
  npdc=`echo $vlist |awk -F";" '{print $2}'`
  nofc=`echo $vlist |awk -F";" '{print $3}'`
  if [ $npdc -ne $2 ] || [ $nofc -ne $3 ]
  then
  echo -e "IP:$ipaddr|At:$current_time|Name:$1|STATUS:CRITICAL|Current:PendingQueue:$npdc|Consumer:$nofc|TrueValue:PendingQueue:$2|Consumer:$3"
  else
  echo -e "IP:$ipaddr|At:$current_time|Name:$1|STATUS:NORMAL"
  fi
}
check_topic(){
  cmd1="/usr/bin/curl http://$ipaddr:8161/admin/topics.jsp -s"
  vlist1=`$cmd1 |grep "$1</a>" -A4|sed ':a;N;s/\n/;/;ba;'|sed '1,$s/<td>//g'|sed '1,$s/<\/td>//g'`
  npdc1=`echo $vlist1 |awk -F";" '{print $2}'`
  if [ $npdc1 -ne $2 ]
  then
  echo -e "IP:$ipaddr|At:$current_time|Name:$1|STATUS:CRITICAL|Current:Consumer:$npdc1|TrueValue:Consumer:$2"
  else
  echo -e "IP:$ipaddr|At:$current_time|Name:$1|STATUS:NORMAL"
  fi
}
	while read list
	do
		p1=`echo $list|awk '{print $1}'`
		p2=`echo $list|awk '{print $2}'`
		p3=`echo $list|awk '{print $3}'`
		check_queue $p1 $p2 $p3
	done <$config_queue

	while read list
	do
  		a1=`echo $list|awk '{print $1}'`
  		a2=`echo $list|awk '{print $2}'`
		check_topic $a1 $a2 
	done <$config_topics
