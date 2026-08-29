---@return string

local function get_session_file_path()
    local cwd = vim.fn.getcwd()
    local stem = cwd:gsub("/", "__")
    local basename = stem .. ".vim"

    local xdg_data_home = vim.env.XDG_DATA_HOME or (vim.env.HOME .. ".local/share")
    local dirname = xdg_data_home .. "/nvim/keke-sessions"

    return dirname .. "/" .. basename
end

local function should_save_session()
    return vim.bo.filetype ~= "gitcommit"
end

local function should_restore_session()
    return vim.fn.argc() == 0 and vim.fn.filereadable(get_session_file_path()) == 1
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if should_save_session() then
            local path = get_session_file_path()
            local dirname = vim.fs.dirname(path)
            vim.fn.mkdir(dirname, "p")

            vim.cmd({
                cmd = "mksession",
                bang = true,
                args = { path },
            })
        end
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    nested = true, -- Ensure trigger other autocmds defined in the session file
    callback = function()
        if should_restore_session() then
            vim.cmd.source(get_session_file_path())

            --- Redraw netrw window
            vim.iter(vim.api.nvim_list_wins())
                :filter(function(winid)
                    local bufid = vim.api.nvim_win_get_buf(winid)
                    return vim.api.nvim_get_option_value("filetype", { buf = bufid }) == "netrw"
                end)
                :each(function(winid)
                    vim.api.nvim_win_call(winid, function()
                        vim.cmd.edit(".")
                    end)
                end)
        end
    end,
})
