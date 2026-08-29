vim.o.autocomplete = true
vim.o.complete = ".,w,b,u,o"
vim.o.pumborder = "rounded"
local function is_completing()
    return vim.fn.pumvisible() ~= 0
end

vim.keymap.set("i", "<CR>", function()
    return is_completing() and "<C-y>" or "<CR>"
end, { expr = true, desc = "CR" })
vim.keymap.set("i", "<C-e>", function()
    return is_completing() and "<C-e><CR>" or "<CR>"
end, { expr = true, desc = "CR without select any completion suggestions" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
    vim.snippet.jump(1)
end, { desc = "jump to the next snippt placeholder" })
vim.keymap.set({ "i", "s" }, "<C-k>", function()
    vim.snippet.jump(-1)
end, { desc = "jump to the previous snippt placeholder" })

--- https://github.com/neovim/neovim/issues/38248#issuecomment-4038192073
do
    local orig = vim.api.nvim__complete_set
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim__complete_set = function(...)
        local result = orig(...)
        if result and result.winid then
            pcall(vim.api.nvim_win_set_config, result.winid, { border = "rounded" })
        end
        return result
    end
end
