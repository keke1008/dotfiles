if not _G.packer_plugins.vimpeccable.loaded then
    return
end

local utils = require'utils'
local vimp = require'vimp'
vimp.always_override = true

local nnoremap = vimp.nnoremap
local nmap = vimp.nmap;

nnoremap('j', 'gj')
nnoremap('k', 'gk')
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
