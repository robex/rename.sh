#!/bin/bash

# Rename all the files specified in a directory to a sequential order.
# WARNING: If the files are already named sequentially, backups will
# be created with a tilde (~) appended at the end.
# A workaround for this is to run rename.sh with another value for
# the ndigits and then run it again with the original.
#
# /robex/ - 2018

#no arguments
usage() {
	echo "usage: ./rename.sh -npd dir"
	echo "args:"
	printf "\tdir: directory to rename files inside of\n"
	printf "\t-n: ndigits (optional), number of digits in the format (ex: 0001.gif),\n\t    USE TWO DIGITS. default = 04\n"
	printf "\t-p: prefix (optional), add a prefix before the digits\n"
	printf "\t-d: dry-run (optional), show the changes, dont execute\n"
	exit 1
}

NDIGITS="04"
PREFIX=""
DRYRUN=0

while getopts ":n:p:hd" opt; do
	case $opt in
		n)
			NDIGITS=$OPTARG
			;;
		p)
			PREFIX=$OPTARG
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument."
			exit 1
			;;
		h)
			usage
			;;
		d)
			DRYRUN=1
			;;
	esac
done
shift $((OPTIND - 1))

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

# add your extensions here if necessary
exts=(".gif" ".png" ".jpg" ".webm" ".mp4")
if [ $DRYRUN -eq 1 ]
then
	for i in "${exts[@]}"; do
		find $1 -name "*$i" -o -name "*$i~" | cat -n | while read n f; do printf "%30s renamed to %s/%s%${NDIGITS}d$i\n" "$f" "$1" "$PREFIX" $n; done
	done
else
	#confirm
	read -p "Are you sure? " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		for i in "${exts[@]}"; do
			find $1 -name "*$i" -o -name "*$i~" | cat -n | while read n f; do mv -b "$f" `printf "%s/%s%${NDIGITS}d$i" $1 "$PREFIX" $n`; done
		done
	fi
fi
