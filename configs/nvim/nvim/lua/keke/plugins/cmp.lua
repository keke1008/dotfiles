return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "ray-x/cmp-treesitter",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
            "lukas-reineke/cmp-under-comparator",
        },
        config = function()
            local cmp = require("cmp")
            local compare = cmp.config.compare
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            local compare_under_score = require("cmp-under-comparator").under

            local luasnip_jump_prev = function()
                return luasnip.jump(-1)
            end
            local luasnip_jump_next = function()
                return luasnip.jump(1)
            end

            vim.keymap.set("n", "<C-j>", luasnip_jump_next, { desc = "luasnip jump next" })
            vim.keymap.set("n", "<C-k>", luasnip_jump_prev, { desc = "luasnip jump prev" })

            ---@param action fun()
            ---@return function
            local try_remap = function(action)
                return function(fallback)
                    if not action() then
                        fallback()
                    end
                end
            end

            local remap_complete_or = function(action, arg)
                return function()
                    if cmp.visible() then
                        action(arg)
                    else
                        cmp.complete()
                    end
                end
            end

            local remap_mode = { "i", "s", "c" }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = (function()
                    local sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                        { name = "path" },
                        { name = "treesitter" },
                        { name = "buffer" },
                    })
                    table.insert(sources, { name = "lazydev", group_index = 0 })
                    return sources
                end)(),
                completion = {
                    completeopt = "menu,menuone",
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), remap_mode),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), remap_mode),
                    ["<C-j>"] = cmp.mapping(try_remap(luasnip_jump_next), remap_mode),
                    ["<C-k>"] = cmp.mapping(try_remap(luasnip_jump_prev), remap_mode),
                    ["<C-p>"] = cmp.mapping(
                        -- Prevents completion from terminating with the expansion of the snippet
                        -- when a completion candidate is selected, as in the `call` snippet of rust-analyzer.
                        remap_complete_or(cmp.select_prev_item, { behavior = cmp.SelectBehavior.Select }),
                        remap_mode
                    ),
                    ["<C-n>"] = cmp.mapping(
                        remap_complete_or(cmp.select_next_item, { behavior = cmp.SelectBehavior.Select }),
                        remap_mode
                    ),
                    ["<CR>"] = cmp.mapping(try_remap(cmp.confirm), { "i", "s" }),
                    ["<C-e>"] = cmp.mapping(function()
                        cmp.abort()
                        vim.api.nvim_input("<CR>")
                    end, remap_mode),
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = (function()
                        local format = lspkind.cmp_format({ mode = "symbol_text" })
                        return function(entry, vim_item)
                            local kind = format(entry, vim_item)
                            local strings = vim.split(kind.kind, "%s", { trimempty = true })
                            kind.kind = strings[1]
                            kind.menu = strings[2]
                            return kind
                        end
                    end)(),
                    expandable_indicator = true,
                },
                window = {
                    completion = cmp.config.window.bordered({
                        border = "none",
                        col_offset = -2,
                    }),
                    documentation = cmp.config.window.bordered({
                        winhighlight = "",
                        side_padding = 2,
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
                mapping = {
                    ["<Tab>"] = cmp.mapping(try_remap(cmp.confirm), { "c" }),
                },
                sources = {
                    { name = "cmdline" },
                    { name = "path" },
                },
            })

            cmp.setup.cmdline("/", {
                mapping = {
                    ["<Tab>"] = cmp.mapping(try_remap(cmp.confirm), { "c" }),
                },
                sources = {
                    { name = "buffer" },
                },
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        event = "InsertEnter",
        config = function()
            local loader = require("luasnip.loaders.from_vscode")

            loader.lazy_load()

            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node

            -- stylua: ignore
            ls.add_snippets("lua", {
                s("module", {
                    t({ "local M = {}", "" }),
                    t("\t"), i(0),
                    t({ "", "return M" }),
                }),
            })
        end,
    },
}
