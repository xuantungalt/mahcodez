#!/bin/sh

#SC_ACTIVEMQ            10.8.21.7
#DL_ACTIVEMQ            10.8.21.23
#DL_ACTIVEMQ_GW1        10.8.21.28
#DL_ACTIVEMQ_GW2        10.8.21.29
#WT_ACTIVEMQ            10.8.21.34

# GENERATE
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.7 list-queue > /home/tfx/check/10.8.21.7.queues
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.7 list-topic > /home/tfx/check/10.8.21.7.topics
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.23 list-queue > /home/tfx/check/10.8.21.23.queues
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.23 list-topic > /home/tfx/check/10.8.21.23.topics
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.28 list-queue > /home/tfx/check/10.8.21.28.queues
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.28 list-topic > /home/tfx/check/10.8.21.28.topics
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.29 list-queue > /home/tfx/check/10.8.21.29.queues
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.29 list-topic > /home/tfx/check/10.8.21.29.topics
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.34 list-queue > /home/tfx/check/10.8.21.34.queues
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.34 list-topic > /home/tfx/check/10.8.21.34.topics

# CHECK
#>/var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.7 /home/tfx/check/10.8.21.7.queues >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.7 /home/tfx/check/10.8.21.7.topics >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.23 /home/tfx/check/10.8.21.23.queues >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.23 /home/tfx/check/10.8.21.23.topics >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.28 /home/tfx/check/10.8.21.28.queues >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.28 /home/tfx/check/10.8.21.28.topics >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.29 /home/tfx/check/10.8.21.29.queues >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.29 /home/tfx/check/10.8.21.29.topics >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.34 /home/tfx/check/10.8.21.34.queues >> /var/www/monitors/amqcheck.log;
#/home/tfx/check/AMQ_Cheker.sh 10.8.21.34 /home/tfx/check/10.8.21.34.topics >> /var/www/monitors/amqcheck.log;

if [ $# -lt 2 ]
then
        echo "Usage: <script> <AMQ IP> <Queue/Topic List file>
If you don't have a List file yet, use this command to generate one.
<script> <AMQ IP> <list-queue|list-topic>"
        exit 1
fi

_SCRIPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

case $2 in
    list-queue)
        _AMQLINK="$1:8161/admin/queues.jsp"
        curl -s $_AMQLINK |sed -n '/table id="queue/,/<\/table>/p' |
        grep '<\/td>$' | grep -v '^<\/td>' |
        sed ':a;N;$!ba;s/\n<td>/ /g' | sed 's/<\/td>//g; s/<\/span>//g; s/<\/a>//g' | sort
        ;;
    list-topic)
        _AMQLINK="$1:8161/admin/topics.jsp"
        curl -s $_AMQLINK | sed -n '/table id="topic/,/<\/table>/p' |
        grep '<\/td>$\|<\/span>$' | grep -v '^<\/td>\|^<\/a>' |
        sed ':a;N;$!ba;s/\n<td>/ /g' | sed 's/<\/td>//g; s/<\/span>//g; s/<\/a>//g' |
        awk -F '<span>' '{print $NF}' | sort
        ;;
    *)
        if [ -f $2 ]
        then
            if [ -z $3 ]
            then
                [ $(cat $2 | grep "queue" | wc -l) -gt 0 ] && _AMQTYPE="queue"
                [ $(cat $2 | grep "topic" | wc -l) -gt 0 ] && _AMQTYPE="topic"
            else
                [ $(echo $3 | grep "queue" | wc -l) -gt 0 ] && _AMQTYPE="queue"
                [ $(echo $3 | grep "topic" | wc -l) -gt 0 ] && _AMQTYPE="topic"
            fi

                _CTIME=$(date +'%Y/%m/%d %H:%M:%S')
            if [ $_AMQTYPE == "queue" ]
            then
                $0 "$1" "list-queue" > "$_SCRIPDIR/$1.current_queues.txt"
                _COMPARETO="$_SCRIPDIR/$1.current_queues.txt"
            else
                $0 "$1" "list-topic" > "$_SCRIPDIR/$1.current_topics.txt"
                _COMPARETO="$_SCRIPDIR/$1.current_topics.txt"
            fi

            IFS=$'\r\n'
            [ $(cat $2 | wc -l) -ne $(cat $_COMPARETO | wc -l) ] && echo "[$1] - [ERROR ] - Mismatched number of defined $_AMQTYPE(s) $(cat $_COMPARETO | wc -l) / $(cat $2 | wc -l) current/defined"
            for ALINE in $( cat $2 )
            do
                _AMQ_NAME=$(echo $ALINE | awk '{print $1}')
                if [ $_AMQTYPE == "queue" ]
                then
                    _AMQ_PEND=$(echo $ALINE | awk '{print $2}')
                    _AMQ_CONS=$(echo $ALINE | awk '{print $3}')
                    _CUR_PEND=$(cat $_COMPARETO | grep "^$_AMQ_NAME " | awk '{print $2}')
                    _CUR_CONS=$(cat $_COMPARETO | grep "^$_AMQ_NAME " | awk '{print $3}')
                    if [ "$_AMQ_PEND" != "$_CUR_PEND" ] || [ "$_AMQ_CONS" != "$_CUR_CONS" ]
                    then
                        echo "[$1] - [ERROR ] - $_AMQ_NAME Queue Pending $_CUR_PEND/$_AMQ_PEND Consumers $_CUR_CONS/$_AMQ_CONS"
                    else
                        echo "[$1] - [NORMAL] - $_AMQ_NAME Queue Pending $_CUR_PEND/$_AMQ_PEND Consumers $_CUR_CONS/$_AMQ_CONS"
                    fi
                else
                    _AMQ_CONS=$(echo $ALINE | awk '{print $2}')
                    _CUR_CONS=$(cat $_COMPARETO | grep "^$_AMQ_NAME " | awk '{print $2}')
                    if [ "$_AMQ_CONS" != "$_CUR_CONS" ]
                    then
                        echo "[$1] - [ERROR ] - $_AMQ_NAME Topic Consumers $_CUR_CONS/$_AMQ_CONS"
                    else
                        echo "[$1] - [NORMAL] - $_AMQ_NAME Topic Consumers $_CUR_CONS/$_AMQ_CONS"
                    fi
                fi
            done
        else
            echo "ERROR - Queue/Topic List file: \"$2\" Does not exists"
            exit 1
        fi
        ;;
esac

unset IFS