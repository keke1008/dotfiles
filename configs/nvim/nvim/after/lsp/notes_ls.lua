local lsp = require("keke.utils.lsp")

return {
    cmd = { "notes_cli", "lsp" },
    root_dir = lsp.root_dir({ ".vault" }),
    filetypes = { "markdown" },
}
