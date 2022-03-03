local utils = require'utils'

utils.requires({ 'vimp' }, function(vimp)
    vimp.always_override = true

    local nnoremap = vimp.nnoremap
    local nmap = vimp.nmap
    local xmap = vimp.xmap

    nnoremap('j', 'gj')
    nnoremap('k', 'gk')
    nmap({ 'silent' }, '<leader><Space>', '<CMD>noh<CR>')
    nmap({ 'expr' }, '<Esc>', 'len(@%) ? "<CMD>w<CR>" : "<Esc>"')
    nmap('ga', '<Plug>(EasyAlign)')
    xmap('ga', '<Plug>(EasyAlign)')

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
end)

if not require'utils'.no_vscode() then
    vim.cmd[[
        nnoremap <Esc> <CMD>call VSCodeNotify('workbench.action.files.save')<CR>
        nnoremap <Space>ep <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>
        nnoremap <Space>ac <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
        nnoremap <Space>rn <Cmd>call VSCodeNotify('editor.action.rename')<CR>
        nnoremap <Space>ks <Cmd>call VSCodeNotify('workbench.action.openGlobalKeybindings')<CR>
        nnoremap gd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
        nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
        nnoremap [g <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
        nnoremap ]g <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
        nnoremap / <Cmd>call VSCodeNotify('actions.find')<CR>
    ]]
end
