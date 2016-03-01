De_o=0
En_o=0
result_log="/home/gfx/check/logs/check_cp_rate_v2.logs"
while true ; do
        curl http://10.2.2.151:8161/admin/topics.jsp > ActiveMQ.html
        curl http://10.2.2.152:8161/admin/topics.jsp > ActiveMQ2.html

        grep topic.FxGwCpRateBOA\<\/a\> -C 3 ActiveMQ.html   > RateBOA
        grep topic.FxGwCpRateBARX\<\/a\> -C 3 ActiveMQ.html  > RateBARX
        grep topic.FxGwCpRateCiti\<\/a\> -C 3 ActiveMQ.html  > RateCiti
	grep topic.FxGwCpRateCiti2\<\/a\> -C 3 ActiveMQ.html  > RateCiti2
        grep topic.FxGwCpRateCNX\<\/a\> -C 3 ActiveMQ.html   > RateCNX
        grep topic.FxGwCpRateHotspot\<\/a\> -C 3 ActiveMQ.html  > RateHotspot
        grep topic.FxGwCpRateHSBC\<\/a\> -C 3 ActiveMQ.html  > RateHSBC
        grep topic.FxGwCpRateUBS\<\/a\> -C 3 ActiveMQ.html   > RateUBS
        grep topic.FxGwCpRateFXCM\<\/a\> -C 3 ActiveMQ.html  > RateFXCM
        grep topic.FxGwCpRateDB\<\/a\> -C 3 ActiveMQ.html  > RateDB
        grep topic.FxGwCpRateGwbtmu\<\/a\> -C 3 ActiveMQ.html  > RateBTMU
        grep topic.FxGwCpRateBNP\<\/a\> -C 3 ActiveMQ.html  > RateBNP

        grep topic.FxBestCpRate\<\/a\> -C 3 ActiveMQ2.html  > BestCpRate
        grep topic.FxBestHedgeRate\<\/a\> -C 3 ActiveMQ2.html  > BestHedgeRate


GW_LOGS="RateBOA RateBARX RateCiti RateCiti2 RateCNX RateHotspot RateHSBC RateUBS RateFXCM RateDB RateBTMU RateBNP BestCpRate BestHedgeRate"
for GW_LOG in $GW_LOGS
	do
	#echo $GW_LOG
	De_n=`tail -1 $GW_LOG | grep -o -E '[0-9]+'`
	En_n=`awk 'NR==6' $GW_LOG | grep -o -E '[0-9]+'`
	if [ $De_n -le  $De_o ] || [ $En_n -le $En_o ]
	then
		echo -e "`date`  \033[1;31;40m  ERROR   Check $GW_LOG imidiately \033[0m\n " >> $result_log
	else
		echo "`date`    INFO    $GW_LOG Ok : $En_n   $De_n" >> $result_log
		De_o=$De_n
		En_o=$En_n
	fi
	De_o=0
	En_o=0
done
echo '#########################################################################' >> $result_log
sleep 10
done
