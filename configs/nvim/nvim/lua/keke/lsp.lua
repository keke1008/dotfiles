local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsp_signature = require("lsp_signature")
local remap = vim.keymap.set

local M = {}

M.capabilities = cmp_nvim_lsp.default_capabilities()
M.on_attach = function(_, bufnr)
    lsp_signature.on_attach()

    local opt = { buffer = bufnr, silent = true }
    remap("n", "gd", "<CMD>Lspsaga peek_definition<CR>", opt)
    remap("n", "gr", "<CMD>Lspsaga lsp_finder<CR>", opt)
    remap("n", "[e", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opt)
    remap("n", "]e", "<CMD>Lspsaga diagnostic_jump_next<CR>", opt)
    remap("n", "K", "<CMD>Lspsaga hover_doc<CR>", opt)
    remap({ "n", "v" }, "<leader>la", "<CMD>Lspsaga code_action<CR>", opt)
    remap("n", "<leader>lr", "<CMD>Lspsaga rename<CR>", opt)
    remap("n", "<leader>ld", "<CMD>Lspsaga show_cursor_diagnostics", opt)
end

M.default_config = {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
}

function M.extend_default_config(config) return vim.tbl_extend("force", M.default_config, config) end

---@param f fun(client: any, bufnr: number)
---@return fun(client: any, bufnr: number)
function M.extend_on_attach(f)
    return function(client, bufnr)
        M.on_attach(client, bufnr)
        f(client, bufnr)
    end
end

return M
