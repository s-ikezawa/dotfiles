local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.leader = { key = 'q', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = require('keybinds').keys
config.key_tables = require('keybinds').key_tables
config.font = wezterm.font('HackGen Console NF')
config.font_size = 18
config.color_scheme = 'Catppuccin Macchiato'
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = 'RESIZE'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.9
config.text_background_opacity = 0.9
config.macos_window_background_blur = 15
config.audible_bell = "Disabled"
config.scrollback_lines = 100000

return config
