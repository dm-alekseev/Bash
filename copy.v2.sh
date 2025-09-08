#!/bin/bash

SKIP_DOWNLOAD=0

while [[ "$#" -gt 0 ]]; do case $1 in
    --skip ) SKIP_DOWNLOAD=1;;
esac; shift; done

if [ "$SKIP_DOWNLOAD" -ne 1 ]; then
    # Если флаг скачивания не установлен, запрашиваем дату
    read -p "Enter date (example, 250509): " DATE

    remote_file="$OTM/glog.app.log.${DATE}.gz"
    local_file="glog.app.log.${DATE}.gz"

    if [ ! -f "$local_file" ]; then
        echo "Скачивание файла..."
        scp "$OTM/glog.app.log.${DATE}.gz" "glog.app.log.${DATE}.gz"
    else
        echo "Файл $local_file уже существует. Пропускаем скачивание."
    fi
else
    # Если флаг скачивания установлен, никаких действий с датой не производим
    echo "Флаг '--skip-download' установлен. Дата не запрашивается."
fi

read -p "Enter shipment (example, 429516): " pattern

logfile="glog.app.log.${DATE}.gz"

output="otm/${pattern}.txt"

zgrep -w "$pattern" "$logfile" > "$output"
echo "Result in $output."
