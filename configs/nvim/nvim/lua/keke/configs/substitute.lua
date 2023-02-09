local map = require("keke.utils.mapping")

---@param command string
---@return function
local function substitute(command)
    return function() require("substitute")[command]() end
end

map.add_group(map.l2("su"), "substitute")

vim.keymap.set("n", map.l2("su"), substitute("operator"), { desc = "substitute" })
vim.keymap.set("n", map.l2("suu"), substitute("line"), { desc = "substitute line" })
vim.keymap.set("n", map.l2("sU"), substitute("eol"), { desc = "substitute eol" })
vim.keymap.set("x", map.l2("su"), substitute("visual"), { desc = "substitute" })
