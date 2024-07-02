local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.font = wezterm.font "UDEV Gothic 35NF"
config.color_scheme = "tokyonight_night"
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true

return config
