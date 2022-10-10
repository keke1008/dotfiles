local Flfiler = require("flfiler.internal.flfiler")
local config = require("flfiler.config")
local global = require("flfiler.global")

local M = {}

---@param option FlfilerOption
function M.setup(option)
    option = option or {}
    local conf = vim.tbl_deep_extend("keep", option, config.default())
    config.validate_config(conf)

    global.set_flfiler(Flfiler.new(conf))
    global.set_config(conf)
end

return M
