local window_opener = require("keke.utils.window_opener")

local opts = function(desc)
    return {
        buffer = true,
        desc = desc,
    }
end

local remap_opts = function(desc)
    return {
        buffer = true,
        remap = true,
        desc = desc,
    }
end

vim.keymap.set("n", "b", "<Plug>NetrwBrowseUpDir", opts("Up"))
vim.keymap.set("n", "w", "gn", remap_opts("enter"))
vim.keymap.set("n", "r", "R", remap_opts("Rename"))
vim.keymap.set("n", "c", "<Plug>NetrwOpenFile", opts("New"))
vim.keymap.set("n", "d", "D", remap_opts("Delete"))

---@return string filepath
local function get_path_under_cursor()
    local basename = vim.fn["netrw#Call"]("NetrwGetWord")
    local directory = vim.fn["netrw#Call"]("NetrwTreePath", vim.w.netrw_treetop)
    local is_dir = basename:sub(-1) == "/"
    if is_dir then
        return directory
    else
        return directory .. basename
    end
end

---@alias keke.netrw.Entry { path: string, type: string }

---@return keke.netrw.Entry | nil
local function get_entry_under_cursor()
    local path = get_path_under_cursor()
    local stat, _, err_name = vim.uv.fs_lstat(path)
    if stat == nil then
        vim.notify(("Failed to call lstat %s: %s"):format(path, err_name))
        return nil
    end
    return { path = path, type = stat.type }
end

---@param f fun(entry: keke.netrw.Entry)
local function with_entry(f)
    local entry = get_entry_under_cursor()
    if entry ~= nil then
        f(entry)
    end
end

---@param f fun(filepath: string)
local function with_regular_file(f)
    with_entry(function(entry)
        if entry.type == "file" then
            f(entry.path)
        end
    end)
end

vim.keymap.set("n", "v", function()
    with_regular_file(window_opener.open_file_with_vsplitting_window)
end, opts("vsplit"))
vim.keymap.set("n", "s", function()
    with_regular_file(window_opener.open_file_with_splitting_window)
end, opts("split"))
vim.keymap.set("n", "e", function()
    with_entry(function(entry)
        if entry.type == "file" then
            window_opener.open_file(entry.path)
        else
            vim.api.nvim_input("\\<Plug>NetrwLocalBrowseCheck")
        end
    end)
end, opts("edit"))
