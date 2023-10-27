-- # Rainbow color settings
-- local indent_blankline = require("indent_blankline")
-- local colors = require("tokyonight.colors").setup()
-- local line_colors = {
--     colors.blue,
--     colors.teal,
--     colors.green,
--     colors.yellow,
--     colors.red,
--     colors.magenta,
-- }
-- local HIGHLIGHT_PREFIX = "IndentBlanklineIndent"
--
-- ---@type string[]
-- local highlight_names = {}
--
-- for index, color in ipairs(line_colors) do
--     local name = HIGHLIGHT_PREFIX .. index
--     table.insert(highlight_names, name)
--     vim.cmd(([[highlight %s guifg=%s gui=nocombine]]):format(name, color))
-- end
--
-- indent_blankline.setup({
--     space_char_blankline = " ",
--     show_current_context = true,
--     char_highlight_list = highlight_names,
-- })
--

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

require("ibl").setup({
    scope = { show_start = false, show_end = false },
})
