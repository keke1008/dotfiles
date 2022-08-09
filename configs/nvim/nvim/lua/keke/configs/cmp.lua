local cmp = require 'cmp'
local luasnip = require 'luasnip'


local jump_prev = function()
    return luasnip.jump(-1)
end
local jump_next = function()
    return luasnip.jump(1)
end

---@param action fun()
---@return function
local try_remap = function(action)
    return function(fallback)
        if not action() then
            fallback()
        end
    end
end

cmp.setup {
    snippet = {
        expand = function(args)
            require 'luasnip'.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }),
    completion = {
        completeopt = "menuone,noinsert"
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 's' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 's' }),
        ['<C-j>'] = cmp.mapping(try_remap(jump_next), { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(try_remap(jump_prev), { 'i', 's' }),
        ['<C-p>'] = cmp.mapping(try_remap(cmp.select_prev_item), { 'i', 's' }),
        ['<C-n>'] = cmp.mapping(try_remap(cmp.select_next_item), { 'i', 's' }),
        ['<Tab>'] = cmp.mapping.complete,
        ['<CR>'] = cmp.mapping(try_remap(cmp.confirm), { 'i', 's' }),
    }
}
