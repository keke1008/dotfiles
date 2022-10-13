local Fern = require("floating-fern.internal.fern")
local Preview = require("floating-fern.internal.preview")
local window = require("floating-fern.internal.window")
local Telescope = require("floating-fern.internal.telescope")

---@class Filer
---@field _fern Fern
---@field _preview Preview
---@field _caller_winid number
---@field _telescope FloatingFern.Telescope
---@field _on_closed fun()
local Filer = {}
Filer.__index = Filer

---@return Filer
function Filer.open()
    local self = setmetatable({
        _fern = Fern.open(window.fern()),
        _preview = Preview.open(window.preview()),
        _telescope = Telescope.new(),
        _caller_winid = vim.api.nvim_get_current_win(),
    }, Filer)
    self._fern:focus()

    self._fern:on_closed(function()
        self._preview:close()
        if self._on_closed then
            self._on_closed()
        end
    end)
    self._fern:on_cursor_node_changed(function()
        local node = self._fern:get_cursor_node()
        self._preview:show(node.path)
        self._telescope:on_cursor_node_changed(node.path)
    end)

    return self
end

function Filer:close()
    self._fern:close()
end

---@param f fun()
function Filer:on_closed(f)
    self._on_closed = f
end

function Filer:get_cursor_node()
    return self._fern:get_cursor_node()
end

function Filer:focus()
    self._fern:focus()
end

function Filer:blur()
    local winid = self._caller_winid
    if not vim.api.nvim_win_is_valid(winid) then
        winid = vim.fn.win_getid(1)
    end
    vim.api.nvim_set_current_win(winid)
end

---@param winid number
---@param close boolean
function Filer:_open_file(winid, close)
    local cursor = self._telescope:cursor_position()
    if cursor then
        vim.api.nvim_win_set_cursor(winid, cursor)
    end
    if close then
        vim.api.nvim_set_current_win(winid)
        self:close()
    end
end

---@param close boolean
function Filer:edit(close)
    local winid = self._fern:edit(self._caller_winid)
    self:_open_file(winid, close)
end

---@param close boolean
function Filer:split(close)
    local winid = self._fern:split(self._caller_winid)
    self:_open_file(winid, close)
end

---@param close boolean
function Filer:vsplit(close)
    local winid = self._fern:vsplit(self._caller_winid)
    self:_open_file(winid, close)
end

---@param close boolean
function Filer:tabedit(close)
    local winid = self._fern:tabedit(self._caller_winid)
    self:_open_file(winid, close)
end

function Filer:select(close)
    local winid = self._fern:select()
    self:_open_file(winid, close)
end

function Filer:rename()
    local winid = window.rename()
    self._fern:rename(winid)
end

---@param direction "up"  "down"
---@param half boolean
function Filer:scroll_preview(direction, half)
    self._preview:scroll(direction, half)
end

function Filer:telescope_find_files()
    local root = self._fern:get_root_path()
    self._telescope:find_files(root, function(path)
        self._fern:reveal(path)
    end)
end

function Filer:telescope_live_grep()
    local root = self._fern:get_root_path()
    self._telescope:live_grep(root, function(path)
        self._fern:reveal(path)
    end)
end

return Filer
