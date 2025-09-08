#!/bin/bash
read -p "Enter date (example, 250509): " DATE

remote_file="$OTM/glog.app.log.${DATE}.gz"
local_file="glog.app.log.${DATE}.gz"

if [ -f "$local_file" ] ; then
    echo "Файл $local_file уже существует. Пропускаем скачивание."
else
    echo "Скачивание файла..."
    scp "$OTM/glog.app.log.${DATE}.gz" "glog.app.log.${DATE}.gz"
fi

read -p "Enter shipment (example, 429516): " pattern

logfile="glog.app.log.${DATE}.gz"
output="otm/${pattern}.txt"

zgrep -w "$pattern" "$logfile" > "$output"
echo "Result in $output."