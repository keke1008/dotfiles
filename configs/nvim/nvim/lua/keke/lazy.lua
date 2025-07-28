local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local M = {}

function M.is_installed()
    return vim.uv.fs_stat(lazypath) ~= nil
end

function M.exit_with_is_installed()
    if M.is_installed() then
        vim.cmd("quit")
    else
        vim.cmd("cquit")
    end
end

function M.exit_with_bootstrap()
    local result = vim.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }):wait(30 * 1000)

    if result.code == 0 then
        vim.cmd("quit")
    else
        print(result.stderr)
        vim.cmd("cquit")
    end
end

function M.load()
    if not M.is_installed() then
        return
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
end

return M
