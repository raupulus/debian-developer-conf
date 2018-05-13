#!/bin/bash
case "$1" in
    lock) ~/.config/i3/scripts/lock_and_blur.sh ;;
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
