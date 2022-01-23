local vimp = require'vimp'
local nmap = vimp.nmap;
local del_map = vim.api.nvim_del_keymap

del_map('n', 's')
del_map('n', 'S')
del_map('v', 's')
del_map('n', ';')
nmap({ 'silent' }, ';', '<Plug>Sneak_s')
nmap({ 'silent' }, '+', '<Plug>Sneak_S')
