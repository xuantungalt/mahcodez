#!/bin/sh

prog_dir='/home/gfx/rate_diff_cal/'
#tac_file=$prog_dir'nts.gw.hotspot.log.2014-01-20'
tac_file=$prog_dir'hourly_tac_file.tmp'
#log_date=`date -d "1 hour ago" +"_%Y%m%d_%H.out"`
#time_one_hb=`date -d "1 hour ago" +"%Y-%m-%d %H:00:"`
#time_cur=`date +"%Y-%m-%d %H:00:"`
#log_file='/opt/gk_app/logs/gw-hotspot/nts.gw.hotspot.log'
#tac $log_file | sed -n "/$time_cur/,/$time_one_hb/p" | grep $indicator > $tac_file
indicator='35=W'

if [[ -z $1 ]]
then
	echo 'Using Default currency pair'
	currency_pairs=(
	'AUD/JPY' 'CAD/JPY' 'CHF/JPY' 'EUR/JPY' 'GBP/JPY' 'NZD/JPY'
	'USD/JPY' 'ZAR/JPY' 'AUD/USD' 'EUR/USD' 'GBP/USD' 'NZD/USD'
	'EUR/CHF' 'USD/CHF' 'USD/CAD' 'GBP/CHF' 'AUD/NZD' 'EUR/AUD'
	'EUR/NZD' 'GBP/AUD' 'XAU/USD' 'XAG/USD' 'AUD/CAD' 'AUD/CHF'
	'CAD/CHF' 'EUR/CAD' 'EUR/GBP' 'GBP/NZD' 'NOK/JPY' 'NZD/CAD'
	'NZD/CHF' 'SEK/JPY' 'EUR/ZAR' 'GBP/CAD' 'USD/NOK' 'USD/SEK'
	'USD/ZAR' )
else
	currency_pairs=$1
	echo 'Defined currency pair(s): '$currency_pairs
fi

if [[ -z $2 ]]
then
	log_date=`date -d "1 hour ago" +"_%Y%m%d_%H.out"`
else
	log_date=$2
fi

for c_pair in ${currency_pairs[@]}
do
ra_i=0
c_ar=()
        c_name=`echo $c_pair | awk -F '/' '{print $1$2}'`
        c_file=$prog_dir"result/HOTS_"$c_name"_"$log_date".out"
        t_file=$prog_dir"temp/HOTS_"$c_name".tmp"
#echo "tac $tac_file | grep $c_pair > $t_file"
        cat $tac_file | grep $c_pair > $t_file
        #echo "CALCULATING - "$c_pair" ---> "$c_file
        echo $c_pair >> $c_file
        IFS=$'\r\n' c_lines=($(cat $t_file))
#echo $c_name
#echo $c_file
#echo $t_file
        for l_line in ${c_lines[@]}
        do
#echo $l_line
                l_time=`echo $l_line | awk '{printf "At:"$1" "$2}'`
                f_value=`echo $l_line | awk -F '270=' '{printf $2}' | awk -F '271=' '{printf $1}' | sed 's/\x01//g'`
                l_value=`echo $l_line | awk -F '270=' '{printf $3}' | awk -F '271=' '{printf $1}' | sed 's/\x01//g'`
#echo "DEBUG F"$f_value" DEBUG"
#echo "DEBUG L"$l_value" DEBUG"
				if [ -z "$f_value" ]
				then
				f_value=0
				fi
				if [ -z "$l_value" ]
				then
				l_value=0
				fi
                cond_f=`echo $f_value | awk '{if ($1==0) {print "ZERO";} else print "LARGER";}'`
                cond_l=`echo $l_value | awk '{if ($1==0) {print "ZERO";} else print "LARGER";}'`
#echo "COND F - "$cond_f
#echo "COND L - "$cond_l
                                if [ "$cond_f" == "ZERO" ]
                                then
					#echo $l_time' First: '$f_value
                                        echo $l_time' First: '$f_value'/Last: '$l_value' ---> SKIP' >> $c_file
				elif [ "$cond_l" == "ZERO" ]
				then
					#echo $l_time' Last: '$l_value
					echo $l_time' First: '$f_value'/Last: '$l_value' ---> SKIP' >> $c_file
                                else
                                        c_value=`echo $l_value"|"$f_value | awk -F '|' '{ printf "%.5f\n", $1 - $2 }'`
                                        echo $l_time' First: '$f_value'/Last: '$l_value' ---> Rate Difference: '$c_value >> $c_file
                                        c_ar[$ra_i]=$c_value
                                        ra_i=`expr $ra_i + 1`
                                fi

        done

	echo "CALCULATING - "$c_pair" ---> "$c_file
        average_diff=0
        for c_r in ${c_ar[@]}
        do
                average_diff=`echo $average_diff'|'$c_r | awk -F '|' '{ printf "%.5f\n", $1 + $2 }'`
        done

        average_diff=`echo $average_diff'|'${#c_ar[@]} | awk -F '|' '{ printf "%.7f\n", $1/$2 }'`
        echo 'Average difference: '$average_diff >> $c_file
                echo 'Average difference: '$average_diff

done
