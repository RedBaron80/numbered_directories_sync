#!/bin/bash

function copy_dir {
	echo "copying $1"
	cp $1 $2 -r
	
}

function sync_dir {
	echo "sincronizing $1"
	rsync -az $1 $2;
}

##################################################################################
cd $1
edir=0
isnumber_regex='^[0-9]+$'
for file in *; do
	if [[ $file =~ $isnumber_regex ]]  && [ -d $file ]
	then
		# if directory exists and it is a number (image directory)
		if [ -d "$2/$file" ] ; then
			# The lastest existing directory is kept for sync it later
			if [ $edir -lt $file ]; then				
				edir=$file
			fi
		else
			# Copying the unexisting directory at the destiny
			copy_dir $file $2
		fi
	elif ! [ "$file" == "temp" ]
	then
		# Syncing the other directories (avatars, logs...)
		sync_dir $file $2;
	fi
done
#syncing the last directory
sync_dir $edir $2
echo "Done!"

