local neoconf = require("neoconf")
local lsp_signature = require("lsp_signature")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern
local remap = vim.keymap.set
local lsp = require("keke.lsp")

vim.fn.sign_define({
    {
        name = "DiagnosticSignError",
        text = "",
        texthl = "DiagnosticSignError",
    },
    {
        name = "DiagnosticSignWarn",
        text = "",
        texthl = "DiagnosticSignWarn",
    },
    {
        name = "DiagnosticSignInformation",
        text = "",
        texthl = "DiagnosticSignInformation",
    },
    {
        name = "DiagnosticSignHint",
        text = "",
        texthl = "DiagnosticSignHint",
    },
})

local function format()
    local null_ls_client = vim.lsp.get_active_clients({
        name = "null-ls",
        buffer = vim.api.nvim_get_current_buf,
    })[1]
    if null_ls_client and null_ls_client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({ id = null_ls_client.id })
    else
        vim.lsp.buf.format({})
    end
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = format,
})

vim.api.nvim_create_user_command("W", function(opt)
    local cmd = opt.bang and "w!" or "w"
    vim.cmd("noautocmd " .. cmd)
end, { bang = true })

lsp.setup({
    on_attach = function(_, bufnr)
        lsp_signature.on_attach()

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
    end,
})

neoconf.setup({})
mason.setup()
mason_lspconfig.setup()

mason_lspconfig.setup_handlers({
    function(server_name) lspconfig[server_name].setup(lsp.default_config) end,
    ["denols"] = function(_)
        lspconfig.denols.setup(lsp.extend_default_config({
            root_dir = root_pattern("deno.json", "deno.jsonc"),
        }))
    end,
    ["sumneko_lua"] = function(_)
        -- neodev.nvim
    end,
    ["clangd"] = function(_)
        -- clangd_extensions.nvim
    end,
    ["tsserver"] = function(_)
        -- typescript.nvim
    end,
})
