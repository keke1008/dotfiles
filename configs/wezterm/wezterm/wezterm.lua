local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.font = wezterm.font "UDEV Gothic 35NF"
config.color_scheme = "tokyonight_night"
config.window_background_opacity = 0.9

return config