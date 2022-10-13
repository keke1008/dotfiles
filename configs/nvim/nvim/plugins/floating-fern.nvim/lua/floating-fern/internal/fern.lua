local utils = require("floating-fern.utils")

---@class Fern
---@field _winid number
---@field _bufnr number
---@field _on_closed fun()?
---@field _on_cursor_node_changed fun()?
---@field _cursor_node_path FloatingFern.Node?
local Fern = {}
Fern.__index = Fern


---@param winid number
---@return Fern
function Fern.open(winid)

    local self = setmetatable({
        _winid = winid,
    }, Fern)

    local augroup_name = "floating-filer-cursor-moved"

    local id = vim.api.nvim_create_autocmd("BufWinEnter", {
        callback = function(e)
            local current_bufnr = vim.api.nvim_win_get_buf(self._winid)
            if current_bufnr ~= e.buf then
                return
            end

            self._bufnr = e.buf

            local augroup = vim.api.nvim_create_augroup(augroup_name, {})
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = augroup,
                buffer = e.buf,
                callback = function()
                    local node = self:get_cursor_node()
                    if node.path == self._cursor_node_path then
                        return
                    end
                    self._cursor_node_path = node

                    if self._on_cursor_node_changed then
                        self._on_cursor_node_changed()
                    end
                end
            })

        end
    })

    vim.api.nvim_create_autocmd("WinClosed", {
        once = true,
        pattern = tostring(winid),
        callback = function()
            vim.api.nvim_del_autocmd(id)
            vim.api.nvim_del_augroup_by_name(augroup_name)
            if self._on_closed then
                self._on_closed()
            end
        end
    })

    ---@type string
    ---@diagnostic disable-next-line: missing-parameter, assign-type-mismatch
    local reveal = (vim.fn.expand("%"))
    if reveal ~= "" then
        reveal = "-reveal=" .. reveal
    end
    self._bufnr = vim.api.nvim_win_call(winid, function()
        vim.cmd("Fern . " .. reveal)
        return vim.api.nvim_get_current_buf()
    end)

    return self
end

function Fern:close()
    vim.api.nvim_win_close(self._winid, true)
end

---@return number
function Fern:winid()
    return self._winid
end

---@return number
function Fern:bufnr()
    return self._bufnr
end

---@param f fun()
function Fern:on_closed(f)
    self._on_closed = f
end

---@param f fun()
function Fern:on_cursor_node_changed(f)
    self._on_cursor_node_changed = f
end

function Fern:focus()
    vim.api.nvim_set_current_win(self._winid)
end

---@param path string
function Fern:reveal(path)
    vim.cmd("FernReveal " .. path)
end

---@return FloatingFern.Node
function Fern:get_cursor_node()
    return utils.get_cursor_node()
end

---@return string
function Fern:get_root_path()
    return utils.call_fern_helper("sync.get_root_node")._path
end

function Fern:_attach_window(target_winid)
    vim.api.nvim_win_set_buf(target_winid, self._bufnr)

    local cursor = vim.api.nvim_win_get_cursor(self._winid)
    vim.api.nvim_win_set_cursor(target_winid, cursor)
end

---@param open_winid number
---@return number new_winid
function Fern:_open_window(open_winid)
    self:_attach_window(open_winid)
    return vim.api.nvim_win_call(open_winid, function()
        vim.fn["fern#action#call"]("open:edit")
        return vim.api.nvim_get_current_win()
    end)
end

---@param open_window number
---@return number new_winid
function Fern:edit(open_window)
    return self:_open_window(open_window)
end

---@param command string
---@param target_winid number
---@return number new_winid
function Fern:_open_with_command(command, target_winid)
    local open_window = vim.api.nvim_win_call(target_winid, function()
        vim.cmd(command)
        return vim.api.nvim_get_current_win()
    end)

    return self:_open_window(open_window)
end

---@param target_winid number
---@return number new_winid
function Fern:split(target_winid)
    return self:_open_with_command("horizontal new", target_winid)
end

---@param target_winid number
---@return number new_winid
function Fern:vsplit(target_winid)
    return self:_open_with_command("vertical new", target_winid)
end

---@param target_winid number
---@return number new_winid
function Fern:tabedit(target_winid)
    return self:_open_with_command("tabnew", target_winid)
end

---@return number selected_winid
function Fern:select()
    return vim.api.nvim_win_call(self._winid, function()
        vim.fn["fern#action#call"]("open:select")
        return vim.api.nvim_get_current_win()
    end)
end

---@param rename_winid number
function Fern:rename(rename_winid)
    self:_attach_window(rename_winid)
    vim.api.nvim_win_call(rename_winid, function()
        vim.fn["fern#action#call"]("rename:edit")
    end)
end

return Fern
