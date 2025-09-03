#!/bin/bash
while  true 
  do
  cat /proc/loadavg | awk  '{print $1" " $2" "$3 }' > /var/www/alekseev.mywire.org/html/cpu/cpu.txt
  sleep 2
done
