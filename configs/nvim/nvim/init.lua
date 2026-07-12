vim.g.mapleader = " "

require("keke.setup")

if not require("keke.lazy").load().loaded then
    require("keke.setup_noplugin")
end

-- load local config
do
    local xdg_config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
    local local_config_path = xdg_config_home .. "/dotfiles/local/nvim"
    vim.opt.runtimepath:append(local_config_path)
end
