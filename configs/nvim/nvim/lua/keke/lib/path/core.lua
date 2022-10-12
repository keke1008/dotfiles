---@class PathCore
---@field path string
---@operator div(PathCore | string): PathCore
local PathCore = {}
PathCore.__index = PathCore

---@param other PathCore
function PathCore:__div(other)
    return self:join(other)
end

-- absolute: "/" or "(/<name>)+"
-- relative: ".(/<name>)*"
---@param path string
---@return string
local function normalize_path(path)
    assert(path:len() > 0)

    -- expand "~"
    -- e.g. "~/aaa/bbb" -> "/home/<name>/aaa/bbb"
    if path:sub(1, 1) == "~" then
        ---@diagnostic disable-next-line: missing-parameter
        path = vim.fn.expand("~") .. path:sub(2, -1)
    end

    -- remove trailing slash
    if path:len() > 1 and path:sub(-1) == "/" then
        path = path:sub(1, -2)
    end

    -- remove "/."
    -- e.g. "/aaa/./bbb/ccc/." -> "/aaa/bbb/ccc"
    path = path:gsub("/%.", "")

    -- prepend "./" when `path` is relative
    -- e.g. "aaa/bbb/ccc" -> "./aaa/bbb/ccc"
    --      "/aaa/bbb/ccc" -> "/aaa/bbb/ccc" (noop)
    if path:sub(1, 1) ~= "/" and path ~= "." and path:sub(1, 2) ~= "./" then
        path = "./" .. path
    end

    return path
end

---@param path string
---@return PathCore
function PathCore.new(path)
    path = normalize_path(path)

    ---@type "absolute" | "relative"
    local type = path:sub(1, 1) == "/" and "absolute" or "relative"

    return setmetatable({
        type = type,
        path = path
    }, PathCore)
end

function PathCore:is_absolute()
    return self.path:sub(1, 1) == "/"
end

function PathCore:is_relative()
    return self.path:sub(1, 1) ~= "/"
end

---@return string
function PathCore:absolute()
    assert(self:is_absolute())
    return self.path
end

---@return string
function PathCore:name()
    if self.path == "/" then
        return "/"
    end
    return self.path:match("([^/]+)$")
end

---@return PathCore
function PathCore:parent()
    local pattern = "^(.-)/[^/]+$"
    ---@type string | nil
    local path = self.path:match(pattern)
    if path ~= nil then
        return PathCore.new(path)
    end

    path = self:is_absolute() and "/" or "."

    return PathCore.new(path)
end

---@param other PathCore | string
---@return PathCore
function PathCore:join(other)
    if type(other) == "string" then
        other = PathCore.new(other)
    end

    assert(other:is_relative(), "path must be relative.")
    local path = self.path .. "/" .. other.path
    return PathCore.new(path)
end

---@param base PathCore
---@return PathCore
function PathCore:as_absolute(base)
    if self:is_absolute() then
        return self
    end

    return base:join(self)
end

return { PathCore = PathCore }
