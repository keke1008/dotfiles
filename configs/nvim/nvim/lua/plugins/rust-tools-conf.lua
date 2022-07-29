-- You should not install 'rust_analyzer' with nvim-lsp-installer,
-- because rust-tools will automatically enable this lsp.

local rust_tools = require 'rust-tools'

vim.cmd [[highligh rustInlayHints guifg=#3467af]]

local extension_path = vim.env.HOME .. '/.vscode-server/extensions/vadimcn.vscode-lldb-1.7.0/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

rust_tools.setup {
    tools = {
        inlay_hints = {
            parameter_hints_prefix = '', -- \uf54d
            highlight = 'rustInlayHints',
            other_hints_prefix = ' ', -- \uf554
        }
    },
    dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
    }

}
