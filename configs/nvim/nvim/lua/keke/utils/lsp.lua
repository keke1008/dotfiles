local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local noice_lsp = require("noice.lsp")
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

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("keke_lsp_attach", {}),
    desc = "Lsp buffer local configs",
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true }

        map.add_group("<leader>l", "Lsp", bufnr)
        vim.keymap.set("n", "gd", "<CMD>Lspsaga goto_definition<CR>", opts)
        vim.keymap.set("n", "gr", "<CMD>Lspsaga lsp_finder<CR>", opts)
        vim.keymap.set("n", "[e", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opts)
        vim.keymap.set("n", "]e", "<CMD>Lspsaga diagnostic_jump_next<CR>", opts)
        vim.keymap.set("n", "K", noice_lsp.hover, opts)
        vim.keymap.set("n", "<leader>la", "<CMD>Lspsaga code_action<CR>", opts)
        vim.keymap.set("n", "<leader>lr", "<CMD>Lspsaga rename<CR>", opts)
        vim.keymap.set("n", "<leader>le", "<CMD>Lspsaga show_cursor_diagnostics<CR>", opts)
        vim.keymap.set("n", "<leader>lp", "<CMD>Lspsaga peek_definition<CR>", opts)
        vim.keymap.set("n", "<leader>li", "<CMD>Lspsaga incoming_calls<CR>", opts)
        vim.keymap.set("n", "<leader>lo", "<CMD>Lspsaga outgoing_calls<CR>", opts)
        vim.keymap.set("n", "<leader>ld", "<CMD>Telescope lsp_definitions<CR>", opts)
        vim.keymap.set("n", "<leader>lf", format, map.add_desc(opts, "format"))
        vim.keymap.set("n", "<leader>lc", vim.lsp.codelens.run, map.add_desc(opts, "run codelens"))

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("keke_lsp_format_buf_" .. bufnr, {}),
            desc = "Format on save",
            buffer = bufnr,
            callback = format,
        })

        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd("InsertLeave", {
                group = vim.api.nvim_create_augroup("keke_lsp_codelens_buf_" .. bufnr, {}),
                desc = "Refresh codelens",
                buffer = bufnr,
                callback = vim.lsp.codelens.refresh,
            })
            vim.api.nvim_buf_call(bufnr, vim.lsp.codelens.refresh)
        end
    end,
})

local M = {}

M.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
    capabilities = (function()
        local default_capabilities = vim.lsp.protocol.make_client_capabilities()
        local cmp_capabilities = cmp_nvim_lsp.default_capabilities()
        return vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities)
    end)(),
})

function M.extend_default_config(config) return vim.tbl_deep_extend("force", M.default_config, config) end

return M
