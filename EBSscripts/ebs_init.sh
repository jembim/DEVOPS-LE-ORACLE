#!/bin/bash
#CHECK IF FNDLOAD_CMD.SH EXIST THEN RECREATE IT
if [ -f '~/EBSscripts/FNDLOAD_cmd.sh' ]
then
    rm -f ~/EBSscripts/FNDLOAD_cmd.sh
fi
touch ~/EBSscripts/FNDLOAD_cmd.sh
chmod 777 ~/EBSscripts/FNDLOAD_cmd.sh

#CHECK IF XDOLOAD_CMD0.SH EXIST THEN RECREATE IT
if [ -f '~/EBSscripts/XDOLOAD0_cmd.sh' ]
then
    rm -f ~/EBSscripts/XDOLOAD0_cmd.sh
fi
touch ~/EBSscripts/XDOLOAD0_cmd.sh
chmod 777 ~/EBSscripts/XDOLOAD0_cmd.sh

#CHECK IF XDOLOAD_CMD1.SH EXIST THEN RECREATE IT
if [ -f '~/EBSscripts/XDOLOAD1_cmd.sh' ]
then
    rm -f ~/EBSscripts/XDOLOAD1_cmd.sh
fi
touch ~/EBSscripts/XDOLOAD1_cmd.sh
chmod 777 ~/EBSscripts/XDOLOAD1_cmd.sh

#CHECK IF WFLOAD_CMD.SH EXIST THEN RECREATE IT
if [ -f '~/EBSscripts/WFLOAD_cmd.sh' ]
then
    rm -f ~/EBSscripts/WFLOAD_cmd.sh
fi
touch ~/EBSscripts/WFLOAD_cmd.sh
chmod 777 ~/EBSscripts/WFLOAD_cmd.sh

#CHECK IF APPS_CMD.SH EXIST THEN RECREATE IT
if [ -f '~/EBSscripts/APPS_cmd.sh' ]
then
    rm -f ~/EBSscripts/APPS_cmd.sh
fi
touch ~/EBSscripts/APPS_cmd.sh
chmod 777 ~/EBSscripts/APPS_cmd.sh

#CHECK IF APPS_CMD.TXT EXIST THEN RECREATE IT
if [ -f '~/EBSscripts/APPS_cmd.txt' ]
then
    rm -f ~/EBSscripts/APPS_cmd.txt
fi
touch ~/EBSscripts/APPS_cmd.txt
chmod 777 ~/EBSscripts/APPS_cmd.txt

#CHECK IF XXLE_CMD.SH EXIST THEN RECREATE IT
if [ -f '~/EBSscripts/XXLE_cmd.sh' ]
then
    rm -f ~/EBSscripts/XXLE_cmd.sh
fi
touch ~/EBSscripts/XXLE_cmd.sh
chmod 777 ~/EBSscripts/XXLE_cmd.sh

#CHECK IF XXLE_CMD.TXT EXIST THEN RECREATE IT
if [ -f '~/EBSscripts/XXLE_cmd.txt' ]
then
    rm -f ~/EBSscripts/XXLE_cmd.txt
fi
touch ~/EBSscripts/XXLE_cmd.txt
chmod 777 ~/EBSscripts/XXLE_cmd.txt

#CHECK IF XDO-BUNDLE.TXT EXISTS THEN RECREATE IT
if [ -f '~/EBSscripts/xdo-bundle.txt' ]
then
    rm -f ~/EBSscripts/xdo-bundle.txt
fi
touch ~/EBSscripts/xdo-bundle.txt
chmod 666 ~/EBSscripts/xdo-bundle.txt

#CHECK IF WFT-BUNDLE.TXT EXISTS THEN RECREATE IT
if [ -f '~/EBSscripts/wft-bundle.txt' ]
then
    rm -f ~/EBSscripts/wft-bundle.txt
fi
touch ~/EBSscripts/wft-bundle.txt
chmod 666 ~/EBSscripts/wft-bundle.txt

#BUNDLE ALL LATEST RTF and XML FILES
find ~/XXLE/12.0.0/reports/US/ -type f -name "*.rtf" -newermt "$stamp" >> ~/EBSscripts/xdo-bundle.txt
find ~/XXLE/12.0.0/reports/US/ -type f -name "*.xml" -newermt "$stamp" >> ~/EBSscripts/xdo-bundle.txt

#BUNDLE ALL LATEST WFT FILES
find ~/XXLE/12.0.0/bin -type f -name "*.wft" -newermt "$stamp" >> ~/EBSscripts/wft-bundle.txt

#BUNDLE DB OBJECTS FOR XXLE SCHEMA
sed -e '/APPS/,$d' ~/XXLE/12.0.0/sql/Readme.txt | sed '1d' | awk -F " " '{print $2}' > ~/EBSscripts/bundle-xxle.txt

#BUNDLE DB OBJECTS FOR APPS SCHEMA
sed -e '1,/APPS/d' ~/XXLE/12.0.0/sql/Readme.txt | awk -F " " '{print $2}' > ~/EBSscripts/bundle-apps.txt

OPTS=`getopt -o u: --long ct: -n 'parse-option' -- "$@"`

eval set -- "$OPTS"

while true; do
        case $1 in
                --ct ) export CTOP=$2;shift 2;; 
                -- ) shift; break ;;
        esac
done

#CHANGE FILE PERMISSIONS
chmod 744 ~/EBSscripts/*.txt
chmod 744 ~/XXLE/12.0.0/reports/US/*
chmod 744 ~/XXLE/12.0.0/sql/*
chmod 744 ~/XXLE/12.0.0/bin/*
cd ~/XXLE/12.0.0/bin/
cp -f -t ${CTOP} *.sh *.ctl *.prog
cd ${CTOP}
chmod 744 *.sh *.ctl *.prog

#CREATE SYMBOLIC LINK
sh ${CTOP}/le_ach_host_softlink.sh
sh ${CTOP}/le_file_transfer_softlink.sh 

echo $(date +%Y-%m-%d" "%H:%M:%S) >> ~/EBSscripts/update.log