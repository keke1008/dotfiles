local remap = vim.keymap.set

local M = {}

---@alias Menu { name: string, open: fun(), close: fun() }

---@class Sidemenu
---@field menus Menu[]
---@field current_id number Current open menu id
local Sidemenu = {}

function Sidemenu.new()
    local self = {
        menus = {},
        current_id = 0,
    }
    return setmetatable(self, { __index = Sidemenu })
end

---@param menu Menu
---@return number id
function Sidemenu:register(menu)
    table.insert(self.menus, menu)
    return #self.menus
end

---@param id number
function Sidemenu:open(id)
    if self.current_id == id then
        self.menus[id].open()
    else
        self:close()
        self.menus[id].open()
        self.current_id = id
    end
end

function Sidemenu:close()
    if self.current_id ~= 0 then
        self.menus[self.current_id].close()
        self.current_id = 0
    end
end

local sidemenu = Sidemenu.new()

local prefix_key = "<leader>s"

---@class MenuHandler
---@field id number
local MenuHandler = {}

---@param id number
---@return MenuHandler
MenuHandler.new = function(id)
    local handler = { id = id }
    return setmetatable(handler, { __index = MenuHandler })
end

function MenuHandler:open() sidemenu:open(self.id) end

---@param keymap string
---@param menu Menu
---@return MenuHandler
M.register = function(keymap, menu)
    local id = sidemenu:register(menu)
    local handler = MenuHandler.new(id)
    remap("n", prefix_key .. keymap, function() handler:open() end)
    return handler
end

M.close = function() sidemenu:close() end

M.close_keymap = function(keymap)
    remap("n", prefix_key .. keymap, function() sidemenu:close() end)
end

return M
