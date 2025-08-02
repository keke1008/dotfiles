local lsp = require("keke.utils.lsp")

return {
    root_dir = require("keke.utils.lsp").root_dir(lsp.DENO_ROOT_MARKER),
}
