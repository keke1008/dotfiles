local remap = require 'keke.remap'
local set_keymap = remap.set_keymap;

vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#disable_default_mappings'] = 1
vim.g['fern#window_selector_use_popup'] = 1

set_keymap('n', '<C-h>', function()
    if vim.o.ft ~= "fern" then
        local prev_buf = vim.api.nvim_get_current_buf()
        vim.w.keke_fern_previous_buffer = prev_buf
    end

    if vim.fn.expand('%') ~= '' then
        vim.cmd "Fern . -reveal=%"
    else
        vim.cmd "Fern ."
    end
end)

local with_close = function(keys)
    return function()
        local prev_win = vim.api.nvim_get_current_win()
        local prev_buf = vim.w.keke_fern_previous_buffer
        vim.w.previous_buffer = nil

        keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
        vim.api.nvim_feedkeys(keys, 'x', false)

        if prev_buf == nil then
            return
        end

        local current_win = vim.api.nvim_get_current_win()
        if current_win ~= prev_win then
            vim.api.nvim_win_set_buf(prev_win, prev_buf)
        end
    end
end

vim.api.nvim_create_autocmd('Filetype', {
    pattern = "fern",
    callback = function()
        vim.fn['glyph_palette#apply']()

        set_keymap('n', 'o', function()
            return vim.fn['fern#smart#leaf'](
                '<Plug>(fern-action-open)',
                '<Plug>(fern-action-expand)',
                '<Plug>(fern-action-collapse)'
            )
        end, { buffer = true, expr = true })

        set_keymap('n', 'e', '<Plug>(fern-action-open-or-enter)', { buffer = true })

        set_keymap('n', 'w', '<Plug>(fern-action-leave)', { buffer = true })

        set_keymap('n', 's', with_close('<Plug>(fern-action-open:select)'), { buffer = true })
        set_keymap('n', 'gs', '<Plug>(fern-action-open:select)', { buffer = true })

        set_keymap('n', 'x', with_close('<Plug>(fern-action-open:split)'), { buffer = true })
        set_keymap('n', 'gx', '<Plug>(fern-action-open:split)', { buffer = true })

        set_keymap('n', 'v', with_close('<Plug>(fern-action-open:vsplit)'), { buffer = true })
        set_keymap('n', 'gv', '<Plug>(fern-action-open:vsplit)', { buffer = true })

        set_keymap('n', 't', with_close('<Plug>(fern-action-open:tabedit)'), { buffer = true })
        set_keymap('n', 'gt', '<Plug>(fern-action-open:tabedit)', { buffer = true })

        set_keymap('n', 'i', '<Plug>(fern-action-hidden:toggle)', { buffer = true })

        set_keymap('n', 'c', '<Plug>(fern-action-mark:toggle)', { buffer = true, nowait = true })

        set_keymap('n', 'd', '<Plug>(fern-action-remove)', { buffer = true, nowait = true })

        set_keymap('n', 'r', '<Plug>(fern-action-rename)', { buffer = true })

        set_keymap('n', '<S-r>', '<Plug>(fern-action-reload:all)', { buffer = true })

        set_keymap('n', 'q', function()
            local prev_buf = vim.w.keke_fern_previous_buffer
            if prev_buf ~= nil then
                vim.w.previous_buffer = nil
                vim.api.nvim_set_current_buf(prev_buf)
            end
        end, { buffer = true })
    end,
})
