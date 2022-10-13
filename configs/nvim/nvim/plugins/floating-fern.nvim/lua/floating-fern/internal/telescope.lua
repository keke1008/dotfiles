local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local builtin = require 'telescope.builtin'

---@class FloatingFern.Telescope
---@field _live_grep_result { path: string, cursor: { [1]: number, [2]: number }} | nil
local Telescope = {}
Telescope.__index = Telescope

function Telescope.new()
    return setmetatable({}, Telescope)
end

---@return { [1]: number, [2]: number } | nil
function Telescope:cursor_position()
    return self._live_grep_result and self._live_grep_result.cursor
end

---@param path string
function Telescope:on_cursor_node_changed(path)
    if not self._live_grep_result or self._live_grep_result.path == path then
        return
    end
    self._live_grep_result = nil
end

---@param builtin_name string
---@param option table
---@param callback fun(any)
function Telescope:_invoke(builtin_name, option, callback)
    builtin[builtin_name](option)
    actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
            callback(selection)
        end
    end)
end

---@param path string
---@param callback fun(path: string)
function Telescope:find_files(path, callback)
    local builtin_name = "find_files"
    self:_invoke(builtin_name, { cwd = path }, function(selection)
        callback(selection[1])
    end)
end

---@param path string
---@param callback fun(path: string)
function Telescope:live_grep(path, callback)
    local builtin_name = "live_grep"
    if vim.fn.executable('rg') == 0 then
        error('`rg` not found')
    end

    self:_invoke(builtin_name, { cwd = path }, function(selection)
        if #path ~= 1 and path:sub(-1, -1) == "/" then
            path = path:sub(0, -2)
        end

        self._live_grep_result = {
            path = path .. "/" .. selection.filename,
            cursor = { selection.lnum, selection.col - 1 }
        }
        callback(selection.filename)
    end)
end

return Telescope
