local blue = "#7aa2f7"
local color = { fg = blue }

local config = {}

for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
    for _, section in ipairs({ "a", "b", "c", "x", "y", "z" }) do
        config[mode] = config[mode] or {}
        config[mode][section] = color
    end
end

return config
