generate_password() {
    local length=${1:-16}
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+{}|:<>?=' </dev/urandom | head -c "$length" ; echo
}

mtop () {
        echo "=== Топ-5 процессов по CPU ==="
        ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

        echo ""
        echo "=== Топ-5 процессов по RAM ==="
        ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6
}


# Запускаем tmux
if command -v tmux>/dev/null; then
  # Запускаем новую сессию или присоединяемся к существующей
  if [ -z "$TMUX" ] && [ "$SSH_CONNECTION" != "" ] && [ -t 1 ]; then
    tmux attach -t ssh || tmux new -s ssh
  fi
fi
