#!/bin/sh

Max=0.0
path=/home/wally/baofeng/Recordings

mkdir -p ${path}/mp3
mkdir -p ${path}/empty

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
		if [[ $(echo "if (${amplitude} > ${Max}) 1 else 0" | bc) -eq 0 ]]; then
			rm $each
			((emptycounter+=1))
		else
			tagchannel ${namestart} ${timestamp} ${freq}
			echo "New Recording:  ${path}/mp3/${newname}.mp3"
			((counter+=1))
			lame --abr 56 --quiet $each "mp3/${newname}.mp3"
			rm $each
			list="${list} \"${path}/mp3/${newname}.mp3\""
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
