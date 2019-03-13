#!/bin/bash

while read line
do
	echo "@/home/applmgr/XXLE/12.0.0/sql/$line" >> ~/EBSscripts/XXLE_cmd.txt
done<~/EBSscripts/bundle-xxle.txt

OPTS=`getopt -o h:p: --long dbu1:,dbp1:,dbs: -n 'parse-option' -- "$@"`
#echo $OPTS
eval set -- "$OPTS"

while true; do
        case $1 in
                --dbu1 ) export DB_USER1=$2;shift 2;;
                --dbp1 ) export DB_PASS1=$2;shift 2;;
                --dbs  ) export DB_SERVICE_NAME=$2;shift 2;;
                -h ) export DB_HOST=$2;shift 2;;
                -p ) export DB_PORT=$2;shift 2;;
                -- ) shift; break ;;
        esac
done

xxle_objects=$(cat ~/EBSscripts/XXLE_cmd.txt)
user=${DB_USER1}
pass=${DB_PASS1}
host=${DB_HOST}
port=${DB_PORT}
service=${DB_SERVICE_NAME}

cat << EOF >> ~/EBSscripts/XXLE_cmd.sh
sqlplus ${DB_USER1}/${DB_PASS1}@${DB_HOST}:${DB_PORT}/${DB_SERVICE_NAME} << eof
spool dbUpdate.log
$xxle_objects
spool off
exit
eof
EOF

sh ~/EBSscripts/XXLE_cmd.sh

