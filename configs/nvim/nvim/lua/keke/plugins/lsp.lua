local drawer = require("drawer")

---@return fun(overrides?: table): table
local lsp_setup_config = (function()
    ---@type table | nil
    local cached_default_config = nil

    ---@return table
    local function default_config()
        if cached_default_config ~= nil then
            return cached_default_config
        end

        local cmp_capabilities = (function()
            local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if not ok then
                vim.notify("cmp_nvim_lsp is not loaded", vim.log.levels.WARN)
                return {}
            end

            return cmp_nvim_lsp.default_capabilities()
        end)()

        local default_capabilities = vim.lsp.protocol.make_client_capabilities()
        cached_default_config = {
            capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities),
        }
        return cached_default_config
    end

    ---@param overrides table | nil
    ---@return table
    return function(overrides)
        return vim.tbl_deep_extend("force", default_config(), overrides or {})
    end
end)()

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("keke_lsp_attach_common_setting", {}),
    desc = "Configure LSP settings",
    callback = function(args)
        local bufnr = args.buf

        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "[e", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opts)
        vim.keymap.set("n", "]e", "<CMD>Lspsaga diagnostic_jump_next<CR>", opts)
        vim.keymap.set("n", "<leader>ld", "<CMD>Lspsaga peek_definition<CR>", opts)
        vim.keymap.set("n", "<leader>la", "<CMD>Lspsaga code_action<CR>", opts)
        vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, opts)
        vim.keymap.set("n", "<leader>lr", "<CMD>Lspsaga rename<CR>", opts)
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.incoming_calls, opts)
        vim.keymap.set("n", "<leader>lo", vim.lsp.buf.outgoing_calls, opts)

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

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",

            -- `require("neoconf").setup()` should be run **BEFORE** setting up
            -- any lsp server with lspconfig
            { "folke/neoconf.nvim", config = true },
        },
        event = { "BufRead" },
        config = function()
            local lspconfig = require("lspconfig")
            local root_pattern = require("lspconfig.util").root_pattern

            lspconfig.clangd.setup(lsp_setup_config({
                on_attach = function(_, bufnr)
                    local opts = { buffer = bufnr, silent = true }
                    vim.keymap.set("n", "<leader>ls", "<CMD>ClangdSwitchSourceHeader<CR>", opts)
                end,
            }))
            lspconfig.denols.setup(lsp_setup_config({
                root_dir = root_pattern("deno.json", "deno.jsonc"),
            }))
            lspconfig.jsonls.setup(lsp_setup_config())
            -- lspconfig.lua_ls.setup(lsp_setup_config()) lazydev.nvim
            lspconfig.nil_ls.setup(lsp_setup_config())
            lspconfig.pyright.setup(lsp_setup_config())
            lspconfig.ruby_lsp.setup(lsp_setup_config())
            lspconfig.rubocop.setup(lsp_setup_config())
            -- lspconfig.rust_analyzer.setup(lsp_setup_config()) rustaceanvim
            lspconfig.taplo.setup(lsp_setup_config())
            lspconfig.terraformls.setup(lsp_setup_config())
            -- lspconfig.ts_ls.setup(lsp_setup_config()) typescript.nvim
            lspconfig.yamlls.setup(lsp_setup_config())

            vim.api.nvim_create_autocmd("BufRead", {
                group = vim.api.nvim_create_augroup("keke_lspconfig_notes_ls", {}),
                pattern = "*.md",
                desc = "Setup notes LSP server for buffer",
                callback = function(e)
                    vim.lsp.start({
                        name = "notes",
                        cmd = { "notes_cli", "lsp" },
                        root_dir = root_pattern(".git", ".vault")(vim.fn.expand("%:p")),
                    }, {
                        bufnr = e.buf,
                    })
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
            {
                drawer.with_prefix_key("t"),
                function()
                    drawer.open("trouble")
                end,
                mode = "n",
                desc = "Trouble",
            },
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
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("keke_lspsaga_setting", {}),
                pattern = "sagarename",
                desc = "Setup Lspsaga rename buffer",
                callback = function(args)
                    for _, key in ipairs({ "<Esc>", "q" }) do
                        vim.keymap.set("n", key, vim.cmd.quit, { buffer = args.buf })
                    end
                end,
            })
        end,
        opts = {
            ui = { border = "rounded" },
            lightbulb = { enable = false },
            diagnostic = { jump_num_shortcut = false },
            code_action = {
                keys = {
                    quit = { "<Esc>", "q" },
                },
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
        ft = { "c", "cpp" },
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        config = function()
            local util = require("lspconfig.util")
            local is_deno_project = util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd())
            if is_deno_project then
                return
            end

            require("typescript-tools").setup({
                on_attach = function(_, bufnr)
                    vim.keymap.set("n", "<leader>lD", "<CMD>TSToolsGoToSourceDefinition<CR>", { buffer = bufnr })
                end,
            })
        end,
    },
    {
        "akinsho/flutter-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
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
