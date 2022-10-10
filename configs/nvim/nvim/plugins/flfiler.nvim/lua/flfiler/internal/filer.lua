---@diagnostic disable: unused-local

local utils = require("flfiler.utils")

---@alias FileNode { type: "file", path: string }
---@alias DirectoryNode { type: "directory", path: string, expanded: boolean }
---@alias EntryNode FileNode | DirectoryNode

---@class FilerApi
---@field edit fun()
---@field split fun()
---@field vsplit fun()
---@field tabedit fun()
---@field select fun()
---@field expand fun()
---@field collapse fun()
---@field enter fun()
---@field leave fun()
---@field delete fun()
---@field mark fun()
---@field rename fun()
---@field cursor_node fun(): EntryNode
---@field reveal fun(path: string)

---@class AbstractFiler
local AbstractFiler = {}
AbstractFiler.__index = AbstractFiler

-- Open filer in current window
---@param path string
---@return AbstractFiler
function AbstractFiler.open(path)
    error("not implemented")
end

function AbstractFiler.close()
    error("not implemented")
end

function AbstractFiler.edit()
    error("not implemented")
end

function AbstractFiler.split()
    error("not implemented")
end

function AbstractFiler.vsplit()
    error("not implemented")
end

function AbstractFiler.tabedit()
    error("not implemented")
end

function AbstractFiler.select()
    error("not implemented")
end

function AbstractFiler.expand()
    error("not implemented")
end

function AbstractFiler.collapse()
    error("not implemented")
end

function AbstractFiler.enter()
    error("not implemented")
end

function AbstractFiler.leave()
    error("not implemented")
end

function AbstractFiler.delete()
    error("not implemented")
end

function AbstractFiler.mark()
    error("not implemented")
end

function AbstractFiler.rename()
    error("not implemented")
end

---@return EntryNode
function AbstractFiler.cursor_node()
    error("not implemented")
end

---@param path string
function AbstractFiler.reveal(path)
    error("not implemented")
end

return AbstractFiler
