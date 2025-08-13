local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.max_fps = 250
config.default_cursor_style = "SteadyBar"
config.enable_wayland = false

-- shell
config.default_prog = { "/usr/bin/zsh" }
-- config.default_cwd = 'D:\\projects'

-- window configuration
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 30
config.tab_bar_at_bottom = true

local c = {
	bg = "#282828",
	bg0 = "#1d2021",
	bg4 = "#7c6f64",
	bg3 = "#32302f",
	bg2 = "#504945",
	fg1 = "#ebdbb2",
	fg0 = "#fbf1c7",
	gray = "#7c6f64",
	lightfg = "#3c3836",
}

config.colors = {
	tab_bar = {
		background = c.bg3,
		active_tab = {
			bg_color = c.fg1,
			fg_color = c.bg0,
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = c.bg3,
			fg_color = c.fg1,
		},
		inactive_tab_hover = {
			bg_color = c.bg2,
			fg_color = c.fg1,
		},
		new_tab = {
			bg_color = c.bg2,
			fg_color = c.fg0,
		},
		new_tab_hover = {
			bg_color = c.lightfg,
			fg_color = c.fg0,
		},
	},
}

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("update-right-status", function(window, _)
	window:set_right_status(window:active_workspace())
end)

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local title = tab_title(tab)
	local tab_number = tab.tab_index + 1

	title = wezterm.truncate_right(tab_number .. ": " .. title .. " ", max_width - 2)

	return {
		-- { Background = {Color= c.lightfg} },
		{ Text = " " },
		-- { Background = {Color = colors.bg4 } },
		{ Text = title },

		-- { Background = {Color = c.bg4 } },
		{ Text = " " },
	}
end)

-- color scheme
config.color_scheme = "Gruvbox Dark (Gogh)"
-- config.color_scheme = "Kanagawa (Gogh)"
-- config.color_scheme = "kanagawabones"

config.font = wezterm.font_with_fallback({
	-- { family = "0xproto", weight = "Regular" },
	-- { family = "IBM Plex Mono", weight = "Regular" },
	"Iosevka NF",
	"Symbols Nerd Font",
})

config.line_height = 1
config.font_size = 15

-- keybindings
config.keys = {
	{
		key = "w",
		mods = "WIN|CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "-",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "=",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
}

config.warn_about_missing_glyphs = false

local xcursor_theme = nil
local xcursor_size = nil

local success, stdout, _ =
	wezterm.run_child_process({ "gsettings", "get", "org.gnome.desktop.interface", "cursor-theme" })
if success then
	xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
end

local success, stdout, stderr =
	wezterm.run_child_process({ "gsettings", "get", "org.gnome.desktop.interface", "cursor-size" })
if success then
	xcursor_size = tonumber(stdout)
end

config.xcursor_theme = xcursor_theme
config.xcursor_size = xcursor_size

return config
