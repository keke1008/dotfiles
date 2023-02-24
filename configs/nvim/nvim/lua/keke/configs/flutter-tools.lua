local flutter_tools = require("flutter-tools")
local telescope = require("telescope")
local lsp = require("keke.utils.lsp")

flutter_tools.setup({
    lsp = {
        capabilities = lsp.default_config.capabilities,
    },
    flutter_lookup_cmd = vim.fn.executable("asdf") and "asdf where flutter",
})

telescope.load_extension("flutter")
