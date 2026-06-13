vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client_id = ev.data.client_id
        local bufnr = ev.buf

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("keke_setup_noplugin_lsp_format_on_save_" .. bufnr, {}),
            buf = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })

        vim.lsp.completion.enable(true, client_id, bufnr, {
            autotrigger = true,
        })

        vim.keymap.set("i", "<C-n>", vim.lsp.completion.get, { buffer = bufnr })
        vim.keymap.set("i", "<CR>", function()
            return vim.fn.pumvisible() == 0 and "<CR>" or "<c-y>"
        end, { buffer = bufnr, expr = true })

        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            vim.snippet.jump(1)
        end)
        vim.keymap.set({ "i", "s" }, "<C-k>", function()
            vim.snippet.jump(-1)
        end)
    end,
})
