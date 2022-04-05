require'cmp_nvim_lsp'
local lsp_installer = require'nvim-lsp-installer'
local require_all = require'utils'.require_all

vim.cmd'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()'

require_all('cmp_nvim_lsp')(function (cmp_nvim_lsp)
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
        elseif server.name == 'jdtls' then
            return
        end

        server:setup(opts)
    end)
end)
