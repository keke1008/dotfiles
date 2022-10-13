local sidemenu = require 'keke.sidemenu'
local remap = require 'keke.remap'
local set_keymap = remap.set_keymap;

local filer = require 'floating-fern.api.mapping'

vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#disable_default_mappings'] = 1
vim.g['fern#window_selector_use_popup'] = 1
vim.g['fern#keepjumps_on_edit'] = 1

set_keymap('n', '<C-h>', filer.smart_open(filer.focus, filer.open))

vim.api.nvim_create_autocmd('Filetype', {
    pattern = "fern",
    callback = function()
        vim.fn['glyph_palette#apply']()

        set_keymap('n', 'e', filer.smart_leaf(filer.edit, 'collapse', 'expand'), { buffer = true })
        set_keymap('n', 'E', filer.smart_leaf(filer.edit_stay, 'collapse', 'expand'), { buffer = true })
        set_keymap('n', 's', filer.select, { buffer = true })
        set_keymap('n', 'S', filer.select_stay, { buffer = true })
        set_keymap('n', 'x', filer.split, { buffer = true })
        set_keymap('n', 'X', filer.split_stay, { buffer = true })
        set_keymap('n', 'v', filer.vsplit, { buffer = true })
        set_keymap('n', 'V', filer.vsplit_stay, { buffer = true })
        set_keymap('n', 't', filer.tabedit, { buffer = true })
        set_keymap('n', 'T', filer.tabedit_stay, { buffer = true })
        set_keymap('n', 'w', '<Plug>(fern-action-enter)', { buffer = true })
        set_keymap('n', 'b', '<Plug>(fern-action-leave)', { buffer = true, nowait = true })

        set_keymap('n', 'i', '<Plug>(fern-action-hidden:toggle)', { buffer = true })
        set_keymap('n', '<space>', '<Plug>(fern-action-mark:toggle)', { buffer = true, nowait = true })
        set_keymap('n', 'd', '<Plug>(fern-action-remove)', { buffer = true, nowait = true })
        set_keymap('n', 'c', '<Plug>(fern-action-new-path)', { buffer = true, nowait = true })
        set_keymap('n', 'r', filer.rename, { buffer = true })
        set_keymap('n', '<S-r>', '<Plug>(fern-action-reload:all)', { buffer = true })

        set_keymap('n', 'p', '<Plug>(fern-action-preview:auto:toggle)', { buffer = true })
        set_keymap('n', '<C-f>', filer.scroll_preview_down_half, { buffer = true })
        set_keymap('n', '<C-b>', filer.scroll_preview_up_half, { buffer = true })

        set_keymap('n', 'f', filer.telescope_find_files, { buffer = true })
        set_keymap('n', 'l', filer.telescope_live_grep, { buffer = true })

        set_keymap('n', 'q', filer.blur, { buffer = true })
        set_keymap('n', '<C-h>', filer.close, { buffer = true, nowait = true })
        set_keymap('n', '<Esc>', filer.close, { buffer = true, nowait = true })
    end,
})

local drawer_winid = nil
sidemenu.register('e', {
    name = 'fern',
    open = function()
        local reveal = vim.fn.expand('%') and '-reveal=%' or ''
        if drawer_winid == nil or not vim.api.nvim_win_is_valid(drawer_winid) then
            vim.cmd('Fern . -drawer ' .. reveal)
            drawer_winid = vim.api.nvim_get_current_win()
        end
    end,
    close = function()
        if drawer_winid == nil then
            return
        end
        if vim.api.nvim_win_is_valid(drawer_winid) then
            vim.api.nvim_win_close(drawer_winid, false)
        end
        drawer_winid = nil
    end
})
