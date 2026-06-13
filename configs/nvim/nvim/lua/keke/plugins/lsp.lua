---@diagnostic disable: missing-fields
local drawer = require("drawer")
local lsp = require("keke.utils.lsp")

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Configure LSP settings",
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "[e", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opts)
        vim.keymap.set("n", "]e", "<CMD>Lspsaga diagnostic_jump_next<CR>", opts)
        vim.keymap.set("n", "<leader>ld", "<CMD>Lspsaga peek_definition<CR>", opts)
        vim.keymap.set("n", "<leader>la", "<CMD>Lspsaga code_action<CR>", opts)
        vim.keymap.set("n", "<leader>lr", "<CMD>Lspsaga rename<CR>", opts)
    end,
})

return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            -- `require("neoconf").setup()` should be run **BEFORE** setting up
            -- any lsp server with lspconfig
            { "folke/neoconf.nvim", config = true },
        },
        config = function()
            local blink = require("blink.cmp")
            vim.lsp.config("*", {
                capabilities = blink.get_lsp_capabilities(),
            })

            vim.lsp.enable({
                "clangd",
                "denols",
                "gopls",
                "jsonls",
                "lua_ls",
                "nil_ls",
                "notes_ls",
                "pyright",
                "qmlls",
                "rubocop",
                "ruby_lsp",
                "taplo",
                "terraformls",
                "tsp_server",
                "yamlls",
                -- "rust_analyzer", -- rustaceanvim
                -- "ts_ls", -- typescript.nvim
            })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        config = true,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        ft = "rust",
    },
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        opts = {
            on_attach = function(_, bufnr)
                vim.keymap.set("n", "<leader>lD", "<CMD>TSToolsGoToSourceDefinition<CR>", { buffer = bufnr })
            end,
            root_dir = function(bufnr, on_dir)
                local deno_root = vim.fs.root(bufnr, lsp.DENO_ROOT_MARKER)
                if deno_root ~= nil then
                    return
                end

                local marker = { "package.json", "tsconfig.json", "jsconfig.json", ".git" }
                return lsp.root_dir(marker)(bufnr, on_dir)
            end,
        },
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
        commit = "562d972", -- pinned: b821192 switched to on_jump (Neovim 0.12+), so float doesn't show on 0.11.5
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
}
