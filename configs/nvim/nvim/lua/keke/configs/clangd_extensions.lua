local clangd_extensions = require("clangd_extensions")
local lsp = require("keke.utils.lsp")

clangd_extensions.setup({
    server = lsp.extend_default_config({
        on_attach = function(_, bufnr)
            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set("n", "<leader>ls", "<CMD>ClangdSwitchSourceHeader<CR>", opts)
        end,
    }),
})
