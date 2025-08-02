require("keke.utils.lsp").on_attach("rust-analyzer", function(bufnr, _)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "<leader>lP", "<CMD>RustLsp parentModule<CR>", opts)
    vim.keymap.set("n", "<leader>lD", "<CMD>RustLsp renderDiagnostic<CR>", opts)
    vim.keymap.set("n", "<leader>lE", "<CMD>RustLsp explainError<CR>", opts)
end)
