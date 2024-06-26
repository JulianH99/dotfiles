local awful = require("awful")

awful.spawn.with_shell("feh --bg-scale --randomize ~/.config/wallpapers/*")
awful.spawn.with_shell("setxkbmap eu")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("flameshot")

awful.spawn.once("firefox")
awful.spawn.with_shell("picom -b --config ~/.config/picom/picom.conf")

-- awful.spawn.once("wezterm")
-- awful.spawn.once("slack")
