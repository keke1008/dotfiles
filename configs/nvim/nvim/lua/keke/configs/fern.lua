local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local builtin = require 'telescope.builtin'

local sidemenu = require 'keke.sidemenu'
local remap = require 'keke.remap'
local set_keymap = remap.set_keymap;

vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#disable_default_mappings'] = 1
vim.g['fern#window_selector_use_popup'] = 1

local get_current_reveal = function()
    if vim.fn.expand('%') ~= '' then
        return '-reveal=%'
    else
        return ''
    end
end

set_keymap('n', '<C-h>', function()
    if vim.o.ft ~= "fern" then
        local prev_buf = vim.api.nvim_get_current_buf()
        vim.w.keke_fern_previous_buffer = prev_buf
    end

    vim.cmd('Fern . ' .. get_current_reveal())
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

local function close()
    local prev_buf = vim.w.keke_fern_previous_buffer
    if prev_buf ~= nil then
        vim.w.previous_buffer = nil
        vim.api.nvim_set_current_buf(prev_buf)
    end
end

local function call_telescope(builtin_name, selection_key)
    return function()
        local cwd = vim.fn['fern#helper#new']().fern.root._path

        builtin[builtin_name]({ cwd = cwd })
        actions.select_default:replace(function(prompt_bufnr)
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            vim.cmd([[FernReveal ]] .. selection[selection_key])
        end)
    end
end

local function find_files()
    call_telescope('find_files', 1)
end

local function live_grep()
    if vim.fn.executable('rg') == 0 then
        error('`rg` not found')
    end
    call_telescope('live_grep', 'filename')

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
        set_keymap('n', 'S', '<Plug>(fern-action-open:select)', { buffer = true })
        set_keymap('n', 'x', with_close('<Plug>(fern-action-open:split)'), { buffer = true })
        set_keymap('n', 'X', '<Plug>(fern-action-open:split)', { buffer = true })
        set_keymap('n', 'v', with_close('<Plug>(fern-action-open:vsplit)'), { buffer = true })
        set_keymap('n', 'V', '<Plug>(fern-action-open:vsplit)', { buffer = true })
        set_keymap('n', 't', with_close('<Plug>(fern-action-open:tabedit)'), { buffer = true })
        set_keymap('n', 'T', '<Plug>(fern-action-open:tabedit)', { buffer = true })

        set_keymap('n', 'i', '<Plug>(fern-action-hidden:toggle)', { buffer = true })
        set_keymap('n', '<space>', '<Plug>(fern-action-mark:toggle)', { buffer = true, nowait = true })
        set_keymap('n', 'd', '<Plug>(fern-action-remove)', { buffer = true, nowait = true })
        set_keymap('n', 'c', '<Plug>(fern-action-new-path)', { buffer = true, nowait = true })
        set_keymap('n', 'r', '<Plug>(fern-action-rename)', { buffer = true })
        set_keymap('n', '<S-r>', '<Plug>(fern-action-reload:all)', { buffer = true })

        set_keymap('n', 'f', find_files, { buffer = true })
        set_keymap('n', 'l', live_grep, { buffer = true })

        set_keymap('n', '<C-h>', close, { buffer = true, nowait = true })
        set_keymap('n', '<Esc>', close, { buffer = true, nowait = true })
        set_keymap('n', 'q', close, { buffer = true })
    end,
})

local tabedit_winid = nil
sidemenu.register('<leader>se', {
    name = 'fern',
    open = function()
        if tabedit_winid == nil or not vim.api.nvim_win_is_valid(tabedit_winid) then
            vim.cmd('Fern . -drawer ' .. get_current_reveal())
            tabedit_winid = vim.api.nvim_get_current_win()
        end
    end,
    close = function()
        if tabedit_winid == nil then
            return
        end
        if vim.api.nvim_win_is_valid(tabedit_winid) then
            vim.api.nvim_win_close(tabedit_winid, false)
        end
        tabedit_winid = nil
    end
})
