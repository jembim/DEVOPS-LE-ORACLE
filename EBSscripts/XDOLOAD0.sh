#!/bin/bash

OPTS=`getopt -o u: --long pw: -n 'parse-option' -- "$@"`

eval set -- "$OPTS"

while true; do
        case $1 in
                --pw ) export PASS=$2;shift 2;; 
                -u ) export USER=$2;shift 2;;
                -- ) shift; break ;;
        esac
done

for p in $(ls ~/XXLE/12.0.0/bin/*.ldt)
do
        if grep -q "CONCURRENT_PROGRAM_NAME" $p ; then
        lctdir="\$FND_TOP/patch/115/import"
        echo "FNDLOAD ${USER}/${PASS} 0 Y UPLOAD $lctdir/afcpprog.lct $p - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE" >> ~/EBSscripts/XDOLOAD0_cmd.sh
        elif grep -q "DATA_SOURCE_CODE" $p ; then
        lctdir="\$XDO_TOP/patch/115/import"
        echo "FNDLOAD ${USER}/${PASS} 0 Y UPLOAD $lctdir/xdotmpl.lct $p" >> ~/EBSscripts/XDOLOAD0_cmd.sh
        fi
done

~/EBSscripts/XDOLOAD0_cmd.sh