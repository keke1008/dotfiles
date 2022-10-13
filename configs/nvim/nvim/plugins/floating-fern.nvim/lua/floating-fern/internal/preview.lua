---@param path string
---@return boolean
local function is_text_file(path)
    local file, err = io.popen("file -b --mime-type " .. path, "r")
    if not file then
        error(err)
    end

    ---@type string
    local mimetype = file:read("*a")
    return mimetype:sub(1, 4) == "text" or mimetype == "inode/x-empty\n"
end

---@param path string
local function is_file_size_small(path)
    local size_byte = vim.fn.getfsize(path)
    return size_byte ~= -2 and size_byte < 1 * 1000 * 1000 -- 1MB
end

---@param path string
---@return boolean
local function is_valid_file(path)
    return is_text_file(path) and is_file_size_small(path)
end

---@class Preview
---@field _winid number
---@field _bufnr number
local Preview = {}
Preview.__index = Preview

---@param winid number
---@return Preview
function Preview.open(winid)
    return setmetatable({
        _winid = winid,
        _bufnr = vim.api.nvim_win_get_buf(winid),
    }, Preview)
end

---@param path string
function Preview:show(path)
    if not is_valid_file(path) then
        return
    end

    local bufname = "FlfilerPreview://" .. path
    vim.api.nvim_buf_set_name(self._bufnr, bufname)
    vim.api.nvim_buf_call(self._bufnr, function()
        vim.cmd [[filetype detect]]
    end)

    local lines = vim.fn.readfile(path)
    local ei = vim.o.eventignore
    vim.o.eventignore = "all"
    pcall(vim.api.nvim_buf_set_lines, self._bufnr, 0, -1, true, lines)
    vim.o.eventignore = ei

end

function Preview:close()
    vim.api.nvim_win_close(self._winid, true)
end

---@param direction "up"  "down"
---@param half boolean
function Preview:scroll(direction, half)
    local map = {
        up = { [true] = [[\<C-u>]], [false] = [[\<C-b>]] },
        down = { [true] = [[\<C-d>]], [false] = [[\<C-f>]] },
    }
    local key = map[direction][half]
    vim.api.nvim_win_call(self._winid, function()
        vim.cmd([[execute "normal! ]] .. key .. [["]])
    end)
end

return Preview
