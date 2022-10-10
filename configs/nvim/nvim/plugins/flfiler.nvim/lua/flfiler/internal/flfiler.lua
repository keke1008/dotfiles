local global = require("flfiler.global")
local utils = require("flfiler.utils")
local pub_sub = require("flfiler.internal.pub_sub")
local attach_previewer = require("flfiler.internal.previewer")
local attach_action = require("flfiler.internal.action")

---@alias FilerActionKind.OpenFile "edit" | "split" | "vsplit" | "tabedit" | "select"
---@alias FilerActionKind.Directory "expand" | "collapse" | "enter" | "leave"
---@alias FilerActionKind.Entry "delete" | "rename" | "mark" | "reveal"
---@alias FilerActionKind FilerActionKind.OpenFile | FilerActionKind.Directory | FilerActionKind.Entry

---@alias FlfilerMessage.Cursor { type: "cursor_moved" }
---@alias FlfilerMessage.Close { type: "close" }
---@alias FlfilerMessage.ScrollPreview { type: "scroll_preview", direction: "up" | "down", half: boolean }
---@alias FlfilerMessage.FilerAction { type: "filer_action", action: FilerActionKind, remain_cursor?: boolean , path?: string}
---@alias FlfilerMessage FlfilerMessage.Cursor | FlfilerMessage.Close | FlfilerMessage.ScrollPreview | FlfilerMessage.FilerAction

---@class Flfiler
---@field private _active_filer nil | { filer_winid: number, caller_winid: number, publish: Publish<FlfilerMessage> }
---@field private _filer AbstractFiler
local Flfiler = {}
Flfiler.__index = Flfiler

---@param config FlfilerConfig
---@return Flfiler
function Flfiler.new(config)
    local self = {
        _active_filer = nil,
        _filer = config.filer,
    }
    return setmetatable(self, Flfiler)
end

---@return boolean
function Flfiler:is_open()
    return self._active_filer ~= nil
end

function Flfiler:assert_is_open()
    assert(self:is_open(), "Flfiler has already closed.")
end

---@param filer_winid number
---@param publish Publish<FlfilerMessage>
function Flfiler:_install_autocmd(filer_winid, publish)
    local augroup = vim.api.nvim_create_augroup("Flfiler", {})
    local cursor_autocmd = nil

    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        callback = function(e)
            local winid = vim.api.nvim_get_current_win()
            if winid ~= filer_winid then
                return
            end

            cursor_autocmd = vim.api.nvim_create_autocmd("CursorMoved", {
                group = augroup,
                buffer = e.buf,
                callback = function()
                    publish({ type = "cursor_moved" })
                end,
            })
        end
    })

    vim.api.nvim_create_autocmd("BufLeave", {
        group = augroup,
        callback = function()
            local winid = vim.api.nvim_get_current_win()
            if winid ~= filer_winid then
                return
            end

            if cursor_autocmd then
                vim.api.nvim_del_autocmd(cursor_autocmd)
                cursor_autocmd = nil
            end
        end
    })

    vim.api.nvim_create_autocmd("WinClosed", {
        once = true,
        group = augroup,
        pattern = tostring(filer_winid),
        callback = function()
            publish({ type = "close" })
            vim.api.nvim_del_augroup_by_id(augroup)
            self._active_filer = nil
        end
    })
end

---@param path string
function Flfiler:open(path)
    if self._active_filer then
        return
    end

    ---@type Publish<FlfilerMessage>, Subscribe<FlfilerMessage>
    local publish, subscribe = pub_sub("FlfilerMessage")
    local caller_winid = vim.api.nvim_get_current_win()

    local filer_winid = utils.open_window(global.get_config().layout.filer())
    vim.api.nvim_set_current_win(filer_winid)
    self:_install_autocmd(filer_winid, publish)
    self._filer.open(path)

    self._active_filer = {
        filer_winid = filer_winid,
        caller_winid = caller_winid,
        publish = publish,
    }

    attach_previewer(subscribe, self._filer)
    attach_action(subscribe, self._filer, self._active_filer.filer_winid, self._active_filer.caller_winid)
end

function Flfiler:close()
    self:assert_is_open()
    self._filer:close()
end

function Flfiler:focus()
    self:assert_is_open()
    vim.api.nvim_set_current_win(self._active_filer.filer_winid)
end

function Flfiler:blur()
    self:assert_is_open()
    vim.api.nvim_set_current_win(self._active_filer.caller_winid)
end

---@param message FlfilerMessage
function Flfiler:publish(message)
    self:assert_is_open()
    self._active_filer.publish(message)
end

---@return AbstractFiler
function Flfiler:filer()
    return self._filer
end

return Flfiler
