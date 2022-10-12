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

---@class ProgressNotification
---@field title string
---@field message string
---@field spinner Spinner
---@field notify_replace notify.Record?
---@field timer any
local ProgressNotification = {}
ProgressNotification.__index = ProgressNotification

---@param title string
---@param message string
---@return ProgressNotification
function ProgressNotification.new(title, message)
    return setmetatable({
        title = title,
        message = message,
        spinner = Spinner.new(),
        notify_replace = nil,
        timer = nil,
    }, ProgressNotification)
end

---@param icon string
function ProgressNotification:_notify(icon)
    self.notify_replace = notify(self.message, "INFO", {
        title = self.title,
        icon = icon,
        replace = self.notify_replace,
        on_close = function()
            self.notify_replace = nil
        end
    })
end

---@param message string
function ProgressNotification:progress(message)
    self.message = message
    if not self.timer then
        self.timer = vim.loop.new_timer()
        self.timer:start(0, 100, vim.schedule_wrap(function()
            self:_notify(self.spinner:next())
        end))
    end
end

function ProgressNotification:complete()
    if self.timer then
        self.timer:stop()
        self.timer:close()
        self.timer = nil
    end
    self.message = "Complete"
    self:_notify('')
end

---@class LspProgress
---@field notification ProgressNotification
local LspProgress = {}
LspProgress.__index = LspProgress

---@param begin_progress WorkDownProgressBegin
---@param ctx LspProgressHandler.Context
function LspProgress.new(begin_progress, ctx)
    local client_name = vim.lsp.get_client_by_id(ctx.client_id).name
    local progress_title = begin_progress.title
    local title = string.format("%s:%s", client_name, progress_title)
    local self = setmetatable({
        notification = ProgressNotification.new(title, ""),
    }, LspProgress)
    return self
end

---@param progress WorkDownProgress
function LspProgress:update(progress)
    if progress.kind == "end" then
        self.notification:complete()
    else
        local percentage = progress.percentage and (progress.percentage .. "%") or ""
        local message = string.format("%s %s", percentage, progress.message or "")
        self.notification:progress(message)
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
        lsp_progresses[result.token] = LspProgress.new(value, ctx)
    end

    lsp_progresses[result.token]:update(value)
end
