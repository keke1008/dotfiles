local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local map = require("keke.utils.mapping")

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
    map.add_group("<leader>la", "Lsp")

    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", "<CMD>Lspsaga goto_definition<CR>", opts)
    vim.keymap.set("n", "gr", "<CMD>Lspsaga lsp_finder<CR>", opts)
    vim.keymap.set("n", "[e", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opts)
    vim.keymap.set("n", "]e", "<CMD>Lspsaga diagnostic_jump_next<CR>", opts)
    vim.keymap.set("n", "K", "<CMD>Lspsaga hover_doc<CR>", opts)
    vim.keymap.set("n", "<leader>la", "<CMD>Lspsaga code_action<CR>", opts)
    vim.keymap.set("n", "<leader>lr", "<CMD>Lspsaga rename<CR>", opts)
    vim.keymap.set("n", "<leader>le", "<CMD>Lspsaga show_cursor_diagnostics<CR>", opts)
    vim.keymap.set("n", "<leader>lp", "<CMD>Lspsaga peek_definition<CR>", opts)
    vim.keymap.set("n", "<leader>li", "<CMD>Lspsaga incoming_calls<CR>", opts)
    vim.keymap.set("n", "<leader>lo", "<CMD>Lspsaga outgoing_calls<CR>", opts)
    vim.keymap.set("n", "<leader>ld", "<CMD>Telescope lsp_definitions<CR>", opts)
    vim.keymap.set("n", "<leader>lf", format, map.add_desc(opts, "format"))
    vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, map.add_desc(opts, "run codelens"))

    if not vim.b.is_lsp_format_autocmd_attached then
        vim.b.is_lsp_format_autocmd_attached = true
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = format,
        })
    end

    if not vim.b.is_lsp_codelens_autocmd_attached and client.server_capabilities.codeLensProvider then
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
