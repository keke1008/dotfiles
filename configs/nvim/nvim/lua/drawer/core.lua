---@alias drawer.DrawerPosition string
---@alias drawer.DrawerName string

---@class drawer.Drawer
---@field name drawer.DrawerName
---@field positions drawer.DrawerPosition[]
---@field open fun()
---@field close fun()

---@class drawer.DrawerState
---@field drawers table<drawer.DrawerName, drawer.Drawer>
---@field open_drawers table<drawer.DrawerPosition, drawer.DrawerName>
local DrawerState = {}
DrawerState.__index = DrawerState

---@return drawer.DrawerState
function DrawerState.new()
    return setmetatable({
        drawers = {},
        open_drawers = {},
    }, DrawerState)
end

---@param drawer drawer.Drawer
function DrawerState:register(drawer)
    assert(self.drawers[drawer.name] == nil, "Drawer already registered: " .. drawer.name)
    self.drawers[drawer.name] = drawer
end

---@param position drawer.DrawerPosition
function DrawerState:close_by_position(position)
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

---@param name drawer.DrawerName
function DrawerState:close_by_name(name)
    for position, drawer_name in pairs(self.open_drawers) do
        if drawer_name == name then
            self:close_by_position(position)
        end
    end
end

function DrawerState:close_all()
    for position, _ in pairs(self.open_drawers) do
        self:close_by_position(position)
    end
end

---@param name drawer.DrawerName
function DrawerState:open(name)
    local drawer = self.drawers[name]
    assert(drawer ~= nil, "Drawer not found: " .. name)

    for _, position in ipairs(drawer.positions) do
        self:close_by_position(position)
        self.open_drawers[position] = name
    end
    drawer.open()
end

return {
    DrawerState = DrawerState,
}
