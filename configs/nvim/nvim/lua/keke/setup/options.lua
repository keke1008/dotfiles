vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 5
vim.o.fillchars = "eob: "

vim.o.cmdheight = 2
vim.o.laststatus = 3
vim.o.showcmd = true
vim.o.winborder = "rounded"
vim.g.health = { style = "float" }

vim.o.fenc = "utf-8"
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.hidden = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.smartindent = true
vim.o.completeopt = "menu,menuone,popup,fuzzy,noinsert"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.updatetime = 300
vim.o.timeoutlen = 500

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
