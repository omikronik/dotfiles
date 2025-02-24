local wezterm = require("wezterm")

local config = wezterm.config_builder()

local SOLID_LEFT_ARROW = wezterm.nerdfonts.nf_ple_right_half_circle_thick
local X_ICON = wezterm.nerdfonts.nf_oct_x

-- TODO: Figure out a way to dynamically set titlebar colours from theme

-- Kanagawa Paper
local background = "#333333"
local black = "#0d0c0c"
local red = "#c4746e"
local green = "#b3c6a0"
local yellow = "#c4b28a"
local blue = "#315567"
local purple = "#a292a3"
local cyan = "#8ea4a2"
local white = "#C8C093"
local bg_light = "#393836"
local bg_dark = "#1F1F28"
local foreground = "#c5c9c5"

--[[ rose pine moon
local yellow = "#ea9a97"
local red = "#eb6f92"
local white = "#e0def4"
local purple = "#c4a7e7"
local black = "#232136"
local bg_dark = "#2a273f"
local bg_light = "#393552"
local foreground = "#908caa"
]]

-- Gruvbox
--local yellow = "#e78a4e"
--local green = "#a9b665"
--local yellow = "#d8a657"
--local red = "#ea6962"
--local white = "#ddc7a1"
--local purple = "#d3869b"
--local black = "#282828"
--local bg_dark = "#32302f"
--local bg_light = "#32302f"
--local foreground = "#7c6f64"

config.color_scheme_dirs = { "~/wezterm_colors" }
config.color_scheme = "kanagawa-paper"
--config.color_scheme = "rose-pine-moon"
--config.color_scheme = "Gruvbox Material (Gogh)"

config.max_fps = 240

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12
config.window_background_opacity = 1

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
	active_titlebar_bg = black,
	inactive_titlebar_bg = black,
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

config.font_rules = {
	{
		italic = false,
		intensity = "Normal",
		font = wezterm.font_with_fallback({
			{ family = "FiraCode Nerd Font", weight = "Regular" },
		}),
	},
	{
		italic = false,
		intensity = "Bold",
		font = wezterm.font_with_fallback({
			{ family = "FiraCode Nerd Font", weight = "Regular" },
		}),
	},
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
			{ Background = { Color = bg_dark } },
			{ Foreground = { Color = yellow } },
			{ Text = SOLID_LEFT_ROUND },
			{ Background = { Color = yellow } },
			{ Foreground = { Color = bg_dark } },
			{ Text = (tab.tab_index + 1) .. ": " .. title .. " " },
			{ Background = { Color = bg_dark } },
			{ Foreground = { Color = yellow } },
			{ Text = SOLID_RIGHT_ROUND },
		}
	else
		return {
			{ Background = { Color = bg_dark } },
			{ Foreground = { Color = bg_light } },
			{ Text = SOLID_LEFT_ROUND },
			{ Background = { Color = bg_light } },
			{ Foreground = { Color = foreground } },
			{ Text = (tab.tab_index + 1) .. ": " .. title .. " " },
			{ Background = { Color = bg_dark } },
			{ Foreground = { Color = bg_light } },
			{ Text = SOLID_RIGHT_ROUND },
		}
	end
end)
return config
