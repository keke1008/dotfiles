return {
    {
        "stevearc/conform.nvim",
        init = function()
            local function format(async)
                return function(args)
                    local bufnr = (args or {}).bufnr or vim.api.nvim_get_current_buf()
                    local conform = require("conform")
                    conform.format({ bufnr = bufnr, async = async })
                end
            end

            vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", callback = format(false) })
            vim.keymap.set({ "n", "x" }, "<leader>lf", format(true), { desc = "Format" })
        end,
        cmd = "ConformInfo",
        opts = {
            formatters_by_ft = {
                bash = { "shfmt" },
                css = { "prettierd", "prettier" },
                fish = { "fish_indent" },
                javascript = { "prettierd", "prettier" },
                javascriptreact = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                lua = { "stylua" },
                markdown = { "prettierd", "prettier" },
                nix = { "nixfmt" },
                python = { "isort", "black", stop_after_first = false },
                ruby = { "rubocop", lsp_format = "prefer" }, -- Prefer lsp: supports formatter selection
                sh = { "shfmt" },
                tf = { "terraform_fmt" },
                typescript = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                typespec = { "typespec" },
                yaml = { "prettierd", "prettier" },
                zsh = { "shfmt" },
            },
            default_format_opts = {
                lsp_format = "fallback",
                stop_after_first = true,
            },
        },
    },
}
