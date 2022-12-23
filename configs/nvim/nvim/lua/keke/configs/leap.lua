local remap = vim.keymap.set

remap(
    { "n", "v" },
    ",",
    function()
        require("leap").leap({
            target_windows = { vim.fn.win_getid() },
        })
    end
)

remap({ "n", "v" }, "g,", function()
    require("leap").leap({
        target_windows = vim.tbl_filter(
            function(win) return vim.api.nvim_win_get_config(win).focusable end,
            vim.api.nvim_tabpage_list_wins(0)
        ),
    })
end)
