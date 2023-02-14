local tokyonight = require("tokyonight")

tokyonight.setup({
    style = "night",
    on_colors = function(colors)
        vim.api.nvim_set_hl(0, "WinSeparator", {
            fg = colors.blue0,
        })
    end,
})

vim.cmd.colorscheme("tokyonight")
