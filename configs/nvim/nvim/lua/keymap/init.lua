local KeymapResolver = require("keymap.resolver").KeymapResolver
local CallbackCondition = require("keymap.reactive.condition").CallbackCondition
local StatefulCondition = require("keymap.reactive.condition").StatefulCondition
local FixedCondition = require("keymap.reactive.condition").FixedCondition
local BufferGroup = require("keymap.reactive.buffer_group").BufferGroup
local KeymapState = require("keymap.state").KeymapState
local KeymapMediator = require("keymap.mediator").KeymapMediator

local M = {
    _mediator = KeymapMediator.new(KeymapResolver.new(), KeymapState.new()),
    ---@type table<keymap.SignalId, keymap.BufferGroup>
    _buffers = {},

    StatefulCondition = StatefulCondition,
    CallbackCondition = CallbackCondition,
    FixedCondition = FixedCondition,
    BufferGroup = BufferGroup,
}

function M.setup()
    local autogroup = vim.api.nvim_create_augroup("d542d61bf91f.keymap", {})
    vim.api.nvim_create_autocmd("BufDelete", {
        group = autogroup,
        callback = function(args)
            local buffer = args.buf
            for _, buffers in pairs(M._buffers) do
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
        local buffers = entry.buffers or BufferGroup.global()
        M._buffers[buffers:signal_id()] = buffers

        return {
            condition = entry.when,
            action = entry.action,
            buffers = buffers,
            options = entry.options or {},
        }
    end, entries)
    M._mediator:register(mode, key, keymap_entries)
end

function M.refresh()
    M._mediator:refresh()
end

return M
