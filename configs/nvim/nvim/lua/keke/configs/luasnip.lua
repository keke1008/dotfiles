local loader = require("luasnip.loaders.from_vscode")

loader.lazy_load()

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- stylua: ignore
ls.add_snippets("lua", {
    s("module", {
        t({"local M = {}", ""}),
        t("\t"), i(0),
        t({"","return M"}),
    }),
})
