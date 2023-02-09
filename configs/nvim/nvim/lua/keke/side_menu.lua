---@alias SideMenu.MenuId number
---@alias SideMenu.MenuPosition "left" | "right" | "bottom"

---@class SideMenu.Menu
---@field position SideMenu.MenuPosition[]
---@field id SideMenu.MenuId
---@field open fun()
---@field close fun()

---@class SideMenu.SideMenu
---@field menus table<SideMenu.MenuId, SideMenu.Menu>
---@field current_layout table<SideMenu.MenuPosition, SideMenu.Menu?>
---@field ignored_menus table<SideMenu.MenuId, SideMenu.Menu>
----@field ignored_menus SideMenu.Menu[]
local SideMenu = {}
SideMenu.__index = SideMenu

function SideMenu.new()
    return setmetatable({
        menus = {},
        current_layout = {},
        ignored_menus = {},
    }, SideMenu)
end

---@param id SideMenu.MenuId
---@param menu SideMenu.Menu
function SideMenu:register(id, menu) self.menus[id] = menu end

---@param id SideMenu.MenuId
function SideMenu:open(id)
    local next_menu = self.menus[id]

    -- There is no applicable menu.
    if not next_menu then
        return
    end

    -- `next_menu` is already opened.
    for _, menu in pairs(self.current_layout) do
        if menu == next_menu then
            return
        end
    end

    for _, position in ipairs(next_menu.position) do
        self:close(position)
        self.current_layout[position] = next_menu
    end
    next_menu.open()
end

---@param ignore_position SideMenu.MenuPosition
function SideMenu:ignore(ignore_position)
    local ignore_menu = self.current_layout[ignore_position]
    if not ignore_menu then
        return
    end

    for _, position in ipairs(ignore_menu.position) do
        self.current_layout[position] = nil
    end

    self.ignored_menus[ignore_menu.id] = ignore_menu
end

---@param close_position SideMenu.MenuPosition
function SideMenu:close(close_position)
    local close_menu = self.current_layout[close_position]
    if not close_menu then
        return
    end

    for _, position in ipairs(close_menu.position) do
        self.current_layout[position] = nil
    end
    close_menu.close()
end

function SideMenu:close_all()
    for position, menu in pairs(self.current_layout) do
        menu.close()
        self.current_layout[position] = nil

        if self.ignored_menus[menu.id] then
            self.ignored_menus = nil
        end
    end

    for _, menu in pairs(self.ignored_menus) do
        menu.close()
    end

    self.ignored_menus = {}
end

---@class SideMenu.MenuHandle
---@field _id SideMenu.MenuId
---@field _side_menu SideMenu.SideMenu
local MenuHandle = {}
MenuHandle.__index = MenuHandle

---@param id SideMenu.MenuId
---@param side_menu SideMenu.SideMenu
---@return SideMenu.MenuHandle
function MenuHandle.new(id, side_menu)
    return setmetatable({
        _id = id,
        _side_menu = side_menu,
    }, MenuHandle)
end

function MenuHandle:open() self._side_menu:open(self._id) end

local M = {}

---@type SideMenu.MenuId
M._id = 0
M._side_menu = SideMenu.new()
M._prefix = "<leader>s"

---@param f fun(position: SideMenu.MenuPosition, key: string)
local function remap_positions(f)
    local positions = {
        left = "l",
        right = "r",
        bottom = "b",
    }

    for position, key in pairs(positions) do
        f(position, key)
    end
end

---@class SideMenu.RegisterMenuParam
---@field open fun()
---@field close fun()
---@field position SideMenu.MenuPosition | SideMenu.MenuPosition[]

---@param name string
---@param key string
---@param param SideMenu.RegisterMenuParam
---@return SideMenu.MenuHandle
function M.register(name, key, param)
    local id = M._id
    M._id = M._id + 1

    vim.validate({
        open = { param.open, "function" },
        close = { param.close, "function" },
        position = { param.position, { "string", "table" } },
    })

    local menu = {
        position = type(param.position) == "string" and { param.position } or param.position,
        id = id,
        open = param.open,
        close = param.close,
    }
    M._side_menu:register(id, menu)

    vim.keymap.set("n", M._prefix .. key, function() M._side_menu:open(id) end, { desc = ("Open %s"):format(name) })

    return MenuHandle.new(id, M._side_menu)
end

---@param key string
function M.remap_close(key)
    remap_positions(function(position, suffix)
        local lhs = M._prefix .. key .. suffix
        vim.keymap.set(
            "n",
            lhs,
            function() M._side_menu:close(position) end,
            { desc = ("Close %s side menu"):format(position) }
        )
    end)
end

---@param key string
function M.remap_ignore(key)
    remap_positions(function(position, suffix)
        local lhs = M._prefix .. key .. suffix
        vim.keymap.set(
            "n",
            lhs,
            function() M._side_menu:ignore(position) end,
            { desc = ("Ignore %s side menu"):format(position) }
        )
    end)
end

---@param key string
function M.remap_close_all(key)
    vim.keymap.set("n", M._prefix .. key, function() M._side_menu:close_all() end, { desc = "Close all side menu" })
end

return M
