#!/bin/bash

# Назва файлу логів
LOG_FILE="website_status.log"

# Масив із вебсайтами для перевірки
WEBSITES=(
    "https://google.com"
    "https://facebook.com"
    "https://twitter.com"
)

# Очищення або створення файлу логів перед початком перевірки
> "$LOG_FILE"

# Цикл перевірки кожного сайту зі списку
for site in "${WEBSITES[@]}"; do
    # Виконання запиту за допомогою curl:
    # -s : режим тиші (без виводу прогресу)
    # -L : обробка переадресацій (редиректів)
    # -o /dev/null : перенаправлення тіла відповіді в "нікуди"
    # -w "%{http_code}" : повернення лише HTTP статус-коду
    # --connect-timeout 5 : таймаут підключення в секундах
    http_code=$(curl -s -L -o /dev/null -w "%{http_code}" --connect-timeout 5 "$site")

    # Перевірка HTTP статус-коду на успішну відповідь (200 OK)
    if [ "$http_code" -eq 200 ]; then
        echo "<$site> is UP" >> "$LOG_FILE"
    else
        echo "<$site> is DOWN" >> "$LOG_FILE"
    fi
done

# Вивід повідомлення у термінал після завершення
echo "Результати записано у файл логів: $LOG_FILE"