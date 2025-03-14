#!/bin/bash

power_off="󰐥 Power off"
restart="󰜉 Restart"
logout="󰿅 Logout"
lock="󰌾 Lock"
host="$(hostname)"

chosen=$(printf "$power_off\n$restart\n$logout\n$lock" | rofi -dmenu -i -l 4 -no-custom -theme powermenu.rasi -p "Tschüss!")

case $chosen in
  $power_off) systemctl poweroff;;
  $restart) systemctl reboot;;
  $logout) qtile cmd-obj -o cmd -f shutdown;;
  $lock) betterlockscreen -l dim;;
