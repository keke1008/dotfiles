local vimp = require'vimp'
local utils = require'utils'
vimp.always_override = true

local nnoremap = vimp.nnoremap
local nmap = vimp.nmap;
local xmap = vimp.xmap;
local del_map = vim.api.nvim_del_keymap

nnoremap('j', 'gj')
nnoremap('k', 'gk')
nnoremap('+', ',')
nmap({ 'silent' }, '<leader><Space>', '<CMD>noh<CR>')
nmap({ 'expr' }, '<Esc>', 'len(@%) ? "<CMD>w<CR>" : "<Esc>"')

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
  nnoremap('<C-w>h', change_active_pain("h", "-L"))
  nnoremap('<C-w>j', change_active_pain("j", "-D"))
  nnoremap('<C-w>k', change_active_pain("k", "-U"))
  nnoremap('<C-w>l', change_active_pain("l", "-R"))
end

del_map('n', 's')
del_map('n', 'S')
del_map('v', 's')
nmap({ 'silent' }, ';', '<Plug>Sneak_s')
nmap({ 'silent' }, '+', '<Plug>Sneak_S')

nmap('ga', '<Plug>(EasyAlign)')
xmap('ga', '<Plug>(EasyAlign)')
