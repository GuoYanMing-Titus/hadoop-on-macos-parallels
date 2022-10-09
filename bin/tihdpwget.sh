#!/bin/bash

[ ! -d ../lib ] && echo "../lib not found" && exit 1
[ ! -f ../lib/dlist ] && echo "../lib/dlist not found" && exit 1

while read line; do
	echo $line
done < ../lib/dlist

read -p "download above packages? (YES/NO) " ans
echo $ans

if [ "$ans" == 'YES' ]; then
	[ -d ~/tihdp${1}/opt ] && rm -r ~/tihdp${1}/opt &>/dev/null
	#[ -d ~/tihdp${1}/bkopt ] || mkdir -p ~/tihdp${1}/bkopt &&\
	#echo "mkdir -p ~/tihdp${1}/bkopt" &>/dev/null
	mkdir -p ~/tihdp${1}/opt && echo "mkdir -p ~/tihdp${1}/opt"

	while read line; do
		wget $line
		if [ "$?" == "0" ]; then
	    n=${line##*/}
			tar xvfz $n -C ~/tihdp${1}/opt &>/dev/null
			[ "$?" == "0" ] && echo "$n ok"
			rm $n 
		else
			n=${line##*/}
			echo "$n failed"
		fi
	done < ../lib/dlist
fi

sudo chown -R titus:titus ~/tihdp${1}/opt

