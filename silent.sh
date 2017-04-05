#!/bin/sh

# Script which will find files in the specified directory and discard those
# which are determined to be empty files and the rest are moved into the
# review directory.  The files which are queued for review are passed into
# the review script.

Max=0.0
MinLength=7
path=/home/wally/baofeng/Recordings

reviewpath=${path}/mp3/review

mkdir -p $reviewpath

# Set up variables for reviewing the files after converting them
review=/home/wally/bin/gqrx-scan/review.sh
list=""
counter=0
emptycounter=0

newname=""
channelfilepath=/home/wally/.config/gqrx/bookmarks.csv

# Add channel name to filename
function tagchannel()
{
	sep=""
	channel=""
	namestart=$1
	timestamp=$2
	freq=$3
echo "namestart: $namestart $timestamp $freq"
	channel=`grep $freq $channelfilepath | cut -f 2 -d ';'`
	channel=${channel// /}
	if [ "$channel" != "" ]; then
		sep="_"
	fi
	newname=${namestart}_${timestamp}_${freq}${sep}${channel}
}

cd $path

for each in *.wav
do
	if [ -e "$each" ]; then

		# Build a new name for the file based on timestamp
		base=`basename $each .wav`
		namestart=`echo $base | cut -f 1,2 -d "_"`
		timestamp=`stat $each | grep Modify | cut -f 3 -d " " | cut -f -1 -d "." | sed -e 's/://g'`
		freq=`echo $base | cut -f 4 -d "_"`

		# Test if the file is empty, if so, mv to empty, otherwise, encode to mp3
		amplitude=$(sox "$each" -n stat 2>&1 | grep "Maximum amplitude" | cut -d ":" -f 2 | sed 's/ //g')
        length=$(sox "$each" -n stat 2>&1 | grep "Length" | cut -d ":" -f 2 | sed 's/ //g')
echo "file: $each"
		if [[ $(echo "if (${amplitude} > ${Max}) 1 else 0" | bc) -eq 0 ]] || 
            [[ $(echo "if (${length} > ${MinLength}) 1 else 0" | bc) -eq 0 ]]; then
            #echo "Deleting file $each (${amplitude} ${length}"
            rm $each
            ((emptycounter+=1))
            #statements
        else
			tagchannel ${namestart} ${timestamp} ${freq}
			echo "New Recording (${amplitude} ${length}):  ${reviewpath}/${newname}.mp3"
			((counter+=1))
			lame --abr 56 --quiet $each "${reviewpath}/${newname}.mp3"
			rm $each
			list="${list} \"${reviewpath}/${newname}.mp3\""
		fi
	fi
done

echo ""
echo "Found $counter files to review ($emptycounter empty files)"
echo ""

# Make a simple script to review the files
if [ "$list" != "" ]; then
	echo "${review} ${list}" >/tmp/review.sh
	source /tmp/review.sh
fi
