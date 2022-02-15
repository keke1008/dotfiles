local lsp_installer = require'nvim-lsp-installer'
local nnoremap = require'vimp'.nnoremap
local api = vim.api;



-- Open telescope result in another tab
vim.cmd[[autocmd TabNew,VimEnter * lua vim.api.nvim_tabpage_set_var(0, 'lsp_jump_window_handle', nil)]]
local telescope_open = function(cmd, layout_config)
    local function current_tab_contains_window(window)
        if type(window) ~= "number" then
            return false
        end
        local win_list_in_current_tab = api.nvim_tabpage_list_wins(0)
        for _, winid in pairs(win_list_in_current_tab) do
            if window == winid then
                return true
            end
        end
        return false
    end

    return function()
        local jump_window_handle = api.nvim_tabpage_get_var(0, 'lsp_jump_window_handle')
        if not current_tab_contains_window(jump_window_handle) then
            vim.cmd('vsplit')
            local current_window_handle = api.nvim_get_current_win()
            api.nvim_tabpage_set_var(0, 'lsp_jump_window_handle', current_window_handle)
            jump_window_handle = current_window_handle
        end
        local buffer_handle = vim.api.nvim_get_current_buf()
        api.nvim_set_current_win(jump_window_handle)
        api.nvim_set_current_buf(buffer_handle)

        require'telescope.builtin'[cmd]({
            layout_strategy = 'cursor',
            layout_config = layout_config }
        )
    end
end

nnoremap({ 'silent' }, 'gD', vim.lsp.buf.declaration)
nnoremap({ 'silent' }, 'gd', telescope_open('lsp_definitions', { width = 0.5, height = 0.5 }))
nnoremap({ 'silent' }, 'gi', telescope_open('lsp_implementations', { width = 0.5, height = 0.5 }))
nnoremap({ 'silent' }, 'gr', telescope_open('lsp_references', { width = 0.5, height = 0.5 }))
nnoremap({ 'silent' }, 'K', function()
    if vim.bo.filetype == 'vim' or vim.bo.filetype == 'help' then
        vim.cmd("help " .. vim.fn.expand('<cword>'))
    else
        vim.lsp.buf.hover()
    end
end)
nnoremap({ 'silent' }, '<C-K>', function () vim.diagnostic.open_float({ scope = 'cursor' }) end)
nnoremap({ 'silent' }, '[g', vim.diagnostic.goto_prev)
nnoremap({ 'silent' }, ']g', vim.diagnostic.goto_next)
nnoremap({ 'silent' }, '<leader>rn', vim.lsp.buf.rename)
nnoremap({ 'silent' }, '<leader>ac', telescope_open('lsp_code_actions', { width = 0.4, height = 0.2 }))
nnoremap({ 'silent' }, '<leader>qf', function() vim.lsp.buf.code_action({ only = 'quickfix' }) end)

vim.cmd'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()'

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp_installer.on_server_ready(function(server)
    require'lsp_signature'.on_attach()

    local opts = {
        capabilities = capabilities
    }

    if server.name == 'rust-_analyzer' then
        return
    end

    if server.name == 'denols' then
        opts = {
            settings = {
                deno = {
                    enable = true,
                    lint = true,
                    config = './deno.json',
                    importMap = './import_map.json',
                },
            },
        }
    end

    if server.name == 'sumneko_lua' then
        opts = require'lua-dev'.setup({})
    end

    server:setup(opts)
end)
