local require_all = require'utils'.require_all
local api = vim.api

return require_all('nest', 'cmp', 'luasnip', 'dap')(function(nest, cmp, luasnip, dap)
    local telescope_open = function(cmd, layout_config)
        return function()
            require'telescope.builtin'[cmd]({ layout_strategy = 'cursor', layout_config = layout_config })
        end
    end
    local has_words_before = function()
        local line, col = unpack(api.nvim_win_get_cursor(0))
        return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    local feedkeys = function(keys)
        keys = api.nvim_replace_termcodes(keys, true, true, true)
        api.nvim_feedkeys(keys, 'n', false)
    end
    local dap_enable = function()
        return dap.status() ~= ''
    end
    local dap_map = function(lhs, fn)
        return function()
            if dap_enable() then
                fn()
            else
                feedkeys(lhs)
            end
        end
    end

    nest.applyKeymaps {
        -- Normal mode
        { 'g', {
            { 'a', '<Plug>(EasyAlign)', mode = 'nv' },
            { 'd', telescope_open('lsp_definitions', { width = 0.5, height = 0.5 }) },
            { 'i', telescope_open('lsp_implementations', { width = 0.5, height = 0.5 }) },
            { 'j', '<Plug>(jumpcursor-jump)' },
            { 'r', telescope_open('lsp_references', { width = 0.5, height = 0.5 }) },
            { 'D', vim.lsp.buf.declaration },
        }},
        { 'j', 'gj' },
        { 'k', 'gk' },
        { 'K', function()
            if vim.bo.filetype == 'vim' or vim.bo.filetype == 'help' then
                vim.cmd("help " .. vim.fn.expand('<cword>'))
            elseif dap_enable() then require'dapui'.eval()
            else vim.lsp.buf.hover()
            end
        end},
        { '[g', vim.diagnostic.goto_prev },
        { ']g', vim.diagnostic.goto_next },
        { '<Esc>', 'len(@%) ? "<CMD>w<CR>" : "<Esc>"', options = { expr = true }},
        { '<leader>', {
            { '<leader>', '<CMD>noh<CR>', options = { silent = true }},
            { 'ep', '<CMD>NvimTreeFindFile<CR>' },
            { 'rn', vim.lsp.buf.rename },
            { 'ac', telescope_open('lsp_code_actions', { width = 0.4, height = 0.2 })},
            { 'qf', function() vim.lsp.buf.code_action({ only = 'quickfix'}) end},
            { 'db', function() dap.toggle_breakpoint() end },
        }},
        { '<C-K>', function() vim.diagnostic.open_float({ scope = 'cursor' }) end},

        -- Insert mode / Select mode
        { mode = 'is', {
            { '<C-b>', function() if not cmp.scroll_docs(-4) then feedkeys('<C-b>') end end},
            { '<C-f>', function() if not cmp.scroll_docs(4) then feedkeys('<C-f>') end end},
            { '<C-j>', function()
                if luasnip.jumpable(1) then luasnip.jump(1)
                else feedkeys('<C-j>')
                end
            end},
            { '<C-k>', function()
                if luasnip.jumpable(-1) then luasnip.jump(-1)
                else feedkeys('<C-k>')
                end
            end},
            { '<CR>', options = { silent = true }, function()
                if cmp.visible() then cmp.confirm({ select = true })
                else feedkeys(require'nvim-autopairs'.autopairs_cr())
                end
            end},
            { '<Tab>', function()
                if has_words_before() then cmp.complete()
                else feedkeys('<Tab>')
                end
            end},
            }
        }
    }

    local M = {}
    M.debug = function ()
        if vim.b.debug_keymap then
            return
        end
        vim.b.debug_keymap = true
        nest.applyKeymaps { options = { nowait = true }, buffer = true,
            { 'c', dap_map('c', dap.continue) },
            { 'd', dap_map('d', dap.toggle_breakpoint) },
            { 'i', dap_map('i', dap.step_into) },
            { 'o', dap_map('o', dap.step_over) },
            { 'p', dap_map('p', dap.step_out) },
            { 'r', dap_map('r', dap.run_last) },
            { '<C-q>', dap_map('<C-q>', dap.terminate) },
        }
    end
    vim.cmd[[
        augroup debug_keymap
            autocmd!
            autocmd BufEnter * lua require'keymap'.debug()
        augroup END
    ]]
    return M
end)
