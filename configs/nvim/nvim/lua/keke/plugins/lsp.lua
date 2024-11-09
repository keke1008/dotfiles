local drawer = require("drawer")
local map = require("keke.utils.mapping")

local lsp_setup_config = (function()
    local default_config = nil

    local function init_default_config()
        if default_config ~= nil then
            return
        end

        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if not ok then
            vim.notify("com_nvim_lsp is not loaded", vim.log.levels.ERROR)
            return
        end

        local default_capabilities = vim.lsp.protocol.make_client_capabilities()
        local cmp_capabilities = cmp_nvim_lsp.default_capabilities()
        default_config = {
            capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities),
        }
    end

    ---@param overrides table | nil
    ----@return table
    return function(overrides)
        overrides = overrides or {}
        init_default_config()
        return vim.tbl_deep_extend("force", default_config, overrides)
    end
end)()

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- `require("neoconf").setup()` should be run **BEFORE** setting up
            -- any lsp server with lspconfig
            { "folke/neoconf.nvim", config = true },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("keke_lsp_setting_lsp_attach", {}),
                desc = "Setup LSP settings for buffer",
                callback = function(args)
                    local bufnr = args.buf

                    local function refresh_codelens()
                        local client = vim.lsp.get_clients({ method = "textDocument/codeLens", bufnr = bufnr })
                        if #client > 0 then
                            vim.lsp.codelens.refresh({ bufnr = bufnr })
                        end
                    end

                    vim.api.nvim_create_autocmd("InsertLeave", {
                        group = vim.api.nvim_create_augroup("keke_lsp_codelens_buf_" .. bufnr, {}),
                        desc = "Refresh codelens",
                        buffer = bufnr,
                        callback = refresh_codelens,
                    })
                    refresh_codelens()
                end,
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        event = "VeryLazy",
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local root_pattern = require("lspconfig.util").root_pattern

            mason_lspconfig.setup()
            mason_lspconfig.setup_handlers({
                function(server_name) lspconfig[server_name].setup(lsp_setup_config()) end,
                ["denols"] = function(_)
                    lspconfig.denols.setup(lsp_setup_config({
                        root_dir = root_pattern("deno.json", "deno.jsonc"),
                    }))
                end,
                ["clangd"] = function(_)
                    lspconfig.clangd.setup(lsp_setup_config({
                        on_attach = function(_, bufnr)
                            local opts = { buffer = bufnr, silent = true }
                            vim.keymap.set("n", "<leader>ls", "<CMD>ClangdSwitchSourceHeader<CR>", opts)
                        end,
                    }))
                end,
                ["lua_ls"] = function(_)
                    -- lazydev.nvim
                end,
                ["ts_ls"] = function(_)
                    -- typescript.nvim
                end,
                ["rust_analyzer"] = function(_)
                    -- rustaceanvim
                end,
            })
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
        },
    },
    {
        "nvimdev/lspsaga.nvim",
        cmd = "Lspsaga",
        init = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("keke_lspsaga_lsp_attach", {}),
                desc = "Lspsaga buffer local configs",
                callback = function(args)
                    local bufnr = args.buf
                    local opts = { buffer = bufnr, silent = true }

                    vim.keymap.set("n", "gd", "<CMD>Lspsaga goto_definition<CR>", opts)
                    vim.keymap.set("n", "gr", "<CMD>Lspsaga finder<CR>", opts)
                    vim.keymap.set("n", "[e", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opts)
                    vim.keymap.set("n", "]e", "<CMD>Lspsaga diagnostic_jump_next<CR>", opts)
                    vim.keymap.set("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>", opts)
                    vim.keymap.set("n", "<leader>la", "<CMD>Lspsaga code_action<CR>", opts)
                    vim.keymap.set("n", "<leader>lr", "<CMD>Lspsaga rename<CR>", opts)
                    vim.keymap.set("n", "<leader>le", "<CMD>Lspsaga show_cursor_diagnostics<CR>", opts)
                    vim.keymap.set("n", "<leader>lp", "<CMD>Lspsaga peek_definition<CR>", opts)
                    vim.keymap.set("n", "<leader>li", "<CMD>Lspsaga incoming_calls<CR>", opts)
                    vim.keymap.set("n", "<leader>lo", "<CMD>Lspsaga outgoing_calls<CR>", opts)
                end,
            })
        end,
        opts = {
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
                enable = false,
            },
        },
    },
    {
        "folke/lazydev.nvim",
        dependencies = {
            { "folke/neoconf.nvim", optional = true },
        },
        ft = "lua",
        event = "VeryLazy",
        config = function()
            local lazydev = require("lazydev")
            local lspconfig = require("lspconfig")

            lazydev.setup()
            lspconfig.lua_ls.setup(lsp_setup_config())
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        dependencies = {
            "nvim-lspconfig",
        },
        version = "^4",
        ft = "rust",
        init = function()
            vim.g.rustaceanvim = function()
                return {
                    server = {
                        on_attach = function(_, bufnr)
                            local opts = { buffer = bufnr }
                            vim.keymap.set("n", "<leader>lP", "<CMD>RustLsp parentModule<CR>", opts)
                            vim.keymap.set("n", "<leader>lD", "<CMD>RustLsp renderDiagnostic<CR>", opts)
                            vim.keymap.set("n", "<leader>lE", "<CMD>RustLsp explainError<CR>", opts)
                        end,
                        capabilities = lsp_setup_config().capabilities,
                    },
                }
            end
        end,
    },
    {
        "p00f/clangd_extensions.nvim",
        dependencies = { "williamboman/mason.nvim" },
        ft = { "c", "cpp" },
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = { "williamboman/mason.nvim" },
        ft = "java",
    },
    {
        "jose-elias-alvarez/typescript.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
        },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        config = function()
            local util = require("lspconfig.util")
            local typescript = require("typescript")

            local is_deno_project = util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd())
            if is_deno_project then
                return
            end

            typescript.setup({
                server = lsp_setup_config({
                    root_dir = util.find_package_json_ancestor,
                    on_attach = function(_, bufnr)
                        vim.keymap.set(
                            "n",
                            "<leader>lm",
                            "<CMD>TypescriptAddMissingImports<CR>",
                            { buffer = bufnr, silent = true }
                        )
                        vim.keymap.set(
                            "n",
                            "<leader>lR",
                            "<CMD>TypescriptRenameFile<CR>",
                            { buffer = bufnr, silent = true }
                        )
                    end,
                }),
            })
        end,
    },
    {
        "akinsho/flutter-tools.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvim-lua/plenary.nvim",
        },
        ft = "dart",
        config = function()
            local flutter_tools = require("flutter-tools")

            flutter_tools.setup({
                flutter_lookup_cmd = vim.fn.executable("asdf") and "asdf where flutter",
            })

            local ok, telescope = pcall(require, "telescope")
            if ok then
                telescope.load_extension("flutter")
            end
        end,
    },
}
