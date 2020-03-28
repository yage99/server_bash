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
days=$(($stop_period / 24 / 60 / 60))
period_str=$(date -u -d @$stop_period +"%H小时%M分钟")
if [ $days -gt 0 ]; then
  period_str="$days天$period_str"
fi
message="服务器将于$1停机维护，请您尽快保存未完成工作。停机持续时间$period_str，将于$2重启。"
shutdown -h +$diff $message

echo 0 > /sys/class/rtc/rtc0/wakealarm
date --date "$2" +%s > /sys/class/rtc/rtc0/wakealarm
res=$(cat /proc/driver/rtc | awk '/alarm_IRQ/ {print $3}')
if [ "$res" = "yes" ]; then
  echo "set auto start at $2 success"
  echo "即将发送消息："
  echo $message
else
  echo "set auto start failed"
  shutdown -c "维护取消"
  echo "维护取消"
fi
#cat /proc/driver/rtc | grep -o "alarm_IRQ"
