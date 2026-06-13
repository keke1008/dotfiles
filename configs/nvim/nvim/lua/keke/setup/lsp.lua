vim.lsp.codelens.enable()
vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Configure LSP keymaps",
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.incoming_calls, opts)
        vim.keymap.set("n", "<leader>lo", vim.lsp.buf.outgoing_calls, opts)
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)

        vim.keymap.set("n", "<leader>ll", function()
            vim.lsp.codelens.run({ buffer = bufnr })
        end, opts)

        vim.keymap.set("n", "[e", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, opts)
        vim.keymap.set("n", "]e", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, opts)
    end,
})
