#!/bin/bash
lock() {
    i3lock
}

case "$1" in
    lock) lock ;;
    logout) i3-msg exit;;
    suspend) lock && systemctl suspend;;
    hibernate) lock && systemctl hibernate;;
    reboot) systemctl reboot;;
    shutdown) systemctl poweroff;;
    *)
        echo "Modo de uso: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
