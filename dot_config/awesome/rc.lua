-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- custom widgets
local volume_widget = require("awesome-wm-widgets.pactl-widget.volume")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "/mytheme/init.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "wezterm"
local editor = "nvim"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal },
		{ "open browser", "firefox" },
		{ "open slack", "slack" },
	},
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.fair,
		awful.layout.suit.spiral,
		awful.layout.suit.max,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.magnifier,
	})
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper({
		screen = s,
		widget = {
			{
				image = beautiful.wallpaper,
				upscale = true,
				downscale = true,
				horizontal_fit_policy = "fit",
				vertical_fit_policy = "fit",
				widget = wibox.widget.imagebox,
			},
			valign = "center",
			halign = "center",
			tiled = false,
			widget = wibox.container.tile,
		},
	})
end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

local text_tags = { terminal = "terminal", web = "web", slack = "slack", spotify = "spotify" }

local tags = {
	"terminal",
	"web",
	"slack",
	"spotify",
	"5",
	"6",
	"7",
	"8",
	"9",
}

screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	awful.tag(tags, s, awful.layout.layouts[1])

	-- hide the systray
	s.systray = wibox.widget.systray()
	s.systray.visible = false

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox({
		screen = s,
		buttons = {
			awful.button({}, 1, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 3, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 4, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 5, function()
				awful.layout.inc(1)
			end),
		},
	})

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
		},
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({}, 1, function(c)
				c:activate({ context = "tasklist", action = "toggle_minimization" })
			end),
			awful.button({}, 3, function()
				awful.menu.client_list({ theme = { width = 250 } })
			end),
			awful.button({}, 4, function()
				awful.client.focus.byidx(-1)
			end),
			awful.button({}, 5, function()
				awful.client.focus.byidx(1)
			end),
		},
		layout = {
			spacing = 1,
			spacing_widget = {
				{
					forced_width = 5,
					shape = gears.shape.circle,
					widget = wibox.widget.separator,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				wibox.widget.base.make_widget(),
				forced_height = 1,
				id = "background_role",
				widget = wibox.container.background,
			},
			{
				{
					id = "clienticon",
					widget = awful.widget.clienticon,
				},
				margins = 3,
				widget = wibox.container.margin,
			},
			nil,
			create_callback = function(self, c, index, objects) --luacheck: no unused args
				self:get_children_by_id("clienticon")[1].client = c
			end,
			layout = wibox.layout.align.vertical,
		},
	})

	-- Create the wibox
	local cw = calendar_widget({
		placement = "top_right",
	})

	mytextclock:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			cw.toggle()
		end
	end)

	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = {
			layout = wibox.layout.align.horizontal,
			expand = "none",
			s.mytasklist, -- Middle widget
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
			},
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				volume_widget({
					widget_type = "arc",
				}),
				wibox.widget.textbox(" "),
				cpu_widget(),
				wibox.widget.textbox(" "),
				ram_widget(),
				mykeyboardlayout,
				mytextclock,
				wibox.widget.textbox(" "),
				s.systray,
				wibox.widget.textbox(" "),
				logout_menu_widget(),
			},
		},
	})
end)

-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
})
-- }}}

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

	awful.key({ modkey }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),

	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "apps" }),

	awful.key({ modkey }, "d", function()
		awful.spawn("rofi -show drun")
	end, { description = "Show rofi launcher", group = "launcher" }),

	awful.key({ modkey }, "b", function()
		awful.spawn("firefox")
	end, { description = "Open firefox", group = "apps" }),

	-- media keys
	awful.key({}, "XF86AudioRaiseVolume", function()
		volume_widget.inc()
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		volume_widget.dec()
	end),
	awful.key({}, "XF86AudioMute", function()
		volume_widget.toggle()
	end),

	awful.key({}, "XF86AudioPlay", function()
		awful.util.spawn("playerctl play-pause", false)
	end),

	awful.key({}, "XF86AudioNext", function()
		awful.util.spawn("playerctl next", false)
	end),

	awful.key({}, "XF86AudioPrev", function()
		awful.util.spawn("playerctl previous", false)
	end),

	-- brightness
	awful.key({}, "XF86MonBrightnessUp", function()
		brightness_widget:inc()
	end, { description = "increase brightness", group = "custom" }),
	awful.key({}, "XF86MonBrightnessDown", function()
		brightness_widget:dec()
	end, { description = "decrease brightness", group = "custom" }),

	-- print key
	awful.key({}, "Print", function()
		awful.util.spawn("flameshot gui")
	end, { description = "Takes a screenshot", group = "apps" }),

	awful.key({ modkey }, "=", function()
		awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
	end, { description = "Toggle systray visibility", group = "custom" }),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),

	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),

	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:activate({ raise = true, context = "key.unminimize" })
		end
	end, { description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),

	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),

	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),

	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),

	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),

	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),

	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),

	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),

	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),

	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),
})

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { modkey },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),

	awful.key({
		modifiers = { modkey, "Control" },
		keygroup = "numrow",
		description = "toggle tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	}),

	awful.key({
		modifiers = { modkey, "Shift" },
		keygroup = "numrow",
		description = "move focused client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),

	awful.key({
		modifiers = { modkey, "Control", "Shift" },
		keygroup = "numrow",
		description = "toggle focused client on tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),

	awful.key({
		modifiers = { modkey },
		keygroup = "numpad",
		description = "select layout directly",
		group = "layout",
		on_press = function(index)
			local t = awful.screen.focused().selected_tag
			if t then
				t.layout = t.layouts[index] or t.layout
			end
		end,
	}),
})

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "toggle fullscreen", group = "client" }),

		awful.key({ modkey }, "q", function(c)
			c:kill()
		end, { description = "close", group = "client" }),

		awful.key(
			{ modkey, "Control" },
			"space",
			awful.client.floating.toggle,
			{ description = "toggle floating", group = "client" }
		),

		awful.key({ modkey, "Control" }, "Return", function(c)
			c:swap(awful.client.getmaster())
		end, { description = "move to master", group = "client" }),

		awful.key({ modkey }, "o", function(c)
			c:move_to_screen()
		end, { description = "move to screen", group = "client" }),

		awful.key({ modkey }, "t", function(c)
			c.ontop = not c.ontop
		end, { description = "toggle keep on top", group = "client" }),

		awful.key({ modkey }, "n", function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end, { description = "minimize", group = "client" }),

		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "(un)maximize", group = "client" }),

		awful.key({ modkey, "Control" }, "m", function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end, { description = "(un)maximize vertically", group = "client" }),

		awful.key({ modkey, "Shift" }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end, { description = "(un)maximize horizontally", group = "client" }),
	})
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
	-- All clients will match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	-- Floating clients.
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = { "copyq", "pinentry" },
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"Sxiv",
				"Tor Browser",
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
				"pavucontrol",
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
				"Save As", -- firefox save file dialog
				"Save Image", -- firefox save image dialog
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
				"GtkFileChooserDialog", -- general gtk file dialog
			},
		},
		properties = { floating = true, placement = awful.placement.centered },
	})

	-- Set Firefox to always map on the tag named "2" on screen 1.
	ruled.client.append_rule({
		rule = { class = "firefox" },
		properties = { screen = 1, tag = text_tags.web, floating = false },
	})

	-- Set slack to open in tag 3
	ruled.client.append_rule({
		rule = { class = "Slack" },
		properties = { screen = 1, tag = text_tags.slack, floating = false },
	})

	-- set spotify to open in tag 4
	ruled.client.append_rule({
		rule = { class = "spotify" },
		properties = { screen = 1, tag = text_tags.spotify, floating = false },
	})
end)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal("request::rules", function()
	-- All notifications will match this rule.
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 3,
		},
	})
end)

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({ notification = n })
end)

-- }}}

-- require custom modules
require("autostart")
