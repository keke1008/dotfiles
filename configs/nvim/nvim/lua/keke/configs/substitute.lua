local remap = vim.keymap.set

remap("n", "r", function() require("substitute").operator() end)
remap("n", "rr", function() require("substitute").line() end)
remap("n", "R", function() require("substitute").eol() end)
remap("x", "r", function() require("substitute").visual() end)
