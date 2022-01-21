local cmp = require'cmp'

local feedkey = function(key, mode)
    mode = mode or ''
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }),
    mapping = {
        ['<CR>'] = cmp.mapping(function(fallback)
            if   cmp.visible() then cmp.confirm({ select = true })
            else fallback()
            end
        end),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if   has_words_before() then cmp.complete()
            else fallback()
            end
        end, { 'i', 's' }),
        ['<C-j>'] = cmp.mapping(function(fallback)
            if   vim.fn['vsnip#jumpable'](1) == 1 then feedkey('<Plug>(vsnip-jump-next)')
            else fallback()
            end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if   vim.fn['vsnip#jumpable'](-1) == 1 then feedkey('<Plug>(vsnip-jump-prev)')
            else fallback()
            end
        end, { 'i', 's' }),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
    }
})
