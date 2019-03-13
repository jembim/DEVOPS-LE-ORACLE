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

while read line
do
    wftfile=`echo $line`
    echo "WFLOAD $USER/$PASS 0 Y UPLOAD $wftfile" >> ~/EBSscripts/WFLOAD_cmd.sh
done<~/EBSscripts/wft-bundle.txt
~/EBSscripts/WFLOAD_cmd.sh

