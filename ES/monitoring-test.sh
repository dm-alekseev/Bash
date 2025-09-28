#!/bin/bash

# Основные переменные
SCRIPT_PATH="/usr/local/bin/test_monitor.sh"
LOG_FILE="/var/log/monitoring.log"
STATE_FILE="/var/tmp/test_process_state"
SERVICE_NAME="test_monitor.service"
TIMER_NAME="test_monitor.timer"

# Создаем скрипт для мониторинга
cat > "$SCRIPT_PATH" << 'EOF'
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
EOF

# Назначаем права на выполнение
chmod +x "$SCRIPT_PATH"

# Создаем systemd unit для скрипта
cat > "/etc/systemd/system/$SERVICE_NAME" << EOF
[Unit]
Description=Monitor process 'test' and notify server
After=network.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
EOF

# Создаем таймер для запуска каждую минуту
cat > "/etc/systemd/system/$TIMER_NAME" << EOF
[Unit]
Description=Run test_monitor every minute

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Перезагружаем systemd и включаем таймер
systemctl daemon-reload
systemctl enable --now "$TIMER_NAME"

# Проверяем, что службы запущены
sleep 2 # даем время запуститься
for name in "$SERVICE_NAME" "$TIMER_NAME"; do
    systemctl is-active --quiet "$name"
    if [ $? -eq 0 ]; then
        echo "$name is active."
    else
        echo "Warning: $name is not active!"
    fi
done

echo "Мониторинг настроен и запущен."