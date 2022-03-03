local lsp_installer = require'nvim-lsp-installer'
local nnoremap = require'vimp'.nnoremap

local telescope_open = function(cmd, layout_config)
    return function()
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

require'utils'.requires({'cmp_nvim_lsp'}, function(cmp_nvim_lsp)
    local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

    lsp_installer.on_server_ready(function(server)
        local opts = {
            capabilities = capabilities,
            on_attach = function()
                require'lsp_signature'.on_attach()
            end,
        }

        if server.name == 'denols' then
            opts.settings = {
                deno = {
                    enable = true,
                    lint = true,
                    config = './deno.json',
                    importMap = './import_map.json',
                },
            }
        elseif server.name == 'sumneko_lua' then
            opts = require'lua-dev'.setup({})
            opts.capabilities = capabilities
        end

        server:setup(opts)
    end)
end)
