local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

---@see https://github.com/willothy/flatten.nvim/blob/c986f98bc1d1e2365dfb2e97dda58ca5d0ae24ae/README.md#installation1
if os.getenv("NVIM") ~= nil then
    require("lazy").setup({
        { "willothy/flatten.nvim", config = true },
    })
    return
end

require("lazy").setup("keke.plugins", {
    defaults = {
        lazy = true,
        cond = require("keke.utils.is_in_terminal"),
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "gzip",
                "man",
                "matchit",
                "matchparen",
                "netrw",
                "netrwPlugin",
                "remote_plugins",
                "shada_plugin",
                "spellfile_plugin",
                "tar",
                "vimball",
                "vimballPlugin",
                "tarPlugin",
                "tutor_mode_plugin",
                "zip",
                "zipPlugin",
            },
        },
    },
    ui = {
        border = "rounded",
    },
})
