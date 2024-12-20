local wezterm = require("wezterm")

local config = wezterm.config_builder()

local SOLID_LEFT_ARROW = wezterm.nerdfonts.nf_ple_right_half_circle_thick
local X_ICON = wezterm.nerdfonts.nf_oct_x
local orange = "#ea9a97"
local red = "#eb6f92"
local white = "#e0def4"
local purple = "#c4a7e7"
local base = "#232136"
local surface = "#2a273f"
local overlay = "#393552"
local lightGray = "#908caa"

--local orange = "#e78a4e"
--local green = "#a9b665"
--local yellow = "#d8a657"
--local red = "#ea6962"
--local white = "#ddc7a1"
--local purple = "#d3869b"
--local base = "#282828"
--local surface = "#32302f"
--local overlay = "#32302f"
--local lightGray = "#7c6f64"

config.color_scheme = "rose-pine-moon"
--config.color_scheme = "Gruvbox Material (Gogh)"

config.max_fps = 240

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12
config.window_background_opacity = 0.96

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "powershell.exe", "-NoLogo" }
end

config.window_padding = {
	left = 0,
	right = 0,
	top = 2,
	bottom = 2,
}

config.window_frame = {
	active_titlebar_bg = base,
	inactive_titlebar_bg = base,
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
	{
		key = "{",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "}",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(1),
	},
}

config.window_frame = {
	font = wezterm.font({
		family = "FiraCode Nerd Font",
		weight = "Regular",
	}),
}

local title_map = {
	["Leads"] = "Leads",
	["Meetings"] = "Meetings",
	["Customers"] = "Customers",
	["AdviserPortal"] = "Portal",
}

function tab_title(tab_info)
	local title = tab_info.tab_title
	local contains_custom = false

	for word, custom_title in pairs(title_map) do
		if string.find(title, word) then
			contains_custom = true
			title = custom_title
			break
		end
	end

	if contains_custom == true then
		return title
	end

	if title and #title > 0 then
		return title
	end

	for word, custom_title in pairs(title_map) do
		if string.find(title, word) then
			title = custom_title
			break
		end
	end

	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local SOLID_LEFT_ROUND = wezterm.nerdfonts.ple_left_half_circle_thick
	local SOLID_RIGHT_ROUND = wezterm.nerdfonts.ple_right_half_circle_thick

	local title = tab_title(tab)

	title = wezterm.truncate_right(title, max_width - 2)

	if tab.is_active then
		return {
			{ Background = { Color = base } },
			{ Foreground = { Color = orange } },
			{ Text = SOLID_LEFT_ROUND },
			{ Background = { Color = orange } },
			{ Foreground = { Color = base } },
			{ Text = (tab.tab_index + 1) .. ": " .. title .. " " },
			{ Background = { Color = base } },
			{ Foreground = { Color = orange } },
			{ Text = SOLID_RIGHT_ROUND },
		}
	else
		return {
			{ Background = { Color = base } },
			{ Foreground = { Color = overlay } },
			{ Text = SOLID_LEFT_ROUND },
			{ Background = { Color = overlay } },
			{ Foreground = { Color = lightGray } },
			{ Text = (tab.tab_index + 1) .. ": " .. title .. " " },
			{ Background = { Color = base } },
			{ Foreground = { Color = overlay } },
			{ Text = SOLID_RIGHT_ROUND },
		}
	end
end)
return config
