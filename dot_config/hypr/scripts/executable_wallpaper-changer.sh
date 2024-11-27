#!/bin/sh


WALLPAPERS_DIR="$HOME/.config/wallpapers/"


while true; do
  WALLPAPER="$(fd .  "$WALLPAPERS_DIR" --type file | shuf -n 1)"
  hyprctl hyprpaper preload "$WALLPAPER"
  hyprctl hyprpaper wallpaper ",$WALLPAPER"

  sleep 3600

  hyprctl hyprpaper unload "$WALLPAPER"
done
