#!/bin/bash

if [ $# -gt 1 ]; then
  echo "Illegal number of arguments"
elif [ -f $1 ] || [ $# -eq 0 ]; then
  bat_level=`acpi -b | grep -o [0-9]*% | grep -o [0-9]*`
  bat_stat=`acpi -b | grep -o "Discharging\|Charging"`
  while true
  do
    if [ $bat_level -le 100 -a "$bat_stat" == "Discharging" ]; then
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
    sleep 3
  done
else
  echo "$1: No such file"
fi


