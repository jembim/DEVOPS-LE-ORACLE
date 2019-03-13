#!/bin/bash
#============XDO UPLOAD==================

OPTS=`getopt -o h:p:u: --long dbs:,pw: -n 'parse-option' -- "$@"`

eval set -- "$OPTS"

while true; do
        case $1 in
        --pw ) export PASS=$2;shift 2;;
        --dbs ) export DB_SERVICE_NAME=$2;shift 2;;
		-u ) export USER=$2;shift 2;;
        -h ) export DB_HOST=$2;shift 2;;
        -p ) export DB_PORT=$2;shift 2;;
        -- ) shift; break ;;
        esac
done

for p in $(ls ~/XXLE/12.0.0/bin/*.ldt)
do
        if grep -q "DATA_SOURCE_CODE" $p ; then
        lobcode=`cat $p | grep "BEGIN" | head -n 1 | awk '{print $4}' | awk -F '"' '{print $2}'`
        fi
done


host=${DB_HOST}
port=${DB_PORT}
srvc=${DB_SERVICE_NAME}


while read line
do
    filetype=`echo $line | awk -F "/" '{print $8}' | awk -F "." '{print $2}'`
    file=`echo $line`
    filename=`echo $line | awk -F "/" '{print $8}' | awk -F "." '{print $1}'`

    case ${filetype} in
        rtf)
            echo "java oracle.apps.xdo.oa.util.XDOLoader UPLOAD -DB_USERNAME ${USER} -DB_PASSWORD ${PASS} -JDBC_CONNECTION '(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=$host)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$srvc)))' -LOB_TYPE TEMPLATE -APPS_SHORT_NAME XXLE -LOB_CODE $lobcode -LANGUAGE en -XDO_FILE_TYPE RTF -CUSTOM_MODE FORCE -FILE_NAME $file -APPS_SHORT_NAME XXLE -NLS_LANG en -LOG_FILE ./$filename.log" >> ~/EBSscripts/XDOLOAD1_cmd.sh
            ;;
        xml)
            echo "java oracle.apps.xdo.oa.util.XDOLoader UPLOAD -DB_USERNAME ${USER} -DB_PASSWORD ${PASS} -JDBC_CONNECTION '(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=$host)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$srvc)))' -LOB_TYPE DATA_TEMPLATE -APPS_SHORT_NAME XXLE -LOB_CODE $lobcode -LANGUAGE en -XDO_FILE_TYPE XML -CUSTOM_MODE FORCE -FILE_NAME $file -APPS_SHORT_NAME XXLE -NLS_LANG en -LOG_FILE ./$filename.log" >> ~/EBSscripts/XDOLOAD1_cmd.sh
            ;;
    esac
done<~/EBSscripts/xdo-bundle.txt
~/EBSscripts/XDOLOAD1_cmd.sh
