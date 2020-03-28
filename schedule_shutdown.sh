#!/bin/bash

if [[ $EUID -ne 0  ]]; then
  echo "需要root权限运行该脚本" 
  exit 1
fi

shut_time=$(date --date "$1" +%s)
echo "will shutdown at $1"
now=$(date +%s)
diff=$((($shut_time - $now) / 60))
echo "+$diff minutes from now"
shutdown -h +$diff "服务将于$1停机维护，请您尽快保存为完成工作。"
