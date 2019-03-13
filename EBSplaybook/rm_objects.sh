#!/bin/bash

OLD_OBJECTS="/tmp/EBS_objects"

if [ -d $OLD_OBJECTS ];
then
	echo "Old EBS objects existing"
	echo "Deleting objects..."
	rm -rf $OLD_OBJECTS
else
	echo "No existing EBS objects"
fi

exit
