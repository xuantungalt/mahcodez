#!/bin/sh

#cd /opt/55/Hotspot/script/
prog_dir="/home/gfx/rate_diff_cal"

tac_file="$prog_dir/hourly_tac_file.tmp"
time_ar=`cat $prog_dir/time.txt`

if [ -z $1 ]
then
        echo 'Using Default log file'
        log_file='/opt/gk_app/logs/gw-hotspot/nts.gw.hotspot.log'
else
        log_file=$1
        echo 'Log file: '$log_file
fi

if [ -z $2 ]
then
	echo 'Using default Date'
	date_yd=`date -d '-1 day' +'%Y-%m-%d'`
else
	date_yd=$2
fi

echo "Calculating for Date: "$date_yd

for t_arg in ${time_ar[@]}
do
#tac_file="/opt/55/Hotspot/script/hourly_tac_file.tmp"
time_one_hb=`echo $t_arg | awk -F '|' '{printf $1}'`
time_cur=`echo $t_arg | awk -F '|' '{printf $2}'`

t_be=`echo $time_one_hb | awk -F ':' '{print $1}'`
t_ed=`echo $time_cur | awk -F ':' '{print $1}'`		
time_mark=$t_be'-'$t_ed
		
time_one_hb=`echo $date_yd' '$time_one_hb`
time_cur=`echo $date_yd' '$time_cur`
echo 'Using Defined time range From: '$time_one_hb' / To: '$time_cur

indicator='35=W'
cat $log_file | sed -n "/$time_one_hb/,/$time_cur/p" | grep $indicator > $tac_file

        sh $prog_dir/rate_diff_cal_v1.1.sh 'AUD/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'CAD/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'CHF/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'EUR/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'GBP/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'NZD/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'USD/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'ZAR/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'AUD/USD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'EUR/USD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'GBP/USD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'NZD/USD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'EUR/CHF' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'USD/CHF' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'USD/CAD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'GBP/CHF' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'AUD/NZD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'EUR/AUD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'EUR/NZD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'GBP/AUD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'XAU/USD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'XAG/USD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'AUD/CAD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'AUD/CHF' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'CAD/CHF' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'EUR/CAD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'EUR/GBP' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'GBP/NZD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'NOK/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'NZD/CAD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'NZD/CHF' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'SEK/JPY' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'EUR/ZAR' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'GBP/CAD' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'USD/NOK' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'USD/SEK' $date_yd'_'$time_mark &
        sh $prog_dir/rate_diff_cal_v1.1.sh 'USD/ZAR' $date_yd'_'$time_mark &

running_check=`ps ux | grep "rate_diff_cal_v1.1.sh" | grep -v "grep" | wc -l`
while [ $running_check -ne 0 ]
do
	echo $running_check" Pair(s) Still calculating"
	sleep 5m
	running_check=`ps ux | grep "rate_diff_cal_v1.1.sh" | grep -v "grep" | wc -l`
done
echo "DONE!"

done
