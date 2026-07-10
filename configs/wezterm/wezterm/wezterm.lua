local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.keys = {
  {
    key = "r",
    mods = "CMD|SHIFT",
    action = wezterm.action.ReloadConfiguration,
  },
}

config.window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4
}

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.color_scheme = "blue"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 40

-- Setup tab style
do
    local function retain_table(elements)
        local result = {}

        for _, e in ipairs(elements) do
            if type(e) == "table" then
                table.insert(result, e)
            end
        end

        return result
    end

    local SEPARATOR = wezterm.nerdfonts.pl_left_soft_divider

    wezterm.on(
        "format-tab-title",
        function(tab, tabs, panes, config, hover, max_width)
            local tab_title = tab.tab_title or ""
            local title = tostring(tab.tab_index) .. (#tab_title == 0 and "" or " " .. tab_title)

            return retain_table({
                tab.tab_index == 0 and { Text = ' WezTerm ' .. SEPARATOR },

                { Text = " " },
                (tab.is_active or hover) and { Attribute = { Intensity = "Bold" } },
                (tab.is_active or hover) and { Attribute = { Underline = "Single" } },
                { Text = title },
                { Attribute = { Underline = "None" } },

                { Text = tab.is_active and " * " or " - " },
                { Text = SEPARATOR }
            })
        end
    )
end

-- Load local config file
do
    local function get_local_config_path()
        local xdg_config_home = nil
        xdg_config_home = os.getenv("XDG_CONFIG_HOME")
        if xdg_config_home == nil then
            xdg_config_home = os.getenv("HOME") .. "/.config"
        end

        return xdg_config_home .. "/dotfiles/local/wezterm/wezterm.lua"
    end

    local function load_local_config(config)
        local local_config_path = get_local_config_path()
        local file = io.open(local_config_path, "r")
        if file == nil then
            return
        end

        local local_config_str = file:read("*all")
        file:close()


        local local_config = assert(load(local_config_str))()
        if type(local_config) ~= "function" then
            error(local_config_path .. " does not return function")
        end

        local_config(config)
    end

    load_local_config(config)
end

return config
