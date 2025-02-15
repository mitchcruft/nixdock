-- https://wezfurlong.org/wezterm/config/lua/config/

-- Import the wezterm module
local wezterm = require("wezterm")
local action = wezterm.action
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()

-- (This is where our config will go)
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	-- "Noto Sans Mono",
	-- "Fira Code",
	-- "Geist Mono",
}, {
	weight = "DemiBold",
})
config.font_size = 14
config.window_decorations = "RESIZE"
config.colors = {
	foreground = "rgba(255,255,255,1.0)",
	cursor_bg = "rgba(248,28,229,0.8)",
	selection_bg = "rgba(248,28,229,0.3)",
	split = "rgba(248,28,229,0.8)",
}
config.hide_tab_bar_if_only_one_tab = true

-- Demo of how to send CMD- combos to tmux
--[[
config.keys = {
	{
		key = "t",
		mods = "CMD",
		action = action.SendKey({
			key = "t",
			mods = "CTRL",
		}),
	},
}
]]
--

-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config
