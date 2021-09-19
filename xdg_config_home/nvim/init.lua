if vim.fn.exists("g:vscode") == 1 then
  os.execute'export VIMRUNTIME=/usr/share/nvim/runtime'
  vim.o.runtimepath = vim.o.runtimepath .. '/usr/share/nvim/runtime'
end

local vimp = require'vimp'
local utils = require'utils'

vim.o.number = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.signcolumn = 'number'

vim.o.cmdheight = 2
vim.o.laststatus = 2
vim.o.showcmd = true

vim.o.clipboard = 'unnamedplus'

vim.o.fenc = 'utf-8'
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.hidden = true

vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.completeopt = 'menuone,noinsert'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.updatetime = 300

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true


vimp.nnoremap('j', 'gj')
vimp.nnoremap('k', 'gk')
vimp.nmap({ 'silent' }, '  ', '<CMD>noh<CR>')
vimp.nmap({ 'expr' }, '<Esc>', 'len(@%) ? "<CMD>w<CR>" : "<Esc>"')

if os.getenv('TMUX') then
  local change_active_pain = function(key_direction, tmux_option)
    return function()
      local id = vim.fn.win_getid()
      vim.cmd('normal!' .. utils.esc'<C-w>' .. key_direction)
      if id == vim.fn.win_getid() then
        os.execute('tmux select-pane ' .. tmux_option)
      end
    end
  end
  vimp.nnoremap('<C-w>h', change_active_pain("h", "-L"))
  vimp.nnoremap('<C-w>j', change_active_pain("j", "-D"))
  vimp.nnoremap('<C-w>k', change_active_pain("k", "-U"))
  vimp.nnoremap('<C-w>l', change_active_pain("l", "-R"))
end

require'plugins'
