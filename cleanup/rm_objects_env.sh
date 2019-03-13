#!/bin/bash

OLD_OBJECTS="/home/applmgr/XXLE"

if [ -d $OLD_OBJECTS ];
then
	echo "Old EBS objects existing"
	echo "Deleting objects..."
	rm -rf $OLD_OBJECTS
else
	echo "No existing EBS objects"
fi

exit
