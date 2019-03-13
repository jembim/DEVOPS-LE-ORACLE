#!/bin/bash

SCRIPTS="/home/applmgr/EBSscripts"

if [ -d $SCRIPTS ];
then
	echo "Old Scripts exists"
	echo "Deleting scripts..."
	rm -rf $SCRIPTS
else
	echo "No existing scripts"
fi

exit

