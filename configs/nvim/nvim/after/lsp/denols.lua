local lsp = require("keke.utils.lsp")

return {
    root_dir = lsp.root_dir(lsp.DENO_ROOT_MARKER),
}
