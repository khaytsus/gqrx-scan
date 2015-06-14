#!/bin/sh

# Go through glob of files and play each one.  After, you can review the file again,
# skip it, mark it priority, or delete it.  Skipping or marking priority moves the
# file from the path passed in on the command line to the mp3path defined below.

IFS=" "
glob=$*
files=$#
counter=0

# Set paths to move files to
path=/home/wally/baofeng/Recordings
mp3path=${path}/mp3/

function play
{
	echo
	mplayer "$1"
}

for each in $glob
do
	key=""
	if [ -e "$each" ]; then
		play "$each"
		while [[ "$key" == "" ]]; do
			echo [${counter}/${files}] $each
			((counter+=1))
			echo -n "[r]eplay, [d]elete, [s]kip, [p]riority: "
			read -s -N 1 key
			case $key in
				d)
					rm "$each"
					;;
				r)
					play "$each"
					key=""
					;;
				s)
					echo
					echo "Skipping and storing file"
					mv "$each" "${mp3path}/"
					;;
				p)
					echo
					echo "Marking as priority"
					dirname=`dirname "$each"`
					basename=`basename "$each" .mp3`
					mv "$each" "${mp3path}/${basename}-priority.mp3"
					;;
				*)
					echo 
					echo "Unknown command:  $key"
					key=""
					;;
			esac
		done
	fi
done

echo
