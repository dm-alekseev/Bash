#!/bin/bash

LOCAL_RPM="./wazuh-agent-4.12.0-1.x86_64.rpm"
WAZUH_MANAGER_IP="ВАШ_IP_WAZUH_MANAGER"
REMOTE_USER="root"

HOSTS=(
    "server1.example.com"
    "server2.example.com"
)

for HOST in "${HOSTS[@]}"
do
    echo "--- Начинаем развертывание на хосте: $HOST ---"

    # 1. Copy file to remote host
    echo "Копирование RPM-файла на $HOST..."
    scp "$LOCAL_RPM" "$REMOTE_USER@$HOST:/tmp/"

    # 2. Connect SSH & run install
    echo "Установка и настройка на $HOST..."
    ssh "$REMOTE_USER@$HOST" << EOF
    
    sudo yum install -y /tmp/wazuh-agent-4.12.0-1.x86_64.rpm
    
    sudo sed -i "s|<address>.*</address>|<address>$WAZUH_MANAGER_IP</address>|" /var/ossec/etc/ossec.conf
    
    # enable service
    sudo systemctl enable wazuh-agent
    sudo systemctl start wazuh-agent

    # rm tmp file
    rm /tmp/wazuh-agent-4.12.0-1.x86_64.rpm
EOF

    echo "--- Развертывание на хосте $HOST завершено. ---"
done

echo "Все развертывания завершены."
