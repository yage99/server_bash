#!/bin/bash

# "2020-02-14 20:00:00"
echo 0 > /sys/class/rtc/rtc0/wakealarm
date --date $1 +%s > /sys/class/rtc/rtc0/wakealarm
cat /proc/driver/rtc
