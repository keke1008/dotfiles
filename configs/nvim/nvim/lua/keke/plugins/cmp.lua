local keymap = require("keke.keymap")
local cmp_visible = keymap.lib.StatefulCondition.new(true)
keymap.helper.cmp_visible = cmp_visible

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

            cmp_visible:update(cmp.visible())
            cmp.event:on("menu_opened", function()
                cmp_visible:update(true)
            end)
            cmp.event:on("menu_closed", function()
                cmp_visible:update(false)
            end)

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
                mapping = {},
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
                mapping = {},
                sources = {
                    { name = "cmdline" },
                    { name = "path" },
                },
            })

            cmp.setup.cmdline("/", {
                mapping = {},
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
