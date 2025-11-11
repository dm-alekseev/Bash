HOST=$1
PORT=443
OUTPUT_FILE="ssl_expiry_days.txt"
if [ -z "$HOST" ] || [ -z "$PORT" ]; then
                    echo "Usage: $0 <hostname> <port>"
                                    exit 1
fi

# Используем openssl для получения даты окончания срока действия сертификата
EXPIRY_DATE_STR=$(openssl s_client -servername "$HOST" -connect "$HOST:$PORT" < /dev/null 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)

if [ -z "$EXPIRY_DATE_STR" ]; then
                    echo "Could not retrieve certificate expiration date."
                                    exit 1
fi

# Преобразуем дату окончания срока действия в timestamp (для расчета дней)
# В зависимости от ОС (Linux/BSD/macOS) синтаксис команды date может отличаться.
# Этот вариант обычно работает на большинстве современных Linux-систем (GNU date):
if command -v gdate &> /dev/null; then
     # Если установлена GNU date (например, на macOS через Homebrew)
        EXPIRY_DATE_TIMESTAMP=$(gdate -d "$EXPIRY_DATE_STR" +%s)
           else
     # Стандартный Linux date
        EXPIRY_DATE_TIMESTAMP=$(date -d "$EXPIRY_DATE_STR" +%s)
fi

CURRENT_TIMESTAMP=$(date +%s)

# Рассчитываем количество секунд между датами и делим на количество секунд в сутках (86400)
DAYS_LEFT=$(( (EXPIRY_DATE_TIMESTAMP - CURRENT_TIMESTAMP) / 86400 ))
echo $DAYS_LEFT > "$OUTPUT_FILE"
echo $DAYS_LEFT
