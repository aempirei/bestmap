#!/bin/bash

if [ ! -f etc/config ] || [ ! -f bipartite.pl ]; then
	echo
	echo $0 is written in a manner that requires running from within its own directory.
	echo
	exit
fi

source etc/config

if [ ! -f "$1" ] || [ ! -f "$2" ]; then
	echo
	echo usage: $0 filelist1 filelist2
	echo
	echo filelist1 and filelist2 should be lists of relative paths to files
	echo for comparison and mapping. each list should be of identical size,
	echo but this is not necessary.
	echo
	exit
fi

sz=`wc -l < "$1"`
sig=`basename "$1"`'+'`basename "$2"`

weightfile="$sig.weights"
matchfile="$sig.matching"

rm -f "$weightfile"

i=1

function comp () { 

	if [ ! -f "$1" ]; then
		echo "error: file '$1' doesn't exist"
		exit
	fi

	if [ ! -f "$2" ]; then
		echo "error: file '$2' doesn't exist"
		exit
	fi

	if [ $use_minimal -ne 0 ]; then
		cmd="diff --minimal \"$1\" \"$2\""
	else
		cmd="diff \"$1\" \"$2\""
	fi

	if [ $use_gzip -ne 0 ]; then
		cmd="$cmd | gzip -c1"
	fi

	cmd="$cmd | wc -c"

	weight=`bash -c "$cmd"`

	echo "$weight,${1//,/\\,},${2//,/\\,}" >> "$weightfile"
}

while read left; do

	echo "$sig: $i/$sz ($((100*i/sz))%)"
	
	while read right; do
		comp "$left" "$right"
	done < "$2"

	let i=$i+1
done < "$1"

echo performing bipartite matching

./bipartite.pl < "$weightfile" > "$matchfile"

cat "$matchfile"

echo match file saved to "$matchfile"
