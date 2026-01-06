#!/bin/bash

power_off="󰐥 Power off"
restart="󰜉 Restart"
logout="󰿅 Logout"
lock="󰌾 Lock"

chosen=$(printf "$power_off\n$restart\n$logout\n$lock" | rofi -dmenu -i -l 4 -no-custom -theme powermenu.rasi)

case $chosen in
  $power_off) systemctl poweroff;;
  $restart) systemctl reboot;;
  $logout) i3-msg exit;;
  $lock) betterlockscreen -l dim;;
esac

