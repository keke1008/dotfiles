local remap = vim.keymap.set

local function leap_tabpage()
    require("leap").leap({
        target_windows = vim.tbl_filter(
            function(win) return vim.api.nvim_win_get_config(win).focusable end,
            vim.api.nvim_tabpage_list_wins(0)
        ),
    })
end

remap({ "n", "x" }, ",", leap_tabpage)
remap({ "i", "s" }, "<C-L>", leap_tabpage)
