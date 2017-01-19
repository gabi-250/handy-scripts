#!/bin/bash

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
  bat_level=`acpi -b | grep -Eo [0-9]+% | grep -Eo [0-9]+`
  bat_stat=`acpi -b | grep -Eo Discharging\|Charging\|Unknown`
  while true
  do
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
