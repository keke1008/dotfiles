-- You should not install 'rust_analyzer' with nvim-lsp-installer,
-- because rust-tools will automatically enable this lsp.

local rt = require("rust-tools")
local rt_dap = require("rust-tools.dap")
local lsp = require("keke.lsp")
local remap = vim.keymap.set

vim.api.nvim_set_hl(0, "rustInlayHints", { fg = "#3467af" })

local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

rt.setup({
    server = lsp.extend_default_config({
        on_attach = function(_, bufnr)
            remap("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
            remap("n", "<leader>la", rt.code_action_group.code_action_group, {
                buffer = bufnr,
                desc = "Lsp code action",
            })
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
