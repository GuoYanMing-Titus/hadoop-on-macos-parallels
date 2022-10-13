#!/bin/bash

[ -f /tmp/maxjlog.stop ] && sudo rm /tmp/maxjlog.stop

mf="/tmp/jpsmax-`hostname`.log"
echo "[`hostname`]" > "$mf"

jcb="0"
while true; do

  [ -f /tmp/maxjlog.stop ] && break

  jps -v | grep -v Jps > /tmp/jps.txt
  jyc=$(cat /tmp/jps.txt | grep "YarnChild" | wc -l)
  jmc=$(cat /tmp/jps.txt | grep "MRAppMaster" | wc -l)
  jc=$(( $jyc+$jmc ))
  [ "$?" == "0" ] && [ "$jc" != "$jcb" ] && jcb=$jc && [ "$jc" != "0" ] && echo "`date +%H:%M:%S` -> Y:$jyc M:$jmc" >> $mf

done
