local sidemenu = require 'keke.sidemenu'

local remap = require 'keke.remap'
local set_keymap = remap.set_keymap


set_keymap('nv', 'ga', '<Plug>(EasyAlign)')
set_keymap('n', 'gj', '<Plug>(jumpcursor-jump)')
set_keymap('n', 'j', 'gj')
set_keymap('n', 'k', 'gk')
set_keymap('n', '<Esc>', 'len(@%) ? "<CMD>w<CR>" : "<Esc>"', { expr = true })
set_keymap('n', '<leader><leader>', '<CMD>noh<CR>', { silent = true })
set_keymap('n', '<BS>', '<BS>i')
set_keymap('n', '<leader>sh', sidemenu.close)

set_keymap('t', '<Esc>', '<C-\\><C-n>')
