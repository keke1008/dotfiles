local cmp = require("cmp")
local compare = cmp.config.compare
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local compare_under_score = require("cmp-under-comparator").under
local remap = vim.keymap.set

local luasnip_jump_prev = function() return luasnip.jump(-1) end
local luasnip_jump_next = function() return luasnip.jump(1) end

remap("n", "<C-j>", luasnip_jump_next)
remap("n", "<C-k>", luasnip_jump_prev)

---@param action fun()
---@return function
local try_remap = function(action)
    return function(fallback)
        if not action() then fallback() end
    end
end

local remap_complete_or = function(action)
    return function()
        if cmp.visible() then
            action()
        else
            cmp.complete()
        end
    end
end

local remap_mode = { "i", "s", "c" }

local format = lspkind.cmp_format({ mode = "symbol_text" })

local function apply_priority(sources)
    for index, source in ipairs(sources) do
        source.priority = #sources - index + 1
    end
    return sources
end

cmp.setup({
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    sources = cmp.config.sources(apply_priority({
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "treesitter" },
    })),
    completion = {
        completeopt = "menuone,noinsert",
    },
    mapping = {
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), remap_mode),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), remap_mode),
        ["<C-j>"] = cmp.mapping(try_remap(luasnip_jump_next), { "i", "s", "c" }),
        ["<C-k>"] = cmp.mapping(try_remap(luasnip_jump_prev), { "i", "s", "c" }),
        ["<C-p>"] = cmp.mapping(remap_complete_or(cmp.select_prev_item), remap_mode),
        ["<C-n>"] = cmp.mapping(remap_complete_or(cmp.select_next_item), remap_mode),
        ["<Tab>"] = cmp.mapping(try_remap(cmp.confirm), remap_mode),
        ["<CR>"] = cmp.mapping(try_remap(cmp.confirm), { "i", "s" }),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = format(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = strings[1]
            kind.menu = strings[2]
            return kind
        end,
    },
    window = {
        completion = cmp.config.window.bordered({
            border = "none",
            col_offset = -2,
        }),
        documentation = cmp.config.window.bordered({
            border = "single",
        }),
    },
    sorting = {
        comparator = {
            compare.offset,
            compare.exact,
            compare.score,
            compare_under_score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
})

cmp.setup.cmdline(":", {
    sources = {
        { name = "cmdline" },
        { name = "path" },
    },
})

cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})
