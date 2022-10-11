local notify = require 'notify'

notify.setup {
    timeout = 2000,
}

vim.notify = notify

---@class Spinner
---@field characters string[]
---@field index number
local Spinner = {}
Spinner.__index = Spinner

---@return Spinner
function Spinner.new()
    local characters = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    return setmetatable({
        characters = characters,
        index = #characters - 1,
    }, Spinner)
end

---@return string
function Spinner:next()
    if self.index == #self.characters - 1 then
        self.index = 1
    else
        self.index = self.index + 1
    end
    return self.characters[self.index]
end

---@class Notification
---@field level string
---@field title string
---@field message string
---@field icon string?
---@field notify_replace notify.Record?
local Notification = {}
Notification.__index = Notification

---@param level string
---@param title string
---@param message string
---@param icon string?
---@return Notification
function Notification.new(level, title, message, icon)
    return setmetatable({
        level = level,
        title = title,
        message = message,
        icon = icon,
        notify_replace = nil
    }, Notification)
end

function Notification:notify()
    self.notify_replace = notify(self.message, self.level, {
        title = self.title,
        icon = self.icon,
        replace = self.notify_replace,
        on_close = function()
            self.notify_replace = nil
        end
    })
end

---@class LspProgress
---@field spinner Spinner
---@field notification Notification
---@field timer unknown?
local LspProgress = {}
LspProgress.__index = LspProgress

---@param begin_progress WorkDownProgressBegin
---@param client_id number
---@return LspProgress
function LspProgress.new(begin_progress, client_id)
    local client_name = vim.lsp.get_client_by_id(client_id).name
    local progress_title = begin_progress.title
    local title = string.format("%s:%s", client_name, progress_title)
    local self = setmetatable({
        spinner = Spinner.new(),
        notification = Notification.new("INFO", title, ""),
        timer = nil,
    }, LspProgress)

    return self
end

---@return boolean
function LspProgress:_is_completed()
    return self.timer == nil
end

function LspProgress:_notify()
    if self:_is_completed() then
        self.notification.icon = ''
    else
        self.notification.icon = self.spinner:next()
    end
    self.notification:notify()
end

function LspProgress:_complete()
    if self:_is_completed() then
        return
    end
    self.timer:stop()
    self.timer:close()
    self.timer = nil
    self.notification.message = "Complete"
    self:_notify()
end

function LspProgress:_start_timer()
    if not self:_is_completed() then
        return
    end
    self.timer = vim.loop.new_timer()
    self.timer:start(0, 100, vim.schedule_wrap(function()
        self:_notify()
    end))
end

---@param progress WorkDownProgress
function LspProgress:update(progress)
    if progress.kind == "end" then
        self:_complete()
    else
        local percentage = progress.percentage and (progress.percentage .. "%") or ""
        self.notification.message = string.format("%s %s", percentage, progress.message or "")
        if self:_is_completed() then
            self:_start_timer()
        end
    end
end

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workDoneProgress
---@alias WorkDownProgressBegin { kind: "begin", title: string, cancellable?: boolean, message?: string, percentage?: number }
---@alias WorkDownProgressReport { kind: "report", cancellable?: boolean, message?: string, percentage?: number }
---@alias WorkDownProgressEnd { kind: "end", message?: string }
---@alias WorkDownProgress WorkDownProgressBegin | WorkDownProgressReport | WorkDownProgressEnd

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#progress
---@alias LspProgressHandler.Result { token: integer | string, value: WorkDownProgress }
---@alias LspProgressHandler.Context { method: string, client_id: number }

---@type { [integer | string]: LspProgress }
local lsp_progresses = {}

---@param result LspProgressHandler.Result
---@param ctx LspProgressHandler.Context
vim.lsp.handlers["$/progress"] = function(_, result, ctx)
    local value = result.value

    if value.kind == "begin" and not lsp_progresses[result.token] then
        lsp_progresses[result.token] = LspProgress.new(value, ctx.client_id)
    end

    lsp_progresses[result.token]:update(value)
end
