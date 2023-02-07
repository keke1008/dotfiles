local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local remap = vim.keymap.set

vim.fn.sign_define({
    { name = "DiagnosticSignError", text = "", texthl = "DiagnosticSignError" },
    { name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticSignWarn" },
    { name = "DiagnosticSignInformation", text = "", texthl = "DiagnosticSignInformation" },
    { name = "DiagnosticSignHint", text = "", texthl = "DiagnosticSignHint" },
})

local function format()
    local null_ls_client = vim.lsp.get_active_clients({
        name = "null-ls",
        buffer = vim.api.nvim_get_current_buf(),
    })[1]
    if null_ls_client and null_ls_client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({ id = null_ls_client.id })
    else
        vim.lsp.buf.format({})
    end
end

vim.api.nvim_create_user_command("W", function(opt)
    local cmd = opt.bang and "w!" or "w"
    vim.cmd("noautocmd " .. cmd)
end, { bang = true })

local M = {}

function M.on_attach(client, bufnr)
    local opt = { buffer = bufnr, silent = true }
    remap("n", "gd", "<CMD>Telescope lsp_definitions<CR>", opt)
    remap("n", "<leader>gd", "<CMD>Lspsaga peek_definition<CR>", opt)
    remap("n", "gr", "<CMD>Lspsaga lsp_finder<CR>", opt)
    remap("n", "[e", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opt)
    remap("n", "]e", "<CMD>Lspsaga diagnostic_jump_next<CR>", opt)
    remap("n", "K", "<CMD>Lspsaga hover_doc<CR>", opt)
    remap({ "n", "v" }, "<leader>la", "<CMD>Lspsaga code_action<CR>", opt)
    remap("n", "<leader>lr", "<CMD>Lspsaga rename<CR>", opt)
    remap("n", "<leader>ld", "<CMD>Lspsaga show_cursor_diagnostics", opt)
    remap("n", "<leader>lf", format, opt)
    remap("n", "<leader>ll", vim.lsp.codelens.run, opt)

    if not vim.b.is_lsp_format_autocmd_attached then
        vim.b.is_lsp_format_autocmd_attached = true
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = format,
        })
    end

    if not vim.b.is_lsp_codelens_autocmd_attached and client.server_capabilities.codeLensProvider then
        -- if not vim.b.is_lsp_codelens_autocmd_attached and client.supports_method("textDocument/codeLens") then
        vim.b.is_lsp_codelens_autocmd_attached = true
        vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
    end
end

local capabilities = (function()
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = cmp_nvim_lsp.default_capabilities()
    return vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities)
end)()

M.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
    capabilities = capabilities,
    on_attach = function(client, bufnr) M.on_attach(client, bufnr) end,
})

function M.extend_default_config(config)
    local override = {}

    if config.on_attach then
        override.on_attach = function(client, bufnr)
            M.on_attach(client, bufnr)
            config.on_attach(client, bufnr)
        end
    end

    return vim.tbl_deep_extend("force", M.default_config, config, override)
end

return M
