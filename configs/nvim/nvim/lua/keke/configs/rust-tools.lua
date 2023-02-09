-- You should not install 'rust_analyzer' with nvim-lsp-installer,
-- because rust-tools will automatically enable this lsp.

local rt = require("rust-tools")
local rt_dap = require("rust-tools.dap")
local mason_registry = require("mason-registry")
local lsp = require("keke.utils.lsp")
local map = require("keke.utils.mapping")

rt.setup({
    server = lsp.extend_default_config({
        on_attach = function(_, bufnr)
            local opts = { buffer = bufnr }
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, map.add_desc(opts, "Lsp show hover"))
            vim.keymap.set(
                "n",
                "<leader>la",
                rt.code_action_group.code_action_group,
                map.add_desc(opts, "Lsp code action")
            )
            vim.keymap.set("n", "<leader>lp", rt.parent_module.parent_module, map.add_desc(opts, "Lsp parent module"))
        end,
    }),
    tools = {
        inlay_hints = {
            parameter_hints_prefix = "", -- \uf54d
            other_hints_prefix = " ", -- \uf554
        },
    },
    dap = (function()
        if not mason_registry.is_installed("codelldb") then return end

        local install_path = mason_registry.get_package("codelldb"):get_install_path()
        local codelldb_path = install_path .. "/extension/adapter/codelldb"
        local liblldb_path = install_path .. "/extension/lldb/lib/liblldb.so"

        return { adapter = rt_dap.get_codelldb_adapter(codelldb_path, liblldb_path) }
    end)(),
})
