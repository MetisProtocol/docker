#!/bin/bash

current_date=`date -d "-1 day" "+%Y%m%d"`
#echo $current_date
split -b 100m -d -a 4 /app/log/t_geth.out   /app/log/log_${current_date}_
split -b 100m -d -a 4 /app/log/t_batch.out   /app/log/log_${current_date}_
split -b 100m -d -a 4 /app/log/t_msgrelay.out   /app/log/log_${current_date}_

cat /dev/null > /app/log/t_geth.out
cat /dev/null > /app/log/t_batch.out
cat /dev/null > /app/log/t_msgrelay.out

rm -rf /app/log/log_*_*