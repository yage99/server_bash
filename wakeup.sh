#!/bin/bash

if [[ $EUID -ne 0  ]]; then
  echo "需要root权限运行该脚本" 
  exit 1
fi

# "2020-02-14 20:00:00"
echo 0 > /sys/class/rtc/rtc0/wakealarm
date --date $1 +%s > /sys/class/rtc/rtc0/wakealarm
cat /proc/driver/rtc
