#!/bin/sh

WALLPAPERS_DIR="$HOME/.config/wallpapers/"
while true; do
  feh --bg-fill --randomize "$WALLPAPERS_DIR"

  sleep 3600
done
