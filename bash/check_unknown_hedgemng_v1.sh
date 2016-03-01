#!/bin/bash
_LINE=50000
_mod_list="HedgeMNG|/opt/gk_app/logs/hedgemng/dealing.hedgemng.log"
ux=1
while [ $ux -gt 0 ]
do
	> "/var/www/html/monitors/symbol/unknown_HEDGEMNG_result.tmp"
	modname=`echo $_mod_list | awk -F '|' '{print $1}'`
	_now_date=`date "+%Y-%m-%d %H:%M"`
	_date1=`date -d"1 min ago" +"%Y-%m-%d %H:%M"`
	_date2=`date -d"2 min ago" +"%Y-%m-%d %H:%M"`
	_date3=`date -d"3 min ago" +"%Y-%m-%d %H:%M"`
	_date4=`date -d"4 min ago" +"%Y-%m-%d %H:%M"`
	_keyword="TimeOut:"
	modlog=`echo $_mod_list | awk -F'|' '{print $2}'`

	result=( $( ssh 10.2.2.35 tail -n $_LINE $modlog | grep "$_now_date\|$_date1\|$_date2\|$_date3\|$_date4" | grep -wi "$_keyword" ) )
	check_c=${#result[@]}
	echo $check_c
	if [ $check_c -ne 0 ]
	then
		for line in ${result[@]}
		do
			echo $line
			echo $line >> /var/www/html/monitors/symbol/unknown_HEDGEMNG_result.tmp
		done
	else
		echo "Unknown-Order on Dealing-Web: None"
		echo "Unknown-Order on Dealing-Web: None" > /var/www/html/monitors/symbol/unknown_HEDGEMNG_result.tmp
	fi
#echo "COMPLETE!"
sleep 10
done
