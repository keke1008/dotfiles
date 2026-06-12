---@alias IndentType "tab"|integer

---@param line string
---@return IndentType|nil
local function guess_from_line(line)
    local first = line:sub(1, 1)

    if first == "\t" then
        return "tab"
    end

    if first ~= " " then
        return nil
    end

    for i = 2, #line do
        if line:sub(i, i) ~= " " then
            return i - 1
        end
    end

    return nil
end

---@param bufnr integer
---@return IndentType|nil
local function guess_from_content(bufnr)
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    for line_index = 0, line_count - 1 do
        local line = vim.api.nvim_buf_get_lines(bufnr, line_index, line_index + 1, true)[1]

        local indent = guess_from_line(line)
        if indent ~= nil then
            return indent
        end
    end

    return nil
end

---@type { indent: IndentType, filetypes: string[] }[]
local FILETYPE_INDENT_TYPES = {
    {
        indent = 2,
        filetypes = { "nix" },
    },
    {
        indent = "tab",
        filetypes = { "go", "sh", "bash", "zsh", "asm" },
    },
}

local DEFAULT_INDENT = 4

---@param filetype string
---@return IndentType
local function guess_from_filetype(filetype)
    for _, entry in ipairs(FILETYPE_INDENT_TYPES) do
        if vim.tbl_contains(entry.filetypes, filetype) then
            return entry.indent
        end
    end

    return DEFAULT_INDENT
end

---@param bufnr integer
---@param indent IndentType
local function set_indent_options(bufnr, indent)
    local opts = { buf = bufnr }

    if type(indent) == "number" then
        vim.api.nvim_set_option_value("expandtab", true, opts)
        vim.api.nvim_set_option_value("shiftwidth", indent, opts)
        vim.api.nvim_set_option_value("tabstop", indent, opts)
    else
        vim.api.nvim_set_option_value("expandtab", false, opts)
        vim.api.nvim_set_option_value("shiftwidth", DEFAULT_INDENT, opts)
        vim.api.nvim_set_option_value("tabstop", DEFAULT_INDENT, opts)
    end
end

local function guess_indent(bufnr)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    local indent = guess_from_content(bufnr) or guess_from_filetype(filetype)
    set_indent_options(bufnr, indent)
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    pattern = "*",
    callback = function(args)
        guess_indent(args.buf)
    end,
})

vim.api.nvim_create_user_command("GuessIndent", function()
    guess_indent(vim.api.nvim_get_current_buf())
end, {})
