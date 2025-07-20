local KeymapResolver = require("keymap.resolver").KeymapResolver
local CallbackCondition = require("keymap.reactive.condition").CallbackCondition
local StatefulCondition = require("keymap.reactive.condition").StatefulCondition
local BufferGroup = require("keymap.reactive.buffer_group").BufferGroup
local KeymapState = require("keymap.state").KeymapState
local KeymapMediator = require("keymap.mediator").KeymapMediator

local M = {
    _mediator = KeymapMediator.new(KeymapResolver.new(), KeymapState.new()),
    ---@type keymap.BufferGroup[]
    _buffers = {},
    ---@type keymap.BufferGroup
    _global_buffer = nil,
}

function M.setup()
    M._global_buffer = M.new_buffer_group()
    M._global_buffer:add("global")

    local autogroup = vim.api.nvim_create_augroup("d542d61bf91f.keymap", {})
    vim.api.nvim_create_autocmd("BufDelete", {
        group = autogroup,
        callback = function(args)
            local buffer = args.buf
            for _, buffers in ipairs(M._buffers) do
                buffers:remove(buffer)
            end
        end
    })

    local subcommands = {
        refresh = M.refresh
    }

    vim.api.nvim_create_user_command(
        "Keymap",
        function(args)
            local subcommand = args.fargs[1]
            local handler = subcommands[subcommand]
            if handler then
                handler()
            else
                vim.notify("Unknown keymap subcommand: " .. subcommand, vim.log.levels.ERROR)
            end
        end, {
            desc = "Refresh keymaps",
            nargs = '+',
            complete = function()
                return vim.tbl_keys(subcommands)
            end
        })
end

---@alias keymap.RegisterEntry {
---    when: keymap.Condition,
---    action: keymap.Action,
---    buffers: keymap.BufferGroup?,
---    options: keymap.KeymapOptions?,
---}

---@param mode keymap.Mode
---@param key keymap.Key
---@param entries keymap.RegisterEntry[]
function M.register(mode, key, entries)
    ---@type keymap.KeymapEntry[]
    local keymap_entries = vim.tbl_map(function(entry)
        return {
            condition = entry.when,
            action = entry.action,
            buffers = entry.buffers or M.new_global_buffer_group(),
            options = entry.options or {},
        }
    end, entries)
    M._mediator:register(mode, key, keymap_entries)
end

---@param predicate fun(): boolean
---@return keymap.CallbackCondition
function M.new_callback_condition(predicate)
    local condition = CallbackCondition.new(predicate)
    M._mediator:register_signal(condition)
    return condition
end

---@param initial boolean?
---@return keymap.StatefulCondition
function M.new_stateful_condition(initial)
    local condition = StatefulCondition.new(initial)
    M._mediator:register_signal(condition)
    return condition
end

---@return keymap.BufferGroup
function M.new_buffer_group()
    local buffers = BufferGroup.new()
    M._mediator:register_signal(buffers)
    table.insert(M._buffers, buffers)
    return buffers
end

---@return keymap.BufferGroup
function M.new_global_buffer_group()
    if M._global_buffer ~= nil then
        error("Please call `require('keymap').setup()` before creating a global buffer group.")
    end

    return M._global_buffer
end

function M.refresh()
    M._mediator:refresh()
end

return M
