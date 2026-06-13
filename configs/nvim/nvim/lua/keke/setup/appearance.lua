vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank({ timeout = 200 })
    end,
})

local function set_relativenumber(value)
    return function()
        local is_number_shown = vim.api.nvim_get_option_value("number", {})
        if is_number_shown then
            vim.api.nvim_set_option_value("relativenumber", value, {})
            vim.cmd.redraw() -- For builtin ui
        end
    end
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = set_relativenumber(false),
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = set_relativenumber(true),
})

vim.diagnostic.config({
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN] = "󰀪",
            [vim.diagnostic.severity.INFO] = "󰋽",
            [vim.diagnostic.severity.HINT] = "󰌶",
        },
    },
})
