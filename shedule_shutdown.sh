#!/bin/bash

shut_time=$(date --date "$1" +%s)
now=$(date +%s)
diff=$(($shut_time - $now))
echo $diff
