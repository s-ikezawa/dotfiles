local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("HackGen Console NF")
config.font_size = 18.0

return config
