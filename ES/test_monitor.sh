#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
PROCESS_NAME="test"
URL="https://test.com/monitoring/test/api"
STATE_FILE="/var/tmp/test_process_state"

# Проверяем, запущен ли процесс "test"
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    PROCESS_RUNNING=1
else
    PROCESS_RUNNING=0
fi

# Читаем предыдущее состояние
if [[ -f "$STATE_FILE" ]]; then
    PREV_STATE=$(cat "$STATE_FILE")
else
    PREV_STATE=0
fi

# Если процесс запущен и он был не запущен раньше — логируем
if [[ "$PROCESS_RUNNING" -eq 1 ]]; then
    if [[ "$PREV_STATE" -eq 0 ]]; then
        echo "$(date '+%F %T') - Process '$PROCESS_NAME' restarted" >> "$LOG_FILE"
    fi

    # Проверка доступности сервера
    if ! curl --silent --fail --connect-timeout 10 "$URL" > /dev/null; then
        echo "$(date '+%F %T') - Monitoring server not reachable at $URL" >> "$LOG_FILE"
    fi
fi
# Записываем текущее состояние
echo "$PROCESS_RUNNING" > "$STATE_FILE"
