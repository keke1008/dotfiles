require("keke.utils.lsp").on_attach("clangd", function(bufnr, _)
    vim.keymap.set("n", "<leader>ls", "<CMD>ClangdSwitchSourceHeader<CR>", { buffer = bufnr })
end)
