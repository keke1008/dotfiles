local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local M = {}

M.on_attach = function(_, _) vim.notify("[keke.lsp] `setup` has not been called yet.", vim.log.levels.ERROR) end

function M.setup(opt)
    vim.validate({
        opt = { opt, "table" },
        on_attach = { opt.on_attach, "function" },
    })
    M.on_attach = opt.on_attach
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
