local neoscroll = require("neoscroll")

neoscroll.setup({ mappings = {} })

local time = 100

---@param lines string|number
local scroll = function(lines)
    if type(lines) == "string" then
        neoscroll[lines](time)
    else
        neoscroll.scroll(lines, true, time)
    end
end

local mapping = {
    ["<C-u>"] = function() scroll(-vim.wo.scroll) end,
    ["<C-d>"] = function() scroll(vim.wo.scroll) end,
    ["<C-b>"] = function() scroll(-vim.api.nvim_win_get_height(0)) end,
    ["<C-f>"] = function() scroll(vim.api.nvim_win_get_height(0)) end,
    ["<C-e>"] = function() scroll(0.1) end,
    ["<C-y>"] = function() scroll(-0.1) end,
    ["zt"] = function() scroll("zt") end,
    ["zz"] = function() scroll("zz") end,
    ["zb"] = function() scroll("zb") end,
}

local install_mapping = function()
    for lhs, rhs in pairs(mapping) do
        vim.keymap.set({ "n", "x" }, lhs, rhs)
    end
end

local uninstall_mapping = function()
    for lhs, _ in pairs(mapping) do
        vim.keymap.del("n", lhs)
        vim.keymap.del("x", lhs)
    end
end

install_mapping()

vim.api.nvim_create_user_command("EnableScrollMotion", install_mapping, {})
vim.api.nvim_create_user_command("DisableScrollMotion", uninstall_mapping, {})
