return {
    "mfussenegger/nvim-lint",
    init = function()
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("keke_nvim_lint", {}),
            callback = function()
                require("lint").try_lint(nil, { ignore_errors = true })
            end,
        })
    end,
    config = function()
        --- @see https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
        require("lint").linters_by_ft = {
            lua = { "luacheck", "selene" },
            python = { "mypy" },
            sh = { "shellcheck" },
            markdown = { "markdownlint" },
        }
    end,
}
