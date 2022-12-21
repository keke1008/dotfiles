local loader = require("luasnip.loaders.from_vscode")

loader.lazy_load({
    paths = { vim.fn.stdpath("data") .. "/site/pack/packer/start/friendly-snippets/snippets" },
})

loader.lazy_load()
