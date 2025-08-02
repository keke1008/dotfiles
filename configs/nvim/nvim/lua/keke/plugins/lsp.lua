---@diagnostic disable: missing-fields
local drawer = require("drawer")

local function lsp_default_configuration()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local cmp_capabilities = cmp_nvim_lsp.default_capabilities()
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities)

    return {
        capabilities = capabilities,
    }
end

---@param bufnr integer
local function refresh_codelens(bufnr)
    local client = vim.lsp.get_clients({ method = "textDocument/codeLens", bufnr = bufnr })
    if #client > 0 then
        vim.lsp.codelens.refresh({ bufnr = bufnr })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
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

        refresh_codelens(bufnr)
        vim.api.nvim_create_autocmd("InsertLeave", {
            group = vim.api.nvim_create_augroup("keke_lsp_codelens_buf_" .. bufnr, { clear = true }),
            desc = "Refresh codelens",
            buffer = bufnr,
            callback = function()
                refresh_codelens(bufnr)
            end,
        })
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
            local lsp = require("keke.utils.lsp")

            vim.lsp.config("*", lsp_default_configuration())
            vim.lsp.config("notes_ls", {
                cmd = { "notes_cli", "lsp" },
                root_dir = lsp.root_dir({ ".vault" }),
                filetypes = { "markdown" },
            })

            vim.lsp.enable({
                "clangd",
                "denols",
                "jsonls",
                "lua_ls",
                "nil_ls",
                "notes_ls",
                "pyright",
                "rubocop",
                "ruby_lsp",
                "taplo",
                "terraformls",
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
        config = true,
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
}
