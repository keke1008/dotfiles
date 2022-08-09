local remap = require 'keke.remap'

local M = {}

---@alias Menu { name: string, open: fun(), close: fun() }

---@class Sidemenu
---@field menus Menu[]
---@field current_id number Current open menu id
---
---@field register fun(self: Sidemenu, menu: Menu): number
---@field open fun(self: Sidemenu, id: number)
---@field close fun(self: Sidemenu)
local Sidemenu = {
    register = function(self, menu)
        table.insert(self.menus, menu)
        return #self.menus
    end,

    open = function(self, id)
        if self.current_id ~= id then
            self:close()
            self.menus[id].open()
            self.current_id = id
        end
    end,

    close = function(self)
        if self.current_id ~= 0 then
            self.menus[self.current_id].close()
            self.current_id = 0
        end
    end,
}

function Sidemenu.new()
    local self = { menus = {}, current_id = 0 }
    return setmetatable(self, { __index = Sidemenu })
end

local sidemenu = Sidemenu.new()

---@class MenuHandler
---@field toggle fun(self: MenuHandler)
---@field id number
local MenuHandler = {
    open = function(self)
        sidemenu:open(self.id)
    end
}

---@param id number
---@return MenuHandler
MenuHandler.new = function(id)
    local handler = { id = id }
    return setmetatable(handler, { __index = MenuHandler })
end

---@param keymap string
---@param menu Menu
---@return MenuHandler
M.register = function(keymap, menu)
    local id = sidemenu:register(menu)
    local handler = MenuHandler.new(id)
    remap.set_keymap('n', keymap, function() handler:open() end)
    return handler
end

M.close = function()
    sidemenu:close()
end

return M
