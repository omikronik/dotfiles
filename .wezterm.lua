local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Rosé Pine (Gogh)"

config.max_fps = 240

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12
config.window_background_opacity = 0.95

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

config.default_prog = { "powershell.exe", "-NoLogo" }

config.window_padding = {
	left = 0,
	right = 0,
	top = 2,
	bottom = 2,
}

config.keys = {
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
}

config.window_frame = {
	font = wezterm.font({
		family = "FiraCode Nerd Font",
		weight = "Regular",
	}),
}

return config
