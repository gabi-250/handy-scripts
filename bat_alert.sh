#!/bin/bash

function finish {
  exit
}

trap finish SIGHUP SIGINT SIGTERM SIGQUIT

# making sure there won't be multiple instances running
pids=$(pgrep `basename $0`)
if [ $(echo $pids | wc -w) -gt 1 ]; then
  echo "Cannot run more than once instance of bat_alert!"
  finish
fi

dependencies=(acpi beep cvlc xset)
required=()

for i in ${dependencies[*]}
do
  if ! [ -x "$(command -v $i)" ]; then
    required+=($i)
  fi
done

if [ ${#required[*]} -ne 0 ]; then
  echo "Please install the dependencies first: "
  for i in ${required[*]}
  do
    echo $i
  done
elif [ $# -gt 1 ]; then
  echo "Illegal number of arguments"
elif [ -f $1 ] || [ $# -eq 0 ]; then
  while true
  do
    bat_level=`acpi -b | grep -Eo [0-9]+% | grep -Eo [0-9]+`
    bat_stat=`acpi -b | grep -Eo Discharging\|Charging\|Unknown`
    if [ "$bat_level" -le 5 ] && [ "$bat_stat" == "Discharging" ]; then
      xset dpms force off
      sleep 0.05
      if [ $# -eq 0 ]; then
	beep -f 200
      else
	cvlc $1 &
	pid=$!
	sleep 2.5
	kill -9 $pid
      fi
      xset dpms force on
    fi
    sleep 150
  done
else
  echo "$1: No such file"
fi
