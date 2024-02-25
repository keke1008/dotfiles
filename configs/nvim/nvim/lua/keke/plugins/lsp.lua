local drawer = require("drawer")

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        dependencies = {
            { "folke/neoconf.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local root_pattern = require("lspconfig.util").root_pattern
            local lsp = require("keke.utils.lsp")

            mason.setup()
            mason_lspconfig.setup()

            mason_lspconfig.setup_handlers({
                function(server_name) lspconfig[server_name].setup(lsp.default_config) end,
                ["denols"] = function(_)
                    lspconfig.denols.setup(lsp.extend_default_config({
                        root_dir = root_pattern("deno.json", "deno.jsonc"),
                    }))
                end,
                ["clangd"] = function(_)
                    lspconfig.clangd.setup(lsp.extend_default_config({
                        on_attach = function(_, bufnr)
                            local opts = { buffer = bufnr, silent = true }
                            vim.keymap.set("n", "<leader>ls", "<CMD>ClangdSwitchSourceHeader<CR>", opts)
                        end,
                    }))
                end,
                ["lua_ls"] = function(_)
                    -- neodev.nvim
                end,
                ["tsserver"] = function(_)
                    -- typescript.nvim
                end,
            })
        end
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        lazy = false,
        config = function()
            local null_ls = require("null-ls")
            local utils = require("null-ls.utils")

            ---@param cmd string
            ---@return boolean
            local function executable(cmd) return vim.fn.executable(cmd) == 1 end

            local PREFER_LOCAL_NODE_BIN = "node_modules/.bin"

            ---@enum SourceMethod
            local METHOD = {
                code_actions = "code_actions",
                completion = "completion",
                diagnostics = "diagnostics",
                formatting = "formatting",
                hover = "hover",
            }

            ---@class Source
            ---@field method SourceMethod | SourceMethod[]
            ---@field command? string
            ---@field disable? fun(): boolean
            ---@field prefer_local? string

            ---@param name string
            ---@param source Source
            ---@return unknown[]: list of null-ls sources
            local function generate_source(name, source)
                local command = source.command or name
                local disable = source.disable or function() return false end
                local option = {
                    condition = function() return executable(command) and not disable() end,
                    prefer_local = source.prefer_local,
                }

                return vim.tbl_map(
                    function(method) return null_ls.builtins[method][name].with(option) end,
                    type(source.method) == "table" and source.method or { source.method } --[=[@as SourceMethod[]]=]
                )
            end

            ---@type table<string, Source>
            local register_source_list = {
                -- Lua
                stylua = { method = METHOD.formatting },
                luacheck = { method = METHOD.diagnostics },

                -- JavaScript/TypeScript/..
                eslint = {
                    method = { METHOD.diagnostics, METHOD.code_actions },
                    prefer_local = PREFER_LOCAL_NODE_BIN,
                    disable = function() return executable("eslint_d") end,
                },
                eslint_d = {
                    method = { METHOD.diagnostics, METHOD.code_actions },
                    prefer_local = PREFER_LOCAL_NODE_BIN,
                },
                prettier = {
                    method = METHOD.formatting,
                    prefer_local = PREFER_LOCAL_NODE_BIN,
                    disable = function() return executable("prettierd") end,
                },
                prettierd = {
                    method = METHOD.formatting,
                    prefer_local = PREFER_LOCAL_NODE_BIN,
                },

                -- Python
                flake8 = { method = METHOD.diagnostics },
                pylint = { method = METHOD.diagnostics },
                mypy = { method = METHOD.diagnostics },
                vulture = { method = METHOD.diagnostics },
                black = { method = METHOD.formatting },
                isort = { method = METHOD.formatting },
                autopep8 = { method = METHOD.formatting },

                -- Ruby
                rubocop = { method = { METHOD.diagnostics, METHOD.formatting } },
                erb_lint = {
                    method = { METHOD.diagnostics, METHOD.formatting },
                    command = "erblint",
                },

                -- Shell Script
                shellcheck = { method = { METHOD.code_actions, METHOD.diagnostics } },

                -- C/C++
                cpplint = { method = METHOD.diagnostics },

                -- Spell Checker
                cspell = { method = { METHOD.diagnostics, METHOD.code_actions } },
            }

            local sources = {}
            for name, register_source in pairs(register_source_list) do
                vim.list_extend(sources, generate_source(name, register_source))
            end

            null_ls.setup({
                sources = sources,
                root_dir = utils.root_pattern(".null-ls-root", "neoconf.json", ".git", "Makefile"),
            })
        end
    },
    {
        "L3MON4D3/LuaSnip",
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets" },
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
        end

    },
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

            local luasnip_jump_prev = function() return luasnip.jump(-1) end
            local luasnip_jump_next = function() return luasnip.jump(1) end

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
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer" },
                    { name = "treesitter" },
                })),
                completion = {
                    completeopt = "menuone",
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), remap_mode),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), remap_mode),
                    ["<C-j>"] = cmp.mapping(try_remap(luasnip_jump_next), remap_mode),
                    ["<C-k>"] = cmp.mapping(try_remap(luasnip_jump_prev), remap_mode),
                    ["<C-p>"] = cmp.mapping(remap_complete_or(cmp.select_prev_item), remap_mode),
                    ["<C-n>"] = cmp.mapping(remap_complete_or(cmp.select_next_item), remap_mode),
                    ["<CR>"] = cmp.mapping(try_remap(cmp.confirm), { "i", "s" }),
                    ["<C-e>"] = cmp.mapping(function()
                        cmp.abort()
                        vim.api.nvim_input("<CR>")
                    end, remap_mode),
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
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        init = function()
            drawer.register({
                name = "trouble",
                positions = { "bottom" },
                open = "Trouble",
                close = "TroubleClose",
            })
        end,
        cmd = "Trouble",
        keys = {
            { drawer.with_prefix_key("t"), function() drawer.open("trouble") end, mode = "n", desc = "Trouble" },
        },
        opts = {
            action_keys = {
                open_split = "s",
                open_vsplit = "v",
                open_tab = "t",
                toggle_fold = "e",
            },
        }
    },
    {
        "glepnir/lspsaga.nvim",
        cmd = "Lspsaga",
        config = function()
            local saga = require("lspsaga")

            saga.setup({
                ui = {
                    border = "rounded",
                },
                lightbulb = {
                    enable = false,
                },
                finder = {
                    open = "e",
                    vsplit = "v",
                    split = "i",
                    tabe = "t",
                    quit = "<ESC>",
                },
                definition = {
                    edit = "<leader>:e",
                    vsplit = "<leader>:v",
                    split = "<leader>:s",
                    tabe = "<leader>:t",
                },
                outline = {
                    keys = {
                        jump = "e",
                    },
                },
                symbol_in_winbar = {
                    enable = true,
                },
            })

            vim.api.nvim_set_hl(0, "SagaBorder", { link = "FloatBorder" })
        end
    },
    {
        "petertriho/nvim-scrollbar",
        opts = function()
            local colors = require("tokyonight.colors").setup()
            return {
                handle = {
                    color = colors.bg_highlight,
                },
                marks = {
                    Search = { color = colors.orange },
                    Error = { color = colors.error },
                    Warn = { color = colors.warning },
                    Info = { color = colors.info },
                    Hint = { color = colors.hint },
                    Misc = { color = colors.purple },
                },
            }
        end

    },
    {
        "folke/neodev.nvim",
        ft = "lua",
        config = function()
            local lsp = require("keke.utils.lsp")

            require("neodev").setup()
            require("lspconfig").lua_ls.setup(lsp.default_config)
        end
    },
    {
        "simrat39/rust-tools.nvim",
        ft = "rust",
        config = function()
            local rt = require("rust-tools")
            local rt_dap = require("rust-tools.dap")
            local mason_registry = require("mason-registry")
            local lsp = require("keke.utils.lsp")
            local map = require("keke.utils.mapping")

            rt.setup({
                server = lsp.extend_default_config({
                    on_attach = function(_, bufnr)
                        local opts = { buffer = bufnr }
                        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, map.add_desc(opts, "Lsp show hover"))
                        vim.keymap.set(
                            "n",
                            "<leader>la",
                            rt.code_action_group.code_action_group,
                            map.add_desc(opts, "Lsp code action")
                        )
                        vim.keymap.set("n", "<leader>lp", rt.parent_module.parent_module,
                            map.add_desc(opts, "Lsp parent module"))
                    end,
                }),
                tools = {
                    inlay_hints = {
                        parameter_hints_prefix = "", -- \uf54d
                        other_hints_prefix = " ", -- \uf554
                    },
                },
                dap = (function()
                    if not mason_registry.is_installed("codelldb") then
                        return
                    end

                    local install_path = mason_registry.get_package("codelldb"):get_install_path()
                    local codelldb_path = install_path .. "/extension/adapter/codelldb"
                    local liblldb_path = install_path .. "/extension/lldb/lib/liblldb.so"

                    return { adapter = rt_dap.get_codelldb_adapter(codelldb_path, liblldb_path) }
                end)(),
            })
        end
    },
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },
    {
        "jose-elias-alvarez/typescript.nvim",
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        config = function()
            local util = require("lspconfig.util")
            local typescript = require("typescript")

            local lsp = require("keke.utils.lsp")

            local is_deno_project = util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd())
            if is_deno_project then
                return
            end

            typescript.setup({
                server = lsp.extend_default_config({
                    root_dir = util.find_package_json_ancestor,
                    on_attach = function(_, bufnr)
                        vim.keymap.set("n", "<leader>lm", "<CMD>TypescriptAddMissingImports<CR>",
                            { buffer = bufnr, silent = true })
                        vim.keymap.set("n", "<leader>lR", "<CMD>TypescriptRenameFile<CR>",
                            { buffer = bufnr, silent = true })
                    end,
                }),
            })
        end
    },
    {
        "akinsho/flutter-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "dart",
        config = function()
            local flutter_tools = require("flutter-tools")
            local lsp = require("keke.utils.lsp")

            flutter_tools.setup({
                lsp = {
                    capabilities = lsp.default_config.capabilities,
                },
                flutter_lookup_cmd = vim.fn.executable("asdf") and "asdf where flutter",
            })

            local ok, telescope = pcall(require, "telescope")
            if ok then
                telescope.load_extension("flutter")
            end
        end
    },

}
