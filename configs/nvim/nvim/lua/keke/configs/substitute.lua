local remap = vim.keymap.set
local l2 = require("keke.keymap").l2

---@param command string
---@return function
local function substitute(command)
    return function() require("substitute")[command]() end
end

remap("n", l2("r"), substitute("operator"))
remap("n", l2("rr"), substitute("line"))
remap("n", l2("R"), substitute("eol"))
remap("x", l2("r"), substitute("visual"))
