local stack = require("drawer.stack")

---@alias drawer.DrawerPosition string
---@alias drawer.DrawerName string

---@class drawer.Drawer
---@field name drawer.DrawerName
---@field positions drawer.DrawerPosition[]
---@field open fun()
---@field close fun()

---@class drawer.DrawerState
---@field private drawers table<drawer.DrawerName, drawer.Drawer>
---@field private open_drawers table<drawer.DrawerPosition, drawer.DrawerName>
---@field private stashed_drawers drawer.UniqueDrawerNameStack
local DrawerState = {}
DrawerState.__index = DrawerState

---@return drawer.DrawerState
function DrawerState.new()
    return setmetatable({
        drawers = {},
        open_drawers = {},
        stashed_drawers = stack.UniqueDrawerNameStack.new(),
    }, DrawerState)
end

---@param drawer drawer.Drawer
function DrawerState:register(drawer)
    assert(self.drawers[drawer.name] == nil, "Drawer already registered: " .. drawer.name)
    self.drawers[drawer.name] = drawer
end

function DrawerState:_try_open_stashed()
    local name = self.stashed_drawers:peek()
    if name == nil then
        return false
    end

    local drawer = self.drawers[name]
    assert(drawer ~= nil, "Drawer not found: " .. name)

    for _, position in ipairs(drawer.positions) do
        if self.open_drawers[position] ~= nil then
            return
        end
    end

    self.stashed_drawers:pop()
    self:open(name)
    for _, position in ipairs(drawer.positions) do
        self.open_drawers[position] = name
    end
end

---@param position drawer.DrawerPosition
function DrawerState:_close_at(position)
    local drawer_name = self.open_drawers[position]
    if drawer_name == nil then
        return
    end

    local drawer = self.drawers[drawer_name]
    assert(drawer ~= nil, "Drawer not found: " .. drawer_name)

    drawer.close()
    for _, pos in ipairs(drawer.positions) do
        self.open_drawers[pos] = nil
    end
end

---@param position drawer.DrawerPosition
function DrawerState:close_by_position(position)
    self:_close_at(position)
    self:_try_open_stashed()
end

---@param name drawer.DrawerName
function DrawerState:close_by_name(name)
    for position, drawer_name in pairs(self.open_drawers) do
        if drawer_name == name then
            self:_close_at(position)
        end
    end
    self:_try_open_stashed()
end

function DrawerState:close_all()
    for position, _ in pairs(self.open_drawers) do
        self:_close_at(position)
    end
    self.stashed_drawers:clear()
end

---@param name drawer.DrawerName
function DrawerState:open(name)
    local drawer = self.drawers[name]
    assert(drawer ~= nil, "Drawer not found: " .. name)

    for _, position in ipairs(drawer.positions) do
        self:_close_at(position)
        self.open_drawers[position] = name
    end
    drawer.open()
end

---@param name drawer.DrawerName
function DrawerState:push(name)
    local drawer = self.drawers[name]
    assert(drawer ~= nil, "Drawer not found: " .. name)

    for _, position in ipairs(drawer.positions) do
        local open_drawer_name = self.open_drawers[position]
        if open_drawer_name ~= nil then
            self.stashed_drawers:push(open_drawer_name)
        end
    end
    self:open(name)
end

return {
    DrawerState = DrawerState,
}
