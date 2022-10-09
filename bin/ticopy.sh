#!/bin/bash

# w="dta1 dtm1 dtm2 dtw1 dtw2 dtw3"
w="dta1"
[ "$#" != 1 ] && echo "dtcopy version" && exit 1

[ ! -d ~/tihdp${1}/opt ] && echo "~/tihdp${1}/opt not found" && exit 1

for x in $w
do
	nc -w 1 -z $x 22 &>/dev/null
	[ "$?" != "0" ] && continue

	ssh $x sudo mkdir -p /opt/bin &>/dev/null
	ssh $x sudo chmod -R 777 /opt &>/dev/null

	#n=$(ssh $x ls /opt)
  # for y in $n
  # do
  #   ([ "$y" == "cni" ] || [ "$y" == "bin" ] || [ "$y" == "nfs" ] || [ "$y" == "openjdk-8u332-linux-x64" ]) && continue
  #   ssh $x sudo rm -r /opt/$y
  # done
	
	scp -r ~/tihdp${1}/opt/* titus@$x:/opt/ &>/dev/null

	ssh $x sudo chown -R root:root /opt
	ssh $x sudo chmod -R 0777 /opt
	
	echo "copy ~/tihdp${1}/opt/ to $x:/opt/ done."
done

