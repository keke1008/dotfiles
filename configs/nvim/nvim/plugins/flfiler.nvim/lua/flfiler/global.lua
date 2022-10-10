---@type {flfiler?: Flfiler, config?: FlfilerConfig }
local global = {}

local M = {}

---@return Flfiler
function M.get_flfiler()
    assert(global.flfiler, "Call `setup()` function first")
    return global.flfiler
end

---@param flfiler Flfiler
function M.set_flfiler(flfiler)
    global.flfiler = flfiler
end

---@return FlfilerConfig
function M.get_config()
    assert(global.config, "Call `setup()` function first")
    return global.config
end

---@param config FlfilerConfig
function M.set_config(config)
    global.config = config
end

return M
