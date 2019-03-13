#!/bin/bash
#============FND UPLOAD==================

cat << EOF >> ~/EBSscripts/FNDLOAD_cmd.sh
#!/bin/bash

OPTS=\`getopt -o u: --long pw: -n 'parse-option' -- "\$@"\`

eval set -- "\$OPTS"

while true; do
        case \$1 in
                --pw ) export PASS=\$2;shift 2;; 
                -u ) export USER=\$2;shift 2;;
                -- ) shift; break ;;
        esac
done

EOF

generateScript(){

    if [ $type == "0" ]
    then
        echo "FNDLOAD ${USER}/${PASS} 0 Y UPLOAD $lctdir/$lctfile $ldtfile UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE" >> ~/EBSscripts/FNDLOAD_cmd.sh
    elif [ $type == "1" ]
    then
        echo "FNDLOAD ${USER}/${PASS} 0 Y UPLOAD $lctdir/$lctfile $ldtfile - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE" >> ~/EBSscripts/FNDLOAD_cmd.sh
    elif [ $type == "2" ]
    then
        echo "FNDLOAD ${USER}/${PASS} 0 Y UPLOAD $lctdir/$lctfile $ldtfile CUSTOM_MODE=FORCE" >> ~/EBSscripts/FNDLOAD_cmd.sh
    elif [ $type == "3" ]
    then
        echo "FNDLOAD ${USER}/${PASS} 0 Y UPLOAD $lctdir/$lctfile $ldtfile" >> ~/EBSscripts/FNDLOAD_cmd.sh
    fi
}

OPTS=`getopt -o u: --long pw: -n 'parse-option' -- "$@"`

eval set -- "$OPTS"

while true; do
        case $1 in
                --pw ) export PASS=$2;shift 2;; 
                -u ) export USER=$2;shift 2;;
                -- ) shift; break ;;
        esac
done

lctdir="\$FND_TOP/patch/115/import"
ldtdir="~/XXLE/12.0.0/bin"

for p in $(ls ~/XXLE/12.0.0/bin/*.ldt)
do

   if grep -q "LOOKUP_TYPE" $p ; then
   		ldtfile="$p"
   		type="0"
   		lctfile=aflvmlu.lct
   		generateScript
   elif grep -q "CONCURRENT_PROGRAM_NAME" $p ; then
   		ldtfile="$p"
      type="1"
      lctfile=afcpprog.lct
	    generateScript
   elif grep -q "PROFILE_NAME" $p ; then
   		ldtfile="$p"
	    type="1"
	    lctfile=afscprof.lct
	    generateScript
   elif grep -q "REQUEST_SET_NAME" $p ; then
   		ldtfile="$p"
   		type="0"
   		lctfile=afcprset.lct
	    generateScript
   elif grep -q "MESSAGE_NAME" $p ; then
   		ldtfile="$p"
   		type="0"
	    lctfile=afmdmsg.lct
	    generateScript
   elif grep -q "FORM_NAME" $p ; then
   		ldtfile="$p"
   		type="1"
	    lctfile=afsload.lct
	    generateScript
   elif grep -q "FUNCTION_NAME" $p ; then
   		ldtfile="$p"
   		type="1"
      lctfile=afsload.lct
      generateScript
   elif grep -q "ALERT_NAME" $p ; then
   		ldtfile="$p"
   		type="2"
   		lctdir="\$ALR_TOP/patch/115/import"
   		lctfile=alr.lct
   		generateScript
   elif grep -q "FLEX_VALUE_SET_NAME" $p ; then
   		ldtfile="$p"
   		type="1"
   		lctfile=afffload.lct
   		generateScript
   elif grep -q "DATA_SOURCE_CODE" $p ; then
   		ldtfile="$p"
   		type="3"
   		lctdir="\$XDO_TOP/patch/115/import"
   		lctfile=xdotmpl.lct
   		generateScript
   fi
done

#DEPLOY
~/EBSscripts/FNDLOAD_cmd.sh -u ${USER} --pw=${PASS}