local require_all = require'utils'.require_all

require_all('cmp')(function (cmp)
    cmp.setup({
        snippet = {
            expand = function(args)
                put(args)
                require'luasnip'.lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }),
        completion = {
            completeopt = "menuone,noinsert"
        }
    })
end)
