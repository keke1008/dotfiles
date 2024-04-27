local core = require("drawer.core")

local state = core.DrawerState.new()

---@class drawer.Config
---@field prefix_key string

---@type drawer.Config | nil
local config = nil

---@return drawer.Config
local function get_config()
    assert(config ~= nil, "Drawer not setup")
    return config
end

---@class drawer.DrawerSpec
---@field name drawer.DrawerName
---@field positions drawer.DrawerPosition[]
---@field open fun() | string
---@field close fun() | string

---@param cmd_or_fn string | fun()
---@return fun()
local function wrap_cmd_with_fn(cmd_or_fn)
    if type(cmd_or_fn) == "string" then
        return function() vim.cmd(cmd_or_fn) end
    else
        return cmd_or_fn
    end
end

return {
    ---@param config_ drawer.Config
    setup = function(config_) config = config_ end,

    ---@param drawer drawer.DrawerSpec
    register = function(drawer)
        state:register({
            name = drawer.name,
            positions = drawer.positions,
            open = wrap_cmd_with_fn(drawer.open),
            close = wrap_cmd_with_fn(drawer.close),
        })
    end,

    ---@param name drawer.DrawerName
    open = function(name) state:open(name) end,

    ---@param name drawer.DrawerName
    push = function(name) state:push(name) end,

    ---@param position drawer.DrawerPosition
    close_by_position = function(position) state:close_by_position(position) end,

    ---@param name drawer.DrawerName
    close_by_name = function(name) state:close_by_name(name) end,

    close_all = function() state:close_all() end,

    prefix_key = function() return get_config().prefix_key end,

    ---@param key string
    with_prefix_key = function(key) return get_config().prefix_key .. key end,
}
