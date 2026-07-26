-- Based on tokyonight.nvim color palette
-- https://github.com/folke/tokyonight.nvim
-- Original Copyright (c) 2021 folke, Licensed under the Apache License, Version 2.0
local c = {
    none = "none",

    fg = "#c0caf5",
    bg = "#15161e",

    dark0 = "#283457",
    dark1 = "#292e42",
    dark2 = "#394b70",
    dark3 = "#545c7e",

    red = "#db4b4b",
    blue = "#7aa2f7",
    blue0 = "#3d59a1",
    blue1 = "#2ac3de",
    green = "#9ece6a",
    teal = "#1abc9c",
    orange = "#ff9e64",
    yellow = "#e0af68",
    magenta = "#bb9af7",
    cyan = "#7dcfff",
}

---@param group string
---@param opts vim.api.keyset.highlight
local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

hl("Comment", { fg = c.dark3, italic = true })
hl("Constant", { fg = c.orange })
hl("String", { fg = c.green })
hl("Character", { link = "String" })
hl("Boolean", { link = "Constant" })
hl("Number", { link = "Constant" })
hl("Float", { link = "Number" })

hl("Function", { fg = c.blue })
hl("Identifier", { fg = c.magenta })
hl("Statement", { fg = c.magenta })
hl("Keyword", { fg = c.magenta })
hl("PreProc", { fg = c.cyan })
hl("Type", { fg = c.blue1 })
hl("Special", { fg = c.blue1 })
hl("@variable", { fg = c.fg })

hl("DiagnosticError", { fg = c.red })
hl("Error", { link = "Error" })
hl("ErrorMsg", { link = "Error" })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticWarning", { link = "DiagnosticWarn" })
hl("DiagnosticInfo", { fg = c.blue1 })
hl("DiagnosticHint", { fg = c.teal })

hl("Normal", { fg = c.fg, bg = c.none })
hl("NormalFloat", { bg = c.none })
hl("LineNr", { fg = c.dark3 })
hl("CursorLine", { bg = c.dark1 })
hl("CursorLineNr", { fg = c.blue, bold = true })
hl("CursorColumn", { bg = c.dark1 })
hl("WinSeparator", { fg = c.dark2 })
hl("FloatBorder", { fg = c.blue })
hl("Visual", { bg = c.dark0 })
hl("StatusLine", { fg = c.blue, bg = c.none })
hl("MatchParen", { fg = c.orange, bold = true })
hl("Search", { fg = c.fg, bg = c.blue0 })
hl("CurSearch", { fg = c.bg, bg = c.orange })
hl("IncSearch", { link = "CurSearch" })

hl("Directory", { fg = c.blue })
