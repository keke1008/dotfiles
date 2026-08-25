local window_picker = require("keke.utils.window_picker")

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

vim.keymap.set("n", "o", "<Plug>NetrwLocalBrowseCheck", opts("Edit"))
vim.keymap.set("n", "e", "<Plug>NetrwLocalBrowseCheck", opts("Edit"))
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

---@return { path: string, basename: string, type: string } | nil
local function get_entry_under_cursor()
    local path = get_path_under_cursor()

    local stat, _, err_name = vim.uv.fs_lstat(path)
    if stat == nil then
        vim.notify(("Failed to call lstat %s: %s"):format(path, err_name))
        return nil
    end

    return {
        path = path,
        type = stat.type,
    }
end

local function get_netrw_window_width_from_config()
    local width = vim.g.netrw_winsize or 40
    if width > 0 then
        return math.floor(vim.o.columns * width / 100)
    else
        return -width
    end
end

---@param tabpage_id integer
---@return integer | nil window_id
local function get_netrw_window_id(tabpage_id)
    local netrw_bufid = vim.api.nvim_tabpage_get_var(tabpage_id, "netrw_lexbufnr")
    if type(netrw_bufid) ~= "number" then
        return nil
    end

    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage_id)) do
        local bufid = vim.api.nvim_win_get_buf(winid)
        if bufid == netrw_bufid then
            return winid
        end
    end

    return nil
end

local function open_window_if_only_netrw(bufid)
    local equalalways = vim.o.equalalways
    vim.o.equalalways = false

    vim.api.nvim_open_win(bufid, true, { split = "right", win = -1 })
    vim.o.equalalways = equalalways

    local netrw_winid = get_netrw_window_id(0)
    if netrw_winid ~= nil then
        vim.api.nvim_win_set_width(netrw_winid, get_netrw_window_width_from_config())
    end
end

---@param with fun(winid: integer, bufid: integer)
local function open_file_with(with)
    local entry = get_entry_under_cursor()
    if entry == nil or entry.type ~= "file" then
        return
    end

    local ok_winid, winid = window_picker.pick_window()
    if not ok_winid then
        return
    end

    local bufid = vim.fn.bufadd(entry.path)
    if winid == nil then
        open_window_if_only_netrw(bufid)
    else
        with(winid, bufid)
    end
end

vim.keymap.set("n", "v", function()
    open_file_with(function(winid, bufid)
        vim.api.nvim_open_win(bufid, true, { split = "left", win = winid })
    end)
end, opts("vsplit"))
vim.keymap.set("n", "s", function()
    open_file_with(function(winid, bufid)
        vim.api.nvim_open_win(bufid, true, { split = "above", win = winid })
    end)
end, opts("split"))
vim.keymap.set("n", "e", function()
    local entry = get_entry_under_cursor()
    if entry == nil then
        return
    end
    if entry.type == "file" then
        open_file_with(function(winid, bufid)
            vim.api.nvim_win_set_buf(winid, bufid)
            vim.api.nvim_set_current_win(winid)
        end)
    elseif entry.type == "directory" then
        vim.api.nvim_input("\\<Plug>NetrwLocalBrowseCheck")
    end
end, opts("edit"))
