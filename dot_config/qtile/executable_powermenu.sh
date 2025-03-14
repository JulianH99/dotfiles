#!/bin/bash

power_off="󰐥 Power off"
restart="󰜉 Restart"
logout="󰿅 Logout"
lock="󰌾 Lock"

chosen=$(printf "$power_off\n$restart\n$logout\n$lock" | rofi -dmenu -i -l 4 -no-custom)

case $chosen in
  $power_off) systemctl poweroff;;
  $restart) systemctl reboot;;
  $logout) qtile cmd-obj -o cmd -f shutdown;;
  $lock) betterlockscreen -l dim;;
