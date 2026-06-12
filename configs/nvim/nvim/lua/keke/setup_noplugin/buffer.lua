vim.keymap.set("n", "[b", "<CMD>bprevious<CR>")
vim.keymap.set("n", "]b", "<CMD>bnext<CR>")
vim.keymap.set("n", "<leader>bb", "<CMD>bwipeout<CR>")

vim.keymap.set("n", "<leader>bf", function()
    vim.ui.select(vim.api.nvim_list_bufs(), {
        format_item = vim.api.nvim_buf_get_name,
    }, function(bufnr)
        if bufnr ~= nil then
            vim.api.nvim_win_set_buf(0, bufnr)
        end
    end)
end)
