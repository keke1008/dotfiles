local require_all = require 'utils'.require_all
local api = vim.api

local TemporaryKeymapMetatable = {
    __index = {
        buf_enter = function(self)
            local loaded = vim.b[self.name]
            local cond = self.cond()
            if cond and not loaded then
                self.install()
                vim.b[self.name] = true
            elseif not cond and loaded then
                self.uninstall()
                vim.b[self.name] = false
            end
        end
    }
}

local TemporaryKeymap = {
    new = function(name, functions)
        vim.validate({
            name = { name, 'string' },
            cond = { functions.cond, 'function' },
            install = { functions.install, 'function' },
            uninstall = { functions.uninstall, 'function' },
        })
        return setmetatable(
            { name = name, cond = functions.cond, install = functions.install, uninstall = functions.uninstall },
            TemporaryKeymapMetatable
        )
    end
}

return require_all('nest', 'cmp', 'luasnip', 'dap', 'neoscroll')(function(nest, cmp, luasnip, dap, neoscroll)
    local telescope_open = function(cmd, layout_config)
        return function()
            require 'telescope.builtin'[cmd]({ layout_strategy = 'cursor', layout_config = layout_config })
        end
    end
    local has_words_before = function()
        local line, col = unpack(api.nvim_win_get_cursor(0))
        return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    local feedkeys = function(keys)
        keys = api.nvim_replace_termcodes(keys, true, true, true)
        api.nvim_feedkeys(keys, 'int', false)
    end
    local dap_active = function()
        return dap.status() ~= ''
    end
    local dap_map = function(lhs, fn)
        return function()
            if dap_active() then
                fn()
            else
                feedkeys(lhs)
            end
        end
    end

    local scroll = function(lines)
        print(lines)
        local speed = 100;
        if lines == "zt" then
            neoscroll.zt(speed)
        elseif lines == "zz" then
            neoscroll.zz(speed)
        elseif lines == "zb" then
            neoscroll.zb(speed)
        else
            neoscroll.scroll(lines, true, speed)
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
        } },
        { 'j', 'gj' },
        { 'k', 'gk' },
        { 'K', function()
            if vim.bo.filetype == 'vim' or vim.bo.filetype == 'help' then
                vim.cmd("help " .. vim.fn.expand('<cword>'))
            elseif dap_active() then require 'dapui'.eval()
            else vim.lsp.buf.hover()
            end
        end },
        { '[g', vim.diagnostic.goto_prev },
        { ']g', vim.diagnostic.goto_next },
        { '<Esc>', 'len(@%) ? "<CMD>w<CR>" : "<Esc>"', options = { expr = true } },
        { '<leader>', {
            { '<leader>', '<CMD>noh<CR>', options = { silent = true } },
            { 'ep', '<CMD>NvimTreeFindFile<CR>' },
            { 'rn', vim.lsp.buf.rename },
            { 'ac', telescope_open('lsp_code_actions', { width = 0.4, height = 0.2 }) },
            { 'qf', function() vim.lsp.buf.code_action({ only = 'quickfix' }) end },
            { 'db', function() dap.toggle_breakpoint() end },
            { 'dc', function() dap.continue() end },
        } },
        { '<C-K>', function() vim.diagnostic.open_float({ scope = 'cursor' }) end },
        { '<C-u>', function() scroll(-vim.wo.scroll) end },
        { '<C-d>', function() scroll(vim.wo.scroll) end },
        { '<C-f>', function() scroll(vim.api.nvim_win_get_height(0)) end },
        { '<C-b>', function() scroll(-vim.api.nvim_win_get_height(0)) end },
        { 'zt', function() scroll('zt') end },
        { 'zz', function() scroll('zz') end },
        { 'zb', function() scroll('zb') end },
        { 'gg', function() scroll(-vim.fn.line('.') + 1) end },
        { 'G', function() scroll(vim.fn.line('$') - vim.fn.line('.')) end },

        -- Insert mode / Select mode
        { mode = 'is', {
            { '<C-b>', function() if not cmp.scroll_docs(-4) then feedkeys('<C-b>') end end },
            { '<C-f>', function() if not cmp.scroll_docs(4) then feedkeys('<C-f>') end end },
            { '<C-j>', function()
                if luasnip.jumpable(1) then luasnip.jump(1)
                else feedkeys('<C-j>')
                end
            end },
            { '<C-k>', function()
                if luasnip.jumpable(-1) then luasnip.jump(-1)
                else feedkeys('<C-k>')
                end
            end },
            { '<CR>', options = { silent = true }, function()
                if cmp.visible() then cmp.confirm({ select = true })
                else feedkeys(require 'nvim-autopairs'.autopairs_cr())
                end
            end },
            { '<Tab>', function()
                if has_words_before() then cmp.complete()
                else feedkeys('<Tab>')
                end
            end },
        },
            { '<C-n>', function()
                if cmp.visible() then cmp.select_next_item()
                else feedkeys('<C-n>')
                end
            end },
            { '<C-p>', function()
                if cmp.visible() then cmp.select_prev_item()
                else feedkeys('<C-n>')
                end
            end }
        }
    }


    local debug_keymap = TemporaryKeymap.new('debug_keymap', {
        cond = dap_active,
        install = function()
            nest.applyKeymaps { options = { nowait = true }, buffer = true, {
                { 'c', dap_map('c', dap.continue) },
                { 'd', dap_map('d', dap.toggle_breakpoint) },
                { 'i', dap_map('i', dap.step_into) },
                { 'o', dap_map('o', dap.step_over) },
                { 'p', dap_map('p', dap.step_out) },
                { 'r', dap_map('r', dap.run_last) },
                { '<C-q>', dap_map('<C-q>', dap.terminate) } }
            }
        end,
        uninstall = function()
            local lhses = { 'c', 'd', 'i', 'o', 'p', 'r', '<C-q>' }
            for _, lhs in pairs(lhses) do
                pcall(api.nvim_buf_del_keymap, 0, 'n', lhs)
            end
        end
    })

    local M = {}
    M.debug_keymap = debug_keymap

    vim.cmd [[
        augroup debug_keymap
            autocmd!
            autocmd BufEnter * lua require'keymap'.debug_keymap:buf_enter()
        augroup END
    ]]
    return M
end)
