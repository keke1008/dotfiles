vim.o.number = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.signcolumn = 'yes'
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 5

vim.o.cmdheight = 2
vim.o.laststatus = 2
vim.o.showcmd = true

vim.o.clipboard = 'unnamedplus'

vim.o.fenc = 'utf-8'
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.hidden = true
vim.o.list = true

vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.completeopt = 'menuone,noinsert'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.updatetime = 300

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.g.mapleader = require'utils'.esc'<Space>'

-- https://github.com/neovim/neovim/issues/9570#issuecomment-626275405
if vim.fn.executable('win32yank.exe') == 1 then
    vim.g.clipboard = {
        name= 'win32yank',
        copy= {
            ['+']= 'win32yank.exe -i --crlf',
            ['*']= 'win32yank.exe -i --crlf',
        },
        paste= {
            ['+']= 'win32yank.exe -o --lf',
            ['*']= 'win32yank.exe -o --lf',
        },
        cache_enabled= 0,
    }
end

vim.cmd'autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 200 }'

-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    _G.packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd 'packadd packer.nvim'
end

require'plugins'.startup()

require'keymap'
