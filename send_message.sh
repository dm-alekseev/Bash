#!/bin/bash

TOKEN="$TELEGRAM_TOKEN"

CHAT_ID="$TELEGRAM_CHAT_ID"

MESSAGE="send test message"

curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
     -H "Content-Type: application/json" \
     -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"$MESSAGE\"}"
