local M = {}

function M.config()
    vim.api.nvim_create_user_command(
        "MarkdownPreviewInstall",
        function() vim.fn["mkdp#util#install"]() end,
        { desc = "Install markdown-preview.nvim" }
    )
end

return M
