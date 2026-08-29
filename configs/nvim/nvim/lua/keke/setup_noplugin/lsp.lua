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

        vim.lsp.completion.enable(true, client_id, bufnr)
    end,
})
