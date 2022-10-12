local PathCore = require "keke.lib.path.core".PathCore

---@class Path
---@field core PathCore
---@operator div(Path | string): Path
local Path = {}
Path.__index = PathCore

local function from_core(core)
    local self = { core = core }
    return setmetatable(self, Path)
end

---@param path string
function Path.new(path)
    return from_core(PathCore.new(path))
end

---@param other Path | string
function Path:__div(other)
    ---@type string | PathCore
    local core = type(other) == "string" and other or other.core
    return from_core(self.core:join(core))
end

---@return string
function Path:to_string()
    if self.core:is_absolute() then
        return self:absolute()
    end
    local cwd = PathCore.new(vim.fn.getcwd())
    return cwd:join(self.core):absolute()
end
