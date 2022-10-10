local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local builtin = require 'telescope.builtin'

local fl = require 'flfiler'
local fl_filer = require 'flfiler.filer'
local flm = require 'flfiler.mapping'

local sidemenu = require 'keke.sidemenu'
local remap = require 'keke.remap'
local set_keymap = remap.set_keymap;

fl.setup { filer = fl_filer.Fern }

vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#disable_default_mappings'] = 1
vim.g['fern#window_selector_use_popup'] = 1

set_keymap('n', '<C-h>', flm.focus_or_launch())

local function call_telescope(builtin_name, selection_key)
    local cwd = vim.fn['fern#helper#new']().fern.root._path

    builtin[builtin_name]({ cwd = cwd })
    actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd([[FernReveal ]] .. selection[selection_key])
    end)
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

        set_keymap('n', 'e', flm.switch(flm.edit(false), flm.expand_or_collapse), { buffer = true })
        set_keymap('n', 'E', flm.switch(flm.edit(true), flm.expand_or_collapse), { buffer = true })
        set_keymap('n', 'w', flm.enter, { buffer = true })
        set_keymap('n', 'q', flm.leave, { buffer = true })
        set_keymap('n', 's', flm.select(false), { buffer = true })
        set_keymap('n', 'S', flm.select(true), { buffer = true })
        set_keymap('n', 'x', flm.split(false), { buffer = true })
        set_keymap('n', 'X', flm.split(true), { buffer = true })
        set_keymap('n', 'v', flm.vsplit(false), { buffer = true })
        set_keymap('n', 'V', flm.vsplit(true), { buffer = true })
        set_keymap('n', 't', flm.tabedit(false), { buffer = true })
        set_keymap('n', 'T', flm.tabedit(true), { buffer = true })

        set_keymap('n', '<C-f>', flm.scroll_down_preview_half, { buffer = true, nowait = true })
        set_keymap('n', '<C-b>', flm.scroll_up_preview_half, { buffer = true })
        set_keymap('n', 'i', '<Plug>(fern-action-hidden:toggle)', { buffer = true })
        set_keymap('n', '<space>', flm.mark, { buffer = true, nowait = true })
        set_keymap('n', 'd', flm.delete, { buffer = true, nowait = true })
        set_keymap('n', 'c', '<Plug>(fern-action-new-path)', { buffer = true, nowait = true })
        set_keymap('n', 'r', flm.rename, { buffer = true })
        set_keymap('n', '<S-r>', '<Plug>(fern-action-reload:all)', { buffer = true })

        set_keymap('n', 'f', find_files, { buffer = true })
        set_keymap('n', 'l', live_grep, { buffer = true })

        set_keymap('n', '<C-h>', flm.close, { buffer = true, nowait = true })
        set_keymap('n', '<Esc>', flm.blur, { buffer = true, nowait = true })
    end,
})

local get_current_reveal = function()
    ---@diagnostic disable-next-line: missing-parameter
    if vim.fn.expand('%') ~= '' then
        return '-reveal=%'
    else
        return ''
    end
end

local tabedit_winid = nil
sidemenu.register('e', {
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
