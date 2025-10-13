return {
    {
        "stevearc/conform.nvim",
        init = function()
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function(args)
                    require("conform").format({ bufnr = args.buf, async = false })
                end,
            })
        end,
        cmd = "ConformInfo",
        keys = {
            {
                "<leader>lf",
                function()
                    local buf = vim.api.nvim_get_current_buf()
                    require("conform").format({ bufnr = buf, async = true })
                end,
                desc = "Format Buffer",
                mode = { "n", "v" },
            },
            {
                "<Esc>",
                function()
                    local buf = vim.api.nvim_get_current_buf()
                    require("conform").format({ bufnr = buf, async = true }, function()
                        vim.api.nvim_buf_call(buf, function()
                            if vim.api.nvim_get_option_value("modified", { buf = buf }) then
                                vim.cmd("noautocmd write")
                            end
                        end)
                    end)
                end,
                desc = "Format and Save Buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                bash = { "shfmt" },
                css = { "biome-check", "prettierd", "prettier" },
                fish = { "fish_indent" },
                javascript = { "biome-check", "prettierd", "prettier" },
                javascriptreact = { "biome-check", "prettierd", "prettier" },
                json = { "biome-check", "prettierd", "prettier" },
                lua = { "stylua" },
                markdown = { "prettierd", "prettier" },
                nix = { "nixfmt" },
                python = { "isort", "black", stop_after_first = false },
                ruby = { "rubocop", lsp_format = "prefer" }, -- Prefer lsp: supports formatter selection
                sh = { "shfmt" },
                tf = { "terraform_fmt" },
                typescript = { "biome-check", "prettierd", "prettier" },
                typescriptreact = { "biome-check", "prettierd", "prettier" },
                typespec = { "typespec" },
                yaml = { "prettierd", "prettier" },
                zsh = { "shfmt" },
            },
            default_format_opts = {
                lsp_format = "fallback",
                stop_after_first = true,
                timeout_ms = 500,
            },
        },
    },
}
