#!/bin/bash

if [[ $EUID -ne 0  ]]; then
  echo "需要root权限运行该脚本" 
  exit 1
fi

shut_time=$(date --date "$1" +%s)
now=$(date +%s)
start_time=$(date --date "$2" +%s)
diff=$((($shut_time - $now) / 60))
stop_period=$(($start_time - $shut_time))
period_str=$(date -u -d @$stop_period +"%d天%T")
shutdown -h +$diff "服务将于$1停机维护，请您尽快保存未完成工作。停机时间$period_str，重启时间为$2。"

echo 0 > /sys/class/rtc/rtc0/wakealarm
date --date "$2" +%s > /sys/class/rtc/rtc0/wakealarm
res=$(cat /proc/driver/rtc | awk '/alarm_IRQ/ {print $3}')
if [ "$res" = "yes" ]; then
  echo "set auto start at $2 success"
else
  echo "set auto start failed"
fi
echo "于关机5min前发送消息："
echo "服务将于$1停机维护，请您尽快保存未完成工作。停机时间$period_str，重启时间为$2。"
#cat /proc/driver/rtc | grep -o "alarm_IRQ"
