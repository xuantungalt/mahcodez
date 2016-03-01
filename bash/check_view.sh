#!/bin/bash
#Today
DATE=`date +%Y%m%d`;
DATE_TIME=`date +"%Y%m%d %H:%M:%S"`
SCRDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SAVEDR="$SCRDIR/db_views"
DBHOST_S="10.8.20.37|trsbase
10.8.20.38|trsbase"
DBUSER='root'
DBPASS='trsPdba'
mysql_bin="/opt/mysql/bin"

SENDER="from:tung.nguyen.xuan@nextop.asia"
RECIPIENTS="to:thang.tran.dai@nextop.asia,om-gkg@nextop.asia"

for DBHOST_A in ${DBHOST_S[@]}
do
        unset DBIPAD
        unset DBNAME
        DBIPAD=$(echo $DBHOST_A | awk -F '|' '{print $1}')
        DBNAME=$(echo $DBHOST_A | awk -F '|' '{print $2}')
        > "$SAVEDR/views.sql.$DATE.DB.$DBIPAD.$DBNAME"
        QUERY="select table_name from information_schema.tables where table_schema='$DBNAME' and table_type='VIEW';"
        VIEWS=$($mysql_bin/mysql -h$DBIPAD -u$DBUSER -p$DBPASS --skip-column-names --batch -e "$QUERY" | grep -v '^Logging to file')
        #echo $VIEWS; exit 1
        if [ -z "$VIEWS" ]
        then
                echo "[FAILED]: $QUERY"
        else
                $mysql_bin/mysqldump -h$DBIPAD -u$DBUSER -p$DBPASS --skip-comments --routines $DBNAME ${VIEWS[@]} >> "$SAVEDR/views.sql.$DATE.DB.$DBIPAD.$DBNAME"
        fi
done

> "$SAVEDR/diff.$DATE.DOV"
> "$SAVEDR/diff.$DATE.mail"

find $SAVEDR -name 'views.*' | xargs diff >> "$SAVEDR/diff.$DATE.DOV"
total_diff=`wc -l "$SAVEDR/diff.$DATE.DOV" | awk '{print $1}'`;

if [ $total_diff -gt 0 ]
then
    echo "[KO] DIFF: $total_diff"
    echo "subject:[TRS][OM][ERROR] Report view of DB [$DATE_TIME]" >> "$SAVEDR/diff.$DATE.mail"
    echo "DB Difference(s):" >> "$SAVEDR/diff.$DATE.mail"
    cat "$SAVEDR/diff.$DATE.DOV" >> "$SAVEDR/diff.$DATE.mail"
    exit 1
else
    echo "[OK] DIFF: $total_diff"
    echo "subject:[TRS][OM][INFO] Report view of DB [$DATE_TIME]" >> "$SAVEDR/diff.$DATE.mail"
    echo "The two DB: $DBHOST_1 and $DBHOST_2 are completely in sync (NO DIFFERENCE)" >> "$SAVEDR/diff.$DATE.mail"
    exit 0
fi
#/usr/sbin/sendmail -t < ~/db_views/views.sql.$DATE.mail