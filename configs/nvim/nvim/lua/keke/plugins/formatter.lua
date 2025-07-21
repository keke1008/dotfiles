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
                javascript = { "prettierd", "prettier" },
                javascriptreact = { "prettierd", "prettier" },
                typescript = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                yaml = { "prettierd", "prettier" },
                markdown = { "prettierd", "prettier" },
                css = { "prettierd", "prettier" },
                ruby = { "rubocop" },
                python = { "isort", "black", stop_after_first = false },
                lua = { "stylua" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
                fish = { "fish_indent" },
                nix = { "nixfmt" },
                tf = { "terraform_fmt" },
            },
            default_format_opts = {
                lsp_format = "fallback",
                stop_after_first = true,
            },
        },
    },
}
