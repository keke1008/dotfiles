vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.did_indent_on = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_man = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.skip_loading_mswin = 1

vim.o.number = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.signcolumn = "yes"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 5

vim.o.cmdheight = 2
vim.o.laststatus = 2
vim.o.showcmd = true

vim.o.clipboard = "unnamedplus"

vim.o.fenc = "utf-8"
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.hidden = true
vim.o.list = true

vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.completeopt = "menuone,noinsert"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.updatetime = 300

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.g.mapleader = " "

-- https://github.com/neovim/neovim/issues/9570#issuecomment-626275405
if vim.fn.executable("win32yank.exe") == 1 then
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end

vim.cmd("autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 200 }")

vim.g.debug = false

pcall(require, "impatient")

require("keke.utils")

require("keke.plugins")

require("keke.keymap")
