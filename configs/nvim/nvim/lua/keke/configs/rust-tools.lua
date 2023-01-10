-- You should not install 'rust_analyzer' with nvim-lsp-installer,
-- because rust-tools will automatically enable this lsp.

local rt = require("rust-tools")
local rt_dap = require("rust-tools.dap")
local mason_registry = require("mason-registry")
local lsp = require("keke.utils.lsp")
local remap = vim.keymap.set

vim.api.nvim_set_hl(0, "rustInlayHints", { fg = "#3467af" })

local installed, codelldb = pcall(mason_registry.get_package, "codelldb")
if not installed then
    vim.notify("`codelldb` in not installed.", vim.log.levels.INFO)
    return
end

local package_path = codelldb:get_install_path()
local codelldb_path = package_path .. "/extension/adapter/codelldb"
local liblldb_path = package_path .. "/extension/lldb/lib/liblldb.so"

rt.setup({
    server = lsp.extend_default_config({
        on_attach = function(_, bufnr)
            remap("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr, desc = "Lsp show hover" })
            remap("n", "<leader>la", rt.code_action_group.code_action_group, {
                buffer = bufnr,
                desc = "Lsp code action",
            })
            remap("n", "<leader>lp", rt.parent_module.parent_module, { buffer = bufnr, desc = "Lsp parent module" })
        end,
    }),
    tools = {
        inlay_hints = {
            parameter_hints_prefix = "", -- \uf54d
            other_hints_prefix = " ", -- \uf554
        },
    },
    dap = {
        adapter = rt_dap.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
})
