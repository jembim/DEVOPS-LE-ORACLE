#!/bin/bash

while read line
do
	echo "@/home/applmgr/XXLE/12.0.0/sql/$line" >> ~/EBSscripts/APPS_cmd.txt
done<~/EBSscripts/bundle-apps.txt

OPTS=`getopt -o h:p: --long dbu2:,dbp2:,dbs: -n 'parse-option' -- "$@"`
#echo $OPTS
eval set -- "$OPTS"

while true; do
        case $1 in
                --dbu2 ) export DB_USER2=$2;shift 2;;
                --dbp2 ) export DB_PASS2=$2;shift 2;;
                --dbs  ) export DB_SERVICE_NAME=$2;shift 2;;
                -h ) export DB_HOST=$2;shift 2;;
                -p ) export DB_PORT=$2;shift 2;;
                -- ) shift; break ;;
        esac
done


apps_objects=$(cat ~/EBSscripts/APPS_cmd.txt)
user=${DB_USER2}
pass=${DB_PASS2}
host=${DB_HOST}
port=${DB_PORT}
service=${DB_SERVICE_NAME}

cat << EOF >> ~/EBSscripts/APPS_cmd.sh
sqlplus ${DB_USER2}/${DB_PASS2}@${DB_HOST}:${DB_PORT}/${DB_SERVICE_NAME} << eof
spool appUpdate.log
$apps_objects
spool off
eof
EOF

sh ~/EBSscripts/APPS_cmd.sh
