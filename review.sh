#!/bin/sh

# Go through glob of files and play each one.  After, you can review the file again,
# skip it, or delete it

IFS=" "
glob=$*
files=$#
counter=0

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
					echo "Skipping"
					;;
				p)
					echo
					echo "Marking as priority"
					dirname=`dirname "$each"`
					basename=`basename "$each" .mp3`
					mv "$each" "${dirname}/${basename}-priority.mp3"
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
