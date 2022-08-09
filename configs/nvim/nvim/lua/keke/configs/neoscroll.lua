local neoscroll = require 'neoscroll'

local set_keymap = require 'keke.remap'.set_keymap

neoscroll.setup { mappings = {} }

---@param lhs string
---@param rhs function
local map = function(lhs, rhs)
    set_keymap('nv', lhs, rhs)
end

local time = 100

---@param lines string|number
local scroll = function(lines)
    if type(lines) == 'string' then
        neoscroll[lines](time)
    else
        neoscroll.scroll(lines, true, time)
    end
end

map('<C-u>', function() scroll(-vim.wo.scroll) end)
map('<C-d>', function() scroll(vim.wo.scroll) end)
map('<C-b>', function() scroll(-vim.api.nvim_win_get_height(0)) end)
map('<C-f>', function() scroll(vim.api.nvim_win_get_height(0)) end)
map('<C-e>', function() scroll(0.1) end)
map('<C-y>', function() scroll(-0.1) end)
map('zt', function() scroll('zt') end)
map('zz', function() scroll('zz') end)
map('zb', function() scroll('zb') end)
